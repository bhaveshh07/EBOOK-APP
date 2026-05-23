package com.admin.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.DBMS.DBConnect;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/revenue-by-date")
public class RevenueByDateServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        String from = req.getParameter("from");
        String to = req.getParameter("to");

        System.out.println("FROM param = [" + from + "]");
        System.out.println("TO param = [" + to + "]");

        double totalRevenue = 0;

        if (from == null || from.isEmpty() || to == null || to.isEmpty()) {
            out.print("{\"totalRevenue\":0}");
            return;
        }

        try (Connection conn = DBConnect.getConn();
                PreparedStatement ps = conn.prepareStatement(
                        "SELECT IFNULL(SUM(total_amount),0) " +
                                "FROM book_order " +
                                "WHERE UPPER(payment_status) = 'PAID' " +
                                "AND DATE(order_date) BETWEEN ? AND ?")) {

            ps.setString(1, from);
            ps.setString(2, to);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalRevenue = rs.getDouble(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        out.print("{\"totalRevenue\":" + totalRevenue + "}");
    }
}
