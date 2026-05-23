package com.admin.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.DBMS.DBConnect;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/export-revenue")
public class ExportRevenueServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        resp.setContentType("text/csv");
        resp.setHeader("Content-Disposition", "attachment; filename=revenue_report.csv");

        PrintWriter out = resp.getWriter();
        out.println("Order ID,User,Amount,Payment Status");

        try {
            String sql = "SELECT order_id,user_name,total_amount,payment_status FROM book_order";
            PreparedStatement ps = DBConnect.getConn().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                out.println(
                        rs.getString(1) + "," +
                                rs.getString(2) + "," +
                                rs.getDouble(3) + "," +
                                rs.getString(4));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
