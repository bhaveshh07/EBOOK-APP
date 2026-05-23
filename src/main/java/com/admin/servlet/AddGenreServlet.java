package com.admin.servlet;

import java.io.IOException;

import com.DAO.GenreDAO;
import com.DAO.GenreDAOImpl;
import com.DBMS.DBConnect;
import com.entity.Genre;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/add-genre")
public class AddGenreServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String csrfToken = UUID.randomUUID().toString();
        req.getSession().setAttribute("CSRF_TOKEN", csrfToken);

        String name = req.getParameter("name");
        String description = req.getParameter("description");

        String slug = name.toLowerCase()
                .replaceAll("\\s+", "-");

        Genre g = new Genre();
        g.setName(name);
        g.setSlug(slug);
        g.setDescription(description);
        g.setActive(true);
        g.setFeatured(false);
        g.setDisplayOrder(0);

        GenreDAO dao = new GenreDAOImpl(DBConnect.getConn());

        boolean f = dao.addGenre(g);

        if (f) {
            req.getSession().setAttribute("succMsg", "Genre Added Successfully");
        } else {
            req.getSession().setAttribute("errorMsg", "Failed to Add Genre");
        }

        resp.sendRedirect("genres");

    }
}
