package com.admin.servlet;

import java.io.IOException;
import java.sql.PreparedStatement;

import com.DAO.BookOrderImpl;
import com.DAO.UserDAOImpl;
import com.DBMS.DBConnect;
import com.entity.Book_Order;
import com.util.EmailSender;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/refund_order")
public class RefundServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int orderId = Integer.parseInt(req.getParameter("id"));
        int userId = Integer.parseInt(req.getParameter("userId"));
        double amount = Double.parseDouble(req.getParameter("amount"));

        BookOrderImpl odao = new BookOrderImpl(DBConnect.getConn());
        UserDAOImpl udao = new UserDAOImpl(DBConnect.getConn());

        // 1) mark refunded
        odao.processRefund(orderId);

        // 2) add wallet balance
        udao.addToWallet(userId, amount);
        Book_Order o = odao.getOrderById(orderId);

        EmailSender.sendRefundEmail(
                o.getEmail(),
                o.getUserName(),
                o.getOrderId(),
                amount);

        // 3) insert wallet transaction
        try {
            String sql = "INSERT INTO wallet_transactions(user_id,amount,type,description) VALUES(?,?,?,?)";

            PreparedStatement ps = DBConnect.getConn().prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setDouble(2, amount);
            ps.setString(3, "CREDIT");
            ps.setString(4, "Refund for Order ID : " + orderId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/admin_orders");
    }
}
