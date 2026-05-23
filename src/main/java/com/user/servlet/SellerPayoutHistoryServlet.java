package com.user.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.DBMS.DBConnect;
import com.entity.SellerPayoutRequest;
import com.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/seller_payout_history")
public class SellerPayoutHistoryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("userobj");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int sellerId = user.getId();

        // Pagination
        int page = 1;
        int recordsPerPage = 5;

        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        int start = (page - 1) * recordsPerPage;

        // Filters
        String statusFilter = request.getParameter("status");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        List<SellerPayoutRequest> list = new ArrayList<>();

        try (Connection conn = DBConnect.getConn()) {

            StringBuilder baseQuery = new StringBuilder(
                    " FROM seller_payout_requests WHERE seller_id=? ");

            if (statusFilter != null && !statusFilter.isEmpty()) {
                baseQuery.append(" AND status=? ");
            }

            if (fromDate != null && !fromDate.isEmpty()) {
                baseQuery.append(" AND DATE(created_at) >= ? ");
            }

            if (toDate != null && !toDate.isEmpty()) {
                baseQuery.append(" AND DATE(created_at) <= ? ");
            }

            // ================= COUNT QUERY =================
            String countSql = "SELECT COUNT(*) " + baseQuery.toString();
            PreparedStatement countPs = conn.prepareStatement(countSql);

            int paramIndex = 1;
            countPs.setInt(paramIndex++, sellerId);

            if (statusFilter != null && !statusFilter.isEmpty())
                countPs.setString(paramIndex++, statusFilter);

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

            // ================= DATA QUERY =================
            String dataSql = "SELECT * " + baseQuery.toString() +
                    " ORDER BY id DESC LIMIT ?,?";

            PreparedStatement dataPs = conn.prepareStatement(dataSql);

            paramIndex = 1;
            dataPs.setInt(paramIndex++, sellerId);

            if (statusFilter != null && !statusFilter.isEmpty())
                dataPs.setString(paramIndex++, statusFilter);

            if (fromDate != null && !fromDate.isEmpty())
                dataPs.setString(paramIndex++, fromDate);

            if (toDate != null && !toDate.isEmpty())
                dataPs.setString(paramIndex++, toDate);

            dataPs.setInt(paramIndex++, start);
            dataPs.setInt(paramIndex++, recordsPerPage);

            ResultSet rs = dataPs.executeQuery();

            while (rs.next()) {
                SellerPayoutRequest p = new SellerPayoutRequest();
                p.setId(rs.getInt("id"));
                p.setAmount(rs.getDouble("amount"));
                p.setStatus(rs.getString("status"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(p);
            }

            request.setAttribute("payoutList", list);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("fromDate", fromDate);
            request.setAttribute("toDate", toDate);

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("seller_payout_history.jsp")
                .forward(request, response);
    }
}
