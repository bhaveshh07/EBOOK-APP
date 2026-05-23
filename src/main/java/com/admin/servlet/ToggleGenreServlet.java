package com.admin.servlet;

import java.io.IOException;

import com.DAO.GenreDAO;
import com.DAO.GenreDAOImpl;
import com.DBMS.DBConnect;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.UUID;

@WebServlet("/admin/toggle-genre")
public class ToggleGenreServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String csrfToken = UUID.randomUUID().toString();
        req.getSession().setAttribute("CSRF_TOKEN", csrfToken);
        int id = Integer.parseInt(req.getParameter("id"));

        GenreDAO dao = new GenreDAOImpl(DBConnect.getConn());
        dao.toggleGenreStatus(id);

        resp.sendRedirect("genres");
    }
}
