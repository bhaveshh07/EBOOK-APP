package com.admin.servlet;

import java.io.IOException;
import java.util.List;

import com.DAO.BookOrderImpl;
import com.DBMS.DBConnect;
import com.entity.Book_Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin_orders")
public class AdminOrdersServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        BookOrderImpl dao = new BookOrderImpl(DBConnect.getConn());
        List<Book_Order> list = dao.getAllOrders();

        // Send order list to JSP
        req.setAttribute("orderList", list);

        // Correct Revenue Calculation (ONLY PAID ORDERS)
        double totalRevenue = dao.getTotalPaidRevenue();

        req.setAttribute("totalRevenue", totalRevenue);

        req.getRequestDispatcher("admin/order.jsp").forward(req, resp);
    }
}
