package com.user.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.util.UUID;
import com.DAO.UserDAOImpl;
import com.DAO.AuditLogDAOImpl;
import com.DAO.LoginAttemptDAOImpl;
import com.DBMS.DBConnect;
import com.entity.User;
import com.util.AuditLogger;
import com.util.PasswordHash;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp)
                        throws ServletException, IOException {

                try {

                        HttpSession session = req.getSession();

                        String email = req.getParameter("email");
                        String password = req.getParameter("password");

                        UserDAOImpl userDao = new UserDAOImpl(DBConnect.getConn());

                        // ================= ADMIN LOGIN =================
                        if ("admin@gmail.com".equals(email) &&
                                        "admin".equals(password)) {

                                User admin = new User();
                                admin.setName("Admin");
                                session.setAttribute("userobj", admin);
                                session.setAttribute("role", "ADMIN");
                                // ADD THIS
                                String csrfToken = UUID.randomUUID().toString();
                                session.setAttribute("CSRF_TOKEN", csrfToken);
                                resp.sendRedirect("admin/home");
                                return;
                        }

                        // =============== FETCH USER ===================
                        User user = userDao.getUserByEmail(email);

                        if (user == null) {

                                AuditLogger.log(req,
                                                "LOGIN_FAILED",
                                                "USER",
                                                email,
                                                "Login attempt with non-existing email");

                                session.setAttribute("failedMsg",
                                                "Email or Password Invalid!");

                                resp.sendRedirect("login.jsp");
                                return;
                        }

                        //  Account Status Check AFTER null check
                        if ("FROZEN".equals(user.getAccountStatus())) {
                                session.setAttribute("failedMsg",
                                                "Your account is temporarily frozen. Contact support.");
                                resp.sendRedirect("login.jsp");
                                return;
                        }

                        if ("TERMINATED".equals(user.getAccountStatus())) {
                                session.setAttribute("failedMsg",
                                                "Your account has been permanently terminated.");
                                resp.sendRedirect("login.jsp");
                                return;
                        }

                        // ============ BRUTE FORCE DAO =================
                        LoginAttemptDAOImpl attemptDao = new LoginAttemptDAOImpl(DBConnect.getConn());

                        attemptDao.createIfNotExists(user.getId());

                        // ============== CHECK LOCK ====================
                        if (attemptDao.isAccountLocked(user.getId())) {

                                Timestamp lockUntil = attemptDao.getByUserId(user.getId()).getLockUntil();

                                long remainingMillis = lockUntil.getTime() - System.currentTimeMillis();

                                long remainingSeconds = remainingMillis / 1000;

                                session.setAttribute("lockSeconds", remainingSeconds);

                                session.setAttribute("failedMsg",
                                                "Account locked.");

                                resp.sendRedirect("login.jsp");
                                return;
                        }

                        // ============= PASSWORD CHECK =================
                        if (!PasswordHash.checkPassword(password, user.getPassword())) {

                                attemptDao.increaseAttempt(user.getId());

                                int attempts = attemptDao.getByUserId(user.getId())
                                                .getAttemptCount();

                                if (attempts >= 5) {

                                        Timestamp lockTime = new Timestamp(
                                                        System.currentTimeMillis()
                                                                        + (15 * 60 * 1000));

                                        String sql = "UPDATE login_attempts SET lock_until=? WHERE user_id=?";

                                        PreparedStatement ps = DBConnect.getConn()
                                                        .prepareStatement(sql);

                                        ps.setTimestamp(1, lockTime);
                                        ps.setInt(2, user.getId());
                                        ps.executeUpdate();
                                        AuditLogger.log(req,
                                                        "ACCOUNT_LOCKED",
                                                        "USER",
                                                        String.valueOf(user.getId()),
                                                        "Account locked due to too many attempts");

                                        session.setAttribute("failedMsg",
                                                        "Too many attempts. Account locked for 15 minutes.");
                                } else {
                                        session.setAttribute("failedMsg",
                                                        "Email or Password Invalid!");
                                }
                                AuditLogger.log(req,
                                                "LOGIN_FAILED",
                                                "USER",
                                                String.valueOf(user.getId()),
                                                "Incorrect password attempt");
                                // MONITORING CHECK
                                AuditLogDAOImpl monitorDao = new AuditLogDAOImpl();
                                int failures = monitorDao.countFailedLoginsLastHour(user.getId());

                                if (failures >= 10) {

                                        AuditLogger.log(req,
                                                        "SUSPICIOUS_ACTIVITY",
                                                        "USER",
                                                        String.valueOf(user.getId()),
                                                        "More than 10 failed logins in last hour");

                                        System.out.println(" Suspicious activity detected for user "
                                                        + user.getId());
                                }
                                String ip = req.getRemoteAddr();

                                int ipFailures = monitorDao.countFailedLoginsFromIPLastHour(ip);

                                if (ipFailures >= 15) {
                                        try (Connection conn = DBConnect.getConn()) {

                                                String blockSql = "INSERT INTO blocked_ips (ip_address, blocked_until, reason) "
                                                                +
                                                                "VALUES (?, NOW() + INTERVAL 1 HOUR, ?) " +
                                                                "ON DUPLICATE KEY UPDATE " +
                                                                "blocked_until = NOW() + INTERVAL 1 HOUR, " +
                                                                "reason = VALUES(reason)";

                                                PreparedStatement ps = conn.prepareStatement(blockSql);

                                                ps.setString(1, ip);
                                                ps.setString(2, "Excessive failed login attempts");
                                                ps.executeUpdate();
                                        }

                                        AuditLogger.log(req,
                                                        "IP_SUSPICIOUS_ACTIVITY",
                                                        "SYSTEM",
                                                        ip,
                                                        "More than 15 failed logins from same IP in 1 hour");

                                        System.out.println(" Suspicious IP detected: " + ip);
                                }

                                resp.sendRedirect("login.jsp");
                                return;
                        }

                        // ============== SUCCESS LOGIN =================
                        attemptDao.resetAttempts(user.getId());
                        String csrfToken = UUID.randomUUID().toString();
                        session.setAttribute("CSRF_TOKEN", csrfToken);
                        session.setAttribute("userobj", user);
                        session.setAttribute("userId", user.getId());
                        session.setAttribute("role", "USER");

                        AuditLogger.log(req,
                                        "LOGIN_SUCCESS",
                                        "USER",
                                        String.valueOf(user.getId()),
                                        "User logged in successfully");
                        resp.sendRedirect("index.jsp");

                } catch (Exception e) {
                        e.printStackTrace();
                }
        }
}
