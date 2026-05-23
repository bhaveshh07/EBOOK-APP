package com.user.servlet;

import java.io.IOException;

import com.DAO.ReviewDAOImpl;
import com.DBMS.DBConnect;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/deleteReview")
public class DeleteReviewServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int reviewId = Integer.parseInt(req.getParameter("rid"));
        String bid = req.getParameter("bid");

        ReviewDAOImpl dao = new ReviewDAOImpl(DBConnect.getConn());
        dao.deleteReview(reviewId);

        resp.sendRedirect("view_books.jsp?bid=" + bid);
    }
}
