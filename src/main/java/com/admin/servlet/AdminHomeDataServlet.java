package com.admin.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import com.DBMS.DBConnect;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/home-data")
public class AdminHomeDataServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        resp.setContentType("application/json");

        Connection conn = DBConnect.getConn();
        PrintWriter out = resp.getWriter();

        try {

            Statement st = conn.createStatement();

            ResultSet rs1 = st.executeQuery("SELECT COUNT(*) FROM book_dtls");
            rs1.next();
            int totalBooks = rs1.getInt(1);

            ResultSet rs2 = st.executeQuery("SELECT COUNT(*) FROM book_order");
            rs2.next();
            int totalOrders = rs2.getInt(1);

            ResultSet rs3 = st.executeQuery(
                    "SELECT IFNULL(SUM(total_amount),0) FROM book_order WHERE payment_status='PAID'");
            rs3.next();
            double totalRevenue = rs3.getDouble(1);

            ResultSet rs4 = st.executeQuery(
                    "SELECT COUNT(*) FROM book_order WHERE return_status='REQUESTED'");
            rs4.next();
            int pendingReturns = rs4.getInt(1);

            // ===== Monthly Revenue Data =====
            ResultSet rs5 = st.executeQuery(
                    "SELECT MONTH(order_date) as m, IFNULL(SUM(total_amount),0) as total " +
                            "FROM book_order WHERE payment_status='PAID' " +
                            "AND YEAR(order_date)=YEAR(CURDATE()) " +
                            "GROUP BY MONTH(order_date)");
            double[] revenueChart = new double[12];
            while (rs5.next()) {
                int month = rs5.getInt("m");
                revenueChart[month - 1] = rs5.getDouble("total");
            }

            // ===== Build JSON manually =====
            out.print("{");
            out.print("\"totalBooks\":" + totalBooks + ",");
            out.print("\"totalOrders\":" + totalOrders + ",");
            out.print("\"totalRevenue\":" + totalRevenue + ",");
            out.print("\"pendingReturns\":" + pendingReturns + ",");
            out.print("\"revenueChartData\":[");

            for (int i = 0; i < 12; i++) {
                out.print(revenueChart[i]);
                if (i < 11)
                    out.print(",");
            }

            out.print("]");
            out.print("}");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
