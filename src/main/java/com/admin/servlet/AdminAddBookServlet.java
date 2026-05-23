package com.admin.servlet;

import java.io.IOException;
import java.util.List;

import com.DAO.BookDAOImpl;
import com.DAO.GenreDAO;
import com.DAO.GenreDAOImpl;
import com.DBMS.DBConnect;
import com.entity.BookDtls;
import com.entity.Genre;

import jakarta.servlet.http.Part;
import java.io.File;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/add-book")
@MultipartConfig
public class AdminAddBookServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        if (session.getAttribute("CSRF_TOKEN") == null) {
            String token = java.util.UUID.randomUUID().toString();
            session.setAttribute("CSRF_TOKEN", token);
        }
        GenreDAO gdao = new GenreDAOImpl(DBConnect.getConn());
        List<Genre> genreList = gdao.getAllGenres();
        System.out.println("Genre list size in servlet: " + genreList.size());

        req.setAttribute("genreList", genreList);

        req.getRequestDispatcher("/admin/add_books.jsp")
                .forward(req, resp);

    }

    @Override
    protected void doPost(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        String name = req.getParameter("bname");
        String author = req.getParameter("author");
        double price = Double.parseDouble(req.getParameter("price"));
        String status = req.getParameter("status");
        String category = req.getParameter("category");

        int stock = Integer.parseInt(req.getParameter("stock"));
        String description = req.getParameter("description");

        // 🔹 Handle Image Upload
        Part filePart = req.getPart("bimg");
        String fileName = filePart.getSubmittedFileName();

        String uploadPath = getServletContext()
                .getRealPath("") + "uploads/book";

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists())
            uploadDir.mkdirs();

        filePart.write(uploadPath + File.separator + fileName);

        BookDtls b = new BookDtls();
        b.setBookName(name);
        b.setAuthor(author);
        b.setPrice(String.valueOf(price));
        b.setStatus(status);
        b.setBookCategory(category);
        b.setPhotoName(fileName);
        b.setStock(stock); // FIX
        b.setDescription(description); // FIX

        BookDAOImpl dao = new BookDAOImpl(DBConnect.getConn());
        boolean saved = dao.addbooks(b);

        if (saved) {

            // Get selected genres
            String[] genreIds = req.getParameterValues("genreIds");

            if (genreIds != null) {

                int bookId = dao.getLastInsertedBookId(); // we will create this

                GenreDAOImpl gdao = new GenreDAOImpl(DBConnect.getConn());

                for (String gid : genreIds) {
                    gdao.addBookGenreMapping(bookId, Integer.parseInt(gid));
                }
            }
        } else {
            session.setAttribute("failedMsg", "Failed to Add Book");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/books");
    }
}