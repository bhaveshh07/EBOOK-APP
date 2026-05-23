package com.user.servlet;

import java.io.IOException;

import com.DAO.BookOrderImpl;
import com.DBMS.DBConnect;
import com.entity.Book_Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/payment/mark-failed")
public class PaymentFailedServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String orderId = req.getParameter("orderId");

        if (orderId == null) {
            resp.sendRedirect(req.getContextPath() + "/my_orders");

            return;
        }

        BookOrderImpl dao = new BookOrderImpl(DBConnect.getConn());
        Book_Order order = dao.getOrderByOrderId(orderId);

        if (order != null) {
            dao.updatePaymentFailure(order.getId());
        }

        resp.sendRedirect(req.getContextPath() + "/payment_failed.jsp");

    }
}
