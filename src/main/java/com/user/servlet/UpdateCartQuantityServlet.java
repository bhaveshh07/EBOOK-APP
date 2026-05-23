package com.user.servlet;

import java.io.IOException;

import com.DAO.BookDAOImpl;
import com.DAO.CartDAOImpl;
import com.DBMS.DBConnect;
import com.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/updateCartQty")
public class UpdateCartQuantityServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");

        try {

            int cid = Integer.parseInt(req.getParameter("cid"));
            int qty = Integer.parseInt(req.getParameter("qty"));

            CartDAOImpl cartDao = new CartDAOImpl(DBConnect.getConn());
            BookDAOImpl bookDao = new BookDAOImpl(DBConnect.getConn());

            // Get bookId from cart
            int bid = cartDao.getBookIdByCartId(cid);

            // Get real stock
            int stock = bookDao.getStockByBookId(bid);

            // Stock validation
            if (qty > stock) {
                resp.getWriter().print(
                        "{\"status\":\"stock\",\"available\":" + stock + "}");
                return;
            }

            boolean f = cartDao.updateQuantityOnly(cid, qty);

            if (f) {

                User u = (User) req.getSession().getAttribute("userobj");

                double subtotal = cartDao.getGrandTotal(u.getId());
                double delivery = 40.0;
                double discount = 0.0; // no coupon here yet
                double grandTotal = subtotal + delivery;

                resp.getWriter().print(
                        "{"
                                + "\"status\":\"ok\","
                                + "\"subtotal\":" + subtotal + ","
                                + "\"delivery\":" + delivery + ","
                                + "\"discount\":" + discount + ","
                                + "\"grandTotal\":" + grandTotal + ","
                                + "\"stock\":" + stock
                                + "}");
            } else {
                resp.getWriter().print("{\"status\":\"fail\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().print("{\"status\":\"fail\"}");
        }
    }
}
