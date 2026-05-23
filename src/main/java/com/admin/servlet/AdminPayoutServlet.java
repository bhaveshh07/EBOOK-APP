package com.admin.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.DAO.SellerWalletDAOImpl;
import com.DBMS.DBConnect;
import com.entity.SellerPayoutRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin_payouts")
public class AdminPayoutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<SellerPayoutRequest> list = new ArrayList<>();

        try (Connection conn = DBConnect.getConn()) {

            String sql = "SELECT pr.id, pr.seller_id, pr.amount, pr.status, pr.created_at, "
                    + "u.name, u.email "
                    + "FROM seller_payout_requests pr "
                    + "JOIN user u ON pr.seller_id = u.id "
                    + "ORDER BY pr.created_at DESC";

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            SellerWalletDAOImpl walletDAO = new SellerWalletDAOImpl(conn);

            while (rs.next()) {

                SellerPayoutRequest p = new SellerPayoutRequest();

                p.setId(rs.getInt("id"));
                p.setSellerId(rs.getInt("seller_id"));
                p.setAmount(rs.getDouble("amount"));
                p.setStatus(rs.getString("status"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                p.setSellerName(rs.getString("name"));
                p.setSellerEmail(rs.getString("email"));

                double balance = walletDAO.getSellerBalance(p.getSellerId());

                if (p.getAmount() > balance && "PENDING".equals(p.getStatus())) {
                    p.setStatus("INSUFFICIENT");
                }

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("payoutList", list);

        //  ABSOLUTE PATH
        req.getRequestDispatcher("/admin/admin_payouts.jsp")
                .forward(req, resp);
    }
}