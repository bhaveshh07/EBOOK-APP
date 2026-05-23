package com.user.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.DBMS.DBConnect;
import com.entity.User;
import com.DAO.SellerWalletDAOImpl;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/request_payout")
public class SellerPayoutRequestServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User u = (User) req.getSession().getAttribute("userobj");

        if (u == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DBConnect.getConn()) {

            double amount = Double.parseDouble(req.getParameter("amount"));

            SellerWalletDAOImpl walletDAO = new SellerWalletDAOImpl(conn);
            double balance = walletDAO.getSellerBalance(u.getId());

            if (amount <= 0) {
                req.getSession().setAttribute("payoutError", "Invalid payout amount");
                resp.sendRedirect("seller_wallet");
                return;
            }

            if (amount > balance) {
                req.getSession().setAttribute("payoutError", "Amount exceeds available balance");
                resp.sendRedirect("seller_wallet");
                return;
            }

            // Only one pending request allowed
            String checkSql = "SELECT COUNT(*) FROM seller_payout_requests "
                    + "WHERE seller_id=? AND status='PENDING'";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, u.getId());

            ResultSet rs = checkPs.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                req.getSession().setAttribute("payoutError",
                        "You already have a pending payout request");
                resp.sendRedirect("seller_wallet");
                return;
            }

            String sql = "INSERT INTO seller_payout_requests "
                    + "(seller_id, amount, status) VALUES (?, ?, 'PENDING')";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, u.getId());
            ps.setDouble(2, amount);
            ps.executeUpdate();

            req.getSession().setAttribute("payoutSuccess",
                    "Payout request submitted successfully");

        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect("seller_wallet");
    }
}
