package com.user.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.DBMS.DBConnect;
import com.entity.SellerWalletTransaction;
import com.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/seller_transaction_history")
public class SellerTransactionHistoryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("userobj");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int sellerId = user.getId();

        int page = 1;
        int recordsPerPage = 5;

        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        int start = (page - 1) * recordsPerPage;

        String typeFilter = request.getParameter("type");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        List<SellerWalletTransaction> list = new ArrayList<>();

        try (Connection conn = DBConnect.getConn()) {

            StringBuilder baseQuery = new StringBuilder(
                    " FROM seller_wallet_transactions WHERE seller_id=? ");

            if (typeFilter != null && !typeFilter.isEmpty()) {
                baseQuery.append(" AND type=? ");
            }

            if (fromDate != null && !fromDate.isEmpty()) {
                baseQuery.append(" AND DATE(created_at) >= ? ");
            }

            if (toDate != null && !toDate.isEmpty()) {
                baseQuery.append(" AND DATE(created_at) <= ? ");
            }

            // COUNT
            String countSql = "SELECT COUNT(*) " + baseQuery.toString();
            PreparedStatement countPs = conn.prepareStatement(countSql);

            int paramIndex = 1;
            countPs.setInt(paramIndex++, sellerId);

            if (typeFilter != null && !typeFilter.isEmpty())
                countPs.setString(paramIndex++, typeFilter);

            if (fromDate != null && !fromDate.isEmpty())
                countPs.setString(paramIndex++, fromDate);

            if (toDate != null && !toDate.isEmpty())
                countPs.setString(paramIndex++, toDate);

            ResultSet countRs = countPs.executeQuery();
            int totalRecords = 0;
            if (countRs.next()) {
                totalRecords = countRs.getInt(1);
            }

            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

            // DATA
            String dataSql = "SELECT * " + baseQuery.toString() +
                    " ORDER BY id DESC LIMIT ?,?";

            PreparedStatement dataPs = conn.prepareStatement(dataSql);

            paramIndex = 1;
            dataPs.setInt(paramIndex++, sellerId);

            if (typeFilter != null && !typeFilter.isEmpty())
                dataPs.setString(paramIndex++, typeFilter);

            if (fromDate != null && !fromDate.isEmpty())
                dataPs.setString(paramIndex++, fromDate);

            if (toDate != null && !toDate.isEmpty())
                dataPs.setString(paramIndex++, toDate);

            dataPs.setInt(paramIndex++, start);
            dataPs.setInt(paramIndex++, recordsPerPage);

            ResultSet rs = dataPs.executeQuery();

            while (rs.next()) {
                SellerWalletTransaction t = new SellerWalletTransaction();
                t.setId(rs.getInt("id"));
                t.setAmount(rs.getDouble("amount"));
                t.setType(rs.getString("type"));
                t.setDescription(rs.getString("description"));
                t.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(t);
            }

            request.setAttribute("transactionList", list);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("typeFilter", typeFilter);
            request.setAttribute("fromDate", fromDate);
            request.setAttribute("toDate", toDate);

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("seller_transaction_history.jsp")
                .forward(request, response);
    }
}
