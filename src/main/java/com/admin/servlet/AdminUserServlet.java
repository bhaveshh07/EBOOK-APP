package com.admin.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.DBMS.DBConnect;
import com.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        List<User> list = new ArrayList<>();

        try (Connection conn = DBConnect.getConn()) {

            String sql = "SELECT u.*, " +
                    "(SELECT COUNT(*) FROM audit_logs al WHERE al.user_id = u.id) AS activity_count, " +
                    "(SELECT IFNULL(SUM(amount),0) FROM seller_wallet_transactions sw WHERE sw.seller_id = u.id AND sw.type='CREDIT') AS revenue "
                    +
                    "FROM user u ORDER BY u.id DESC";

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                User u = new User();

                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setAccountStatus(rs.getString("account_status"));
                u.setRole(rs.getString("role"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setLastLogin(rs.getTimestamp("last_login"));
                u.setActivityCount(rs.getInt("activity_count"));
                u.setRevenue(rs.getDouble("revenue"));

                list.add(u);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("userList", list);
        req.getRequestDispatcher("/admin/manage_users.jsp")
                .forward(req, resp);
    }
}
