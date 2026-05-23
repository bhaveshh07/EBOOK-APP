package com.admin.servlet;

import java.io.IOException;

import com.DAO.BookOrderImpl;
import com.DBMS.DBConnect;
import com.entity.Book_Order;
import com.util.EmailSender;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/update_order_status")
public class UpdateOrderStatusServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        String status = req.getParameter("status");

        BookOrderImpl dao = new BookOrderImpl(DBConnect.getConn());
        boolean updated = dao.updateOrderStatus(id, status);

        if (updated) {

            Book_Order o = dao.getOrderById(id);

            if (o != null) {

                if ("SHIPPED".equals(status)) {
                    EmailSender.sendOrderShippedEmail(
                            o.getEmail(),
                            o.getUserName(),
                            o.getOrderId());
                }

                if ("DELIVERED".equals(status)) {
                    EmailSender.sendOrderDeliveredEmail(
                            o.getEmail(),
                            o.getUserName(),
                            o.getOrderId(),
                            o.getBookName());
                }

                if ("CANCELLED".equals(status)) {
                    EmailSender.sendOrderCancelledEmail(
                            o.getEmail(),
                            o.getUserName(),
                            o.getOrderId());
                }
            }
        }
       resp.sendRedirect(req.getContextPath() + "/admin_orders");


    }

}
