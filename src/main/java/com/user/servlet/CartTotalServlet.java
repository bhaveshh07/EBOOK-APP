package com.user.servlet;

import java.io.IOException;

import com.DAO.CartDAOImpl;
import com.DBMS.DBConnect;
import com.entity.Cart;
import com.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/cartTotal")
public class CartTotalServlet extends HttpServlet {

protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

    User u = (User) req.getSession().getAttribute("userobj");

    CartDAOImpl dao = new CartDAOImpl(DBConnect.getConn());

    double total = 0;
    for(Cart c : dao.getBookByUser(u.getId())){
        total += c.getTotalPrice();
    }

    resp.getWriter().print(total);
}
}

