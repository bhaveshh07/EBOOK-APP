package com.admin.servlet;

import java.io.IOException;

import com.DAO.BookOrderImpl;
import com.DAO.SellerWalletDAOImpl;
import com.DBMS.DBConnect;
import com.entity.Book_Order;
import com.util.EmailSender;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/approve_return")
public class ApproveReturnServlet extends HttpServlet {

  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws IOException {

    int id = Integer.parseInt(req.getParameter("id"));

    try {

      BookOrderImpl dao = new BookOrderImpl(DBConnect.getConn());

      dao.updateReturnStatusById(id, "APPROVED");

      Book_Order o = dao.getOrderById(id);

      if (o != null) {

        SellerWalletDAOImpl walletDAO = new SellerWalletDAOImpl(DBConnect.getConn());

        int sellerId = o.getSellerId();
        double amount = o.getPrice();

        // Debit Seller
        walletDAO.debitSeller(
            sellerId,
            amount,
            "Return Approved - Order " + o.getOrderId());

        // Auto penalty logic
        int returnCount = walletDAO.getSellerReturnCountLast30Days(sellerId);

        if (returnCount >= 3) {

          walletDAO.debitSeller(
              sellerId,
              50,
              "Auto Penalty - High Return Rate");
        }

        // Email buyer
        EmailSender.sendReturnApprovedEmail(
            o.getEmail(),
            o.getUserName(),
            o.getOrderId());
      }

    } catch (Exception e) {
      e.printStackTrace();
    }

    resp.sendRedirect(req.getContextPath() + "/admin_orders");
  }
}
