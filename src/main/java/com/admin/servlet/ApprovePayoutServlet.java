package com.admin.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.DAO.SellerWalletDAOImpl;
import com.DBMS.DBConnect;
import com.util.EmailSender;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/approve_payout")
public class ApprovePayoutServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        try (Connection conn = DBConnect.getConn()) {

            conn.setAutoCommit(false);

            PreparedStatement ps1 = conn.prepareStatement(
                    "SELECT pr.seller_id, pr.amount, u.email, u.name " +
                            "FROM seller_payout_requests pr " +
                            "JOIN user u ON pr.seller_id=u.id " +
                            "WHERE pr.id=? AND pr.status='PENDING'");

            ps1.setInt(1, id);
            ResultSet rs = ps1.executeQuery();

            if (rs.next()) {

                int sellerId = rs.getInt("seller_id");
                double amount = rs.getDouble("amount");
                String email = rs.getString("email");
                String name = rs.getString("name");

                SellerWalletDAOImpl walletDAO = new SellerWalletDAOImpl(conn);

                // Debit wallet
                walletDAO.debitSeller(
                        sellerId,
                        amount,
                        "Payout Processing ID: " + id);

                // Update status to PROCESSING
                PreparedStatement ps3 = conn.prepareStatement(
                        "UPDATE seller_payout_requests SET status='PROCESSING' WHERE id=?");

                ps3.setInt(1, id);
                ps3.executeUpdate();

                conn.commit();

                //  Email Seller
                EmailSender.sendSimpleMail(
                        email,
                        "Payout is Processing",
                        "Hello " + name +
                                "<br>Your payout request of ₹" + amount +
                                " is now being processed." +
                                "<br>It will be settled within 2-3 business days.");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/admin_payouts");
    }
}
