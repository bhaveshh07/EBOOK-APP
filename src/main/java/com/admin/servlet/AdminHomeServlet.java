package com.admin.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.DBMS.DBConnect;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/home")
public class AdminHomeServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Connection conn = DBConnect.getConn();

        try {
            Statement st = conn.createStatement();

            // ===== METRICS =====
            ResultSet rs1 = st.executeQuery("SELECT COUNT(*) FROM book_dtls");
            rs1.next();
            req.setAttribute("totalBooks", rs1.getInt(1));

            ResultSet rs2 = st.executeQuery("SELECT COUNT(*) FROM book_order");
            rs2.next();
            req.setAttribute("totalOrders", rs2.getInt(1));

            ResultSet rs3 = st.executeQuery(
                    "SELECT IFNULL(SUM(total_amount),0) FROM book_order WHERE payment_status='PAID'");
            rs3.next();
            req.setAttribute("totalRevenue", rs3.getDouble(1));

            ResultSet rs4 = st.executeQuery(
                    "SELECT COUNT(*) FROM book_order WHERE return_status='REQUESTED'");
            rs4.next();
            req.setAttribute("pendingReturns", rs4.getInt(1));

            // ===== MONTHLY ORDERS =====
            ResultSet monthly = st.executeQuery(
                    "SELECT MONTH(order_date), COUNT(*) " +
                            "FROM book_order " +
                            "WHERE YEAR(order_date) = YEAR(CURDATE()) " +
                            "GROUP BY MONTH(order_date)");

            List<Integer> orderData = new ArrayList<>();
            for (int i = 0; i < 12; i++) {
                orderData.add(0);
            }

            while (monthly.next()) {
                orderData.set(monthly.getInt(1) - 1, monthly.getInt(2));
            }

            req.setAttribute("orderChartData", orderData);

            // ===== MONTHLY REVENUE =====
            ResultSet revenue = st.executeQuery(
                    "SELECT MONTH(order_date), SUM(total_amount) " +
                            "FROM book_order " +
                            "WHERE payment_status='PAID' " +
                            "AND YEAR(order_date) = YEAR(CURDATE()) " +
                            "GROUP BY MONTH(order_date)");

            List<Double> revenueData = new ArrayList<>();
            for (int i = 0; i < 12; i++) {
                revenueData.add(0.0);
            }
            while (revenue.next()) {
                revenueData.set(revenue.getInt(1) - 1, revenue.getDouble(2));
            }

            req.setAttribute("revenueChartData", revenueData);
            // ===== STATUS DISTRIBUTION =====
            ResultSet statusRs = st.executeQuery(
                    "SELECT status, COUNT(*) FROM book_order GROUP BY status");

            int placed = 0;
            int shipped = 0;
            int delivered = 0;
            int refunded = 0;

            while (statusRs.next()) {
                String status = statusRs.getString(1);
                int count = statusRs.getInt(2);

                switch (status) {
                    case "PLACED":
                        placed = count;
                        break;
                    case "SHIPPED":
                        shipped = count;
                        break;
                    case "DELIVERED":
                        delivered = count;
                        break;
                    case "REFUNDED":
                        refunded = count;
                        break;
                }
            }

            req.setAttribute("placedCount", placed);
            req.setAttribute("shippedCount", shipped);
            req.setAttribute("deliveredCount", delivered);
            req.setAttribute("refundedCount", refunded);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                conn.close();
            } catch (Exception e) {
            }
        }

        req.getRequestDispatcher("/admin/home.jsp")
                .forward(req, resp);
    }
}
