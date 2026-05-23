package com.user.servlet;

import java.io.IOException;

import com.DAO.ReviewDAOImpl;
import com.DBMS.DBConnect;
import com.entity.Review;
import com.util.UploadUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/addReview")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
public class AddReviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(); // ✅ DECLARED OUTSIDE TRY

        try {
            String bookIdStr = request.getParameter("bookId");
            String userIdStr = request.getParameter("userId");

            if (bookIdStr == null || userIdStr == null) {
                session.setAttribute("failedMsg", "Invalid image or file too large");
                response.sendRedirect("index.jsp");
                return;
            }

            int bookId = Integer.parseInt(bookIdStr);
            int userId = Integer.parseInt(userIdStr);

            int rating = Integer.parseInt(
                    request.getParameter("rating") == null
                            ? "5"
                            : request.getParameter("rating"));

            String reviewText = request.getParameter("reviewText");

            Part part = request.getPart("reviewImage");
            String uploadPath = "D:/ebook_uploads/reviews";

            String fileName = null;

            try {
                fileName = UploadUtils.validateAndSaveImage(part, uploadPath);
            } catch (Exception ex) {
                session.setAttribute("failedMsg", ex.getMessage());
                response.sendRedirect("view_books.jsp?bid=" + bookId); // FIXED
                return;
            }

            Review r = new Review();
            r.setBookId(bookId);
            r.setUserId(userId);
            r.setRating(rating);
            r.setReviewText(reviewText);
            r.setImage(fileName);

            ReviewDAOImpl dao = new ReviewDAOImpl(DBConnect.getConn());

            boolean added = dao.addReview(r);

            if (added) {
                session.setAttribute("succMsg", "Review added successfully");
            } else {
                session.setAttribute("failedMsg", "Unable to add review");
            }

            response.sendRedirect("view_books.jsp?bid=" + bookId);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("failedMsg", "Unexpected server error");
            response.sendRedirect("index.jsp");
        }
    }
}
