package com.user.servlet;

import java.io.IOException;

import com.DAO.UserDAOImpl;
import com.DBMS.DBConnect;
import com.util.AuditLogger;
import com.util.PasswordHash;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/resetPassword")
public class ResetPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/forgot_password.jsp");
            return;
        }

        System.out.println("otpVerified = " + session.getAttribute("otpVerified"));
        System.out.println("fpEmail = " + session.getAttribute("fpEmail"));

        if (session == null ||
                session.getAttribute("otpVerified") == null ||
                !(Boolean) session.getAttribute("otpVerified")) {

            resp.sendRedirect(req.getContextPath() + "/forgot_password.jsp");
            return;
        }

        String newPass = req.getParameter("password");
        String email = (String) session.getAttribute("fpEmail");

        if (email == null) {
            resp.sendRedirect(req.getContextPath() + "/forgot_password.jsp");
            return;
        }

        if (newPass == null || newPass.trim().isEmpty()) {
            session.setAttribute("failedMsg", "Password cannot be empty");
            resp.sendRedirect(req.getContextPath() + "/reset_password.jsp");
            return;
        }

        if (newPass.length() < 6) {
            session.setAttribute("failedMsg", "Password must be at least 6 characters");
            resp.sendRedirect(req.getContextPath() + "/reset_password.jsp");
            return;
        }

        String encPass = PasswordHash.hashPassword(newPass);

        UserDAOImpl dao = new UserDAOImpl(DBConnect.getConn());
        boolean updated = dao.updatePassword(email, encPass);

        if (updated) {
            AuditLogger.log(req,
                    "PASSWORD_RESET",
                    "USER",
                    email,
                    "Password reset successful");
            session.removeAttribute("fpOtp");
            session.removeAttribute("fpEmail");
            session.removeAttribute("fpOtpTime");
            session.removeAttribute("otpVerified");

            session.setAttribute("succMsg", "Password Updated Successfully!");

            resp.sendRedirect(req.getContextPath() + "/login.jsp");

        } else {

            session.setAttribute("failedMsg", "Password update failed. Try again.");
            resp.sendRedirect(req.getContextPath() + "/reset_password.jsp");
        }
    }
}