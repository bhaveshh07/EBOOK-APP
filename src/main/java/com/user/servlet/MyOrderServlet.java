package com.user.servlet;

import java.io.IOException;
import java.util.List;

import com.DAO.BookOrderImpl;
import com.DBMS.DBConnect;
import com.entity.Book_Order;
import com.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/my_orders")
public class MyOrderServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("userobj");

        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        BookOrderImpl dao = new BookOrderImpl(DBConnect.getConn());
        List<Book_Order> list = dao.getOrdersByUser(user.getId());
        System.out.println("Orders found: " + list.size());

        req.setAttribute("orderList", list);
        req.getRequestDispatcher("/order.jsp").forward(req, resp);

    }
}
