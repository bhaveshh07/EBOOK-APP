package com.user.servlet;

import java.io.IOException;
import java.sql.Connection;

import com.DAO.BookOrderImpl;
import com.DBMS.DBConnect;
import com.entity.Book_Order;
import com.util.EmailSender;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/cancel_order")
public class CancelOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("orderId"));

        Connection conn = null;

        try {
            conn = DBConnect.getConn();
            conn.setAutoCommit(false);

            BookOrderImpl dao = new BookOrderImpl(conn);

            boolean updated = dao.cancelOrderAndRestoreStock(id);

            if (!updated) {
                conn.rollback();
                resp.sendRedirect("my_orders");
                return;
            }

            Book_Order o = dao.getOrderById(id);

            conn.commit();

            if (o != null) {
                EmailSender.sendOrderCancelledEmail(
                        o.getEmail(),
                        o.getUserName(),
                        o.getOrderId());
            }

            resp.sendRedirect("my_orders");

        } catch (Exception e) {

            try {
                if (conn != null)
                    conn.rollback();
            } catch (Exception ex) {
            }

            e.printStackTrace();
            resp.sendRedirect("my_orders");

        } finally {
            try {
                if (conn != null)
                    conn.close();
            } catch (Exception e) {
            }
        }
    }
}
