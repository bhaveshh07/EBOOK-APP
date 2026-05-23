package com.admin.servlet;

import java.io.IOException;
import java.sql.Connection;

import com.DBMS.DBConnect;
import com.DAO.BookDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/search-dashboard")
public class AdminSearchDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // OPTIONAL: Admin Role Check
        if (session == null ||
                session.getAttribute("userobj") == null ||
                !"ADMIN".equals(session.getAttribute("role"))) {

            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Connection conn = null;

        try {

            conn = DBConnect.getConn();
            BookDAOImpl dao = new BookDAOImpl(conn);

            request.setAttribute("topSearches",
                    dao.getTopSearchKeywords(5));

            request.setAttribute("zeroSearches",
                    dao.getZeroResultKeywords(5));

            request.setAttribute("mostViewed",
                    dao.getMostViewedBooks(5));

            request.setAttribute("mostPurchased",
                    dao.getMostPurchasedBooks(5));

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null)
                    conn.close();
            } catch (Exception e) {
            }
        }

        request.getRequestDispatcher(
                "/admin/admin_search_dashboard.jsp")
                .forward(request, response);
    }
}