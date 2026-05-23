package com.user.servlet;

import java.io.IOException;

import com.DAO.CartDAOImpl;
import com.DBMS.DBConnect;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/remove_book")
public class RemoveBookCart extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        try {

            String cidParam = req.getParameter("cid");

            if (cidParam == null || cidParam.trim().isEmpty()) {
                session.setAttribute("failedMsg", "Invalid cart item.");
                resp.sendRedirect("checkout.jsp");
                return;
            }

            int cid = Integer.parseInt(cidParam);

            CartDAOImpl dao = new CartDAOImpl(DBConnect.getConn());
            boolean removed = dao.deleteBookByCartId(cid);

            if (removed) {
                session.setAttribute("succMsg", "Item removed from cart successfully.");
            } else {
                session.setAttribute("failedMsg", "Unable to remove item. Try again.");
            }

            resp.sendRedirect("checkout.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("failedMsg", "Something went wrong.");
            resp.sendRedirect("checkout.jsp");
        }
    }
}