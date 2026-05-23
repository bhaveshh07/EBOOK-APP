package com.user.servlet;

import java.io.IOException;
import java.sql.Connection;

import com.DAO.ReviewDAOImpl;
import com.DBMS.DBConnect;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/helpfulReview")
public class HelpfulReviewServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        int rid = Integer.parseInt(request.getParameter("rid"));
        int uid = Integer.parseInt(request.getParameter("uid"));

        Connection conn = null;

        try {
            conn = DBConnect.getConn();
            ReviewDAOImpl dao = new ReviewDAOImpl(conn);

            boolean inserted = dao.insertHelpfulUser(rid, uid);

            if (inserted) {
                dao.incrementHelpful(rid);
            }

            int count = dao.getHelpfulCount(rid);
            response.getWriter().print(count);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null)
                    conn.close(); // CRITICAL FIX
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
