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

@WebServlet("/admin/edit-book")
@MultipartConfig
public class AdminEditBookServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        BookDAOImpl dao = new BookDAOImpl(DBConnect.getConn());
        BookDtls book = dao.getBookById(id);
        GenreDAO gdao = new GenreDAOImpl(DBConnect.getConn());
        List<Genre> genreList = gdao.getAllGenres();

        List<Integer> selectedGenres = gdao.getGenreIdsByBookId(id);

        req.setAttribute("genreList", genreList);
        req.setAttribute("selectedGenres", selectedGenres);

        req.setAttribute("book", book);
        req.getRequestDispatcher("/admin/edit_books.jsp")
                .forward(req, resp);
    }

    protected void doPost(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        int id = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("bname");
        String author = req.getParameter("author");
        String price = req.getParameter("price");
        String status = req.getParameter("status");

        BookDAOImpl dao = new BookDAOImpl(DBConnect.getConn());
        BookDtls existingBook = dao.getBookById(id);

        String photoName = existingBook.getPhotoName();

        Part filePart = req.getPart("bimg");

        if (filePart != null && filePart.getSize() > 0) {

            String fileName = filePart.getSubmittedFileName();

            String uploadPath = getServletContext()
                    .getRealPath("") + "uploads/book";

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists())
                uploadDir.mkdirs();

            filePart.write(uploadPath + File.separator + fileName);

            photoName = fileName; // update new image
        }

        BookDtls b = new BookDtls();
        b.setBookId(id);
        b.setBookName(name);
        b.setAuthor(author);
        b.setPrice(price);
        b.setStatus(status);
        b.setPhotoName(photoName);

        boolean updated = dao.updateEditBooks(b);
        String[] genreIds = req.getParameterValues("genreIds");

        GenreDAOImpl gdao = new GenreDAOImpl(DBConnect.getConn());

        // Remove old mappings
        gdao.deleteBookGenres(id);

        // Add new ones
        if (genreIds != null) {
            for (String gid : genreIds) {
                gdao.addBookGenreMapping(id, Integer.parseInt(gid));
            }
        }

        if (updated) {
            session.setAttribute("succMsg", "Book Updated Successfully");
        } else {
            session.setAttribute("failedMsg", "Update Failed");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/books");
    }
}
