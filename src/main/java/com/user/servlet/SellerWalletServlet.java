package com.user.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.DAO.SellerWalletDAOImpl;
import com.DBMS.DBConnect;
import com.entity.User;
import com.entity.SellerWalletTransaction;
import com.entity.SellerPayoutRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/seller_wallet")
public class SellerWalletServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("SellerWalletServlet Executed");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userobj");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int sellerId = user.getId();

        try (Connection conn = DBConnect.getConn()) {

            SellerWalletDAOImpl walletDAO = new SellerWalletDAOImpl(conn);

            double currentBalance = walletDAO.getSellerBalance(sellerId);
            List<SellerWalletTransaction> transactions = walletDAO.getSellerTransactions(sellerId);
            double totalEarnings = walletDAO.getSellerTotalEarnings(sellerId);

            // Payout History
            List<SellerPayoutRequest> payoutList = new ArrayList<>();

            String sql = "SELECT id, amount, status, created_at " +
                    "FROM seller_payout_requests " +
                    "WHERE seller_id=? " +
                    "ORDER BY id DESC LIMIT 5";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, sellerId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                SellerPayoutRequest p = new SellerPayoutRequest();
                p.setId(rs.getInt("id"));
                p.setAmount(rs.getDouble("amount"));
                p.setStatus(rs.getString("status"));
                p.setCreatedAt(rs.getTimestamp("created_at"));

                payoutList.add(p);
            }

            request.setAttribute("sellerBalance", currentBalance);
            request.setAttribute("transactions", transactions);
            request.setAttribute("totalEarnings", totalEarnings);
            request.setAttribute("payoutList", payoutList);

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("seller_wallet.jsp")
                .forward(request, response);
    }
}
