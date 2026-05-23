package com.user.servlet;

import java.io.File;
import java.io.IOException;

import com.DAO.ReviewDAOImpl;
import com.DBMS.DBConnect;
import com.util.UploadUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/editReview")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
public class EditReviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        try {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String text = request.getParameter("reviewText");

            ReviewDAOImpl dao = new ReviewDAOImpl(DBConnect.getConn());

            //  Fetch old image name
            String oldImage = dao.getReviewImageById(reviewId);

            Part part = request.getPart("reviewImage");
            String uploadPath = "D:/ebook_uploads/reviews";

            String newImage = null;

            //  SAFE upload handling
            try {
                newImage = UploadUtils.validateAndSaveImage(part, uploadPath);
            } catch (Exception ex) {
                response.getWriter().print(ex.getMessage());
                return;
            }

            //  Decide final image
            String finalImage = (newImage != null) ? newImage : oldImage;

            boolean updated = dao.updateReviewFull(reviewId, text, rating, finalImage);

            //  Delete old image only after successful update
            if (updated && newImage != null && oldImage != null) {
                File oldFile = new File(uploadPath + File.separator + oldImage);
                if (oldFile.exists()) {
                    oldFile.delete();
                }
            }

            response.getWriter().print(updated ? "ok" : "fail");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("error");
        }
    }
}