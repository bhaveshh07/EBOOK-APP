package com.user.servlet;

import java.io.IOException;
import com.DAO.BookOrderImpl;
import com.DBMS.DBConnect;
import com.entity.Book_Order;
import com.util.EmailSender;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/return_order")
public class ReturnOrderServlet extends HttpServlet {

   protected void doPost(HttpServletRequest req, HttpServletResponse resp)
         throws IOException {

      int id = Integer.parseInt(req.getParameter("id"));

      BookOrderImpl dao = new BookOrderImpl(DBConnect.getConn());
      dao.updateReturnStatusById(id, "REQUESTED");
      Book_Order o = dao.getOrderById(id);

      EmailSender.sendReturnRequestedEmail(
            o.getEmail(),
            o.getUserName(),
            o.getOrderId());

      resp.sendRedirect("my_orders");
   }
}
