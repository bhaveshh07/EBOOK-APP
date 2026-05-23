package com.admin.servlet;

import java.io.IOException;

import com.DAO.BookOrderImpl;
import com.DBMS.DBConnect;
import com.entity.Book_Order;
import com.util.EmailSender;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/reject_return")
public class RejectReturnServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        BookOrderImpl dao = new BookOrderImpl(DBConnect.getConn());

        dao.updateReturnStatusById(id, "REJECTED");
        Book_Order o = dao.getOrderById(id);

        EmailSender.sendReturnRejectedEmail(
                o.getEmail(),
                o.getUserName(),
                o.getOrderId());

        resp.sendRedirect(req.getContextPath() + "/admin_orders");
    }
}
