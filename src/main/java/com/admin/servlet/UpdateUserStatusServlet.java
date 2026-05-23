package com.admin.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.DBMS.DBConnect;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/update-user-status")
public class UpdateUserStatusServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req,
            HttpServletResponse resp)
            throws IOException {

        int userId = Integer.parseInt(req.getParameter("id"));
        String status = req.getParameter("status");

        try (Connection conn = DBConnect.getConn()) {

            String sql = "UPDATE user SET account_status=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect("users");
    }
}
