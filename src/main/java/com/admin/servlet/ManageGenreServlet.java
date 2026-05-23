package com.admin.servlet;

import java.io.IOException;
import java.util.List;

import com.DAO.GenreDAO;
import com.DAO.GenreDAOImpl;
import com.DBMS.DBConnect;
import com.entity.Genre;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.UUID;

@WebServlet("/admin/genres")
public class ManageGenreServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String csrfToken = UUID.randomUUID().toString();
        req.getSession().setAttribute("CSRF_TOKEN", csrfToken);
        GenreDAO dao = new GenreDAOImpl(DBConnect.getConn());
        List<Genre> list = dao.getAllGenres();

        req.setAttribute("genreList", list);
        req.getRequestDispatcher("/admin/admin_genres.jsp")
                .forward(req, resp);
    }
}
