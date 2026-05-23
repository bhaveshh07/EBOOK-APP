package com.user.servlet;

import java.io.IOException;

import com.DAO.CartDAOImpl;
import com.DBMS.DBConnect;
import com.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/cartCount")
public class CartCountServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("text/plain");
        User u = (User) req.getSession().getAttribute("userobj");

        if (u == null) {
            resp.getWriter().print(0);
            return;
        }

        CartDAOImpl dao = new CartDAOImpl(DBConnect.getConn());
        int count = dao.getBookByUser(u.getId()).size();

        resp.getWriter().print(count);
    }
}
