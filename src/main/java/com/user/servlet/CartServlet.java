package com.user.servlet;

import java.io.IOException;

import com.DAO.BookDAOImpl;
import com.DAO.CartDAOImpl;
import com.DBMS.DBConnect;
import com.entity.BookDtls;
import com.entity.Cart;
import com.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int bid = Integer.parseInt(req.getParameter("bid"));
            HttpSession session = req.getSession(false);
            User u = (User) session.getAttribute("userobj");

            if (u == null) {
                resp.sendError(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            int uid = u.getId();

            CartDAOImpl cartDao = new CartDAOImpl(DBConnect.getConn());
            BookDAOImpl bookDao = new BookDAOImpl(DBConnect.getConn());

            BookDtls book = bookDao.getBookById(bid);
            double price = Double.parseDouble(book.getPrice());

            Cart existing = cartDao.findByUserAndBook(uid, bid);

            // Get real stock
            int stock = bookDao.getStockByBookId(bid);

            if (existing != null) {

                // Already at max stock
                if (existing.getQuantity() >= stock) {
                    resp.getWriter().print("Stock Unavaliable!");
                    return;
                }

                int newQty = existing.getQuantity() + 1;
                cartDao.updateQuantityOnly(existing.getCid(), newQty);

            } else {

                // No stock available
                if (stock <= 0) {
                    resp.getWriter().print("Stock Unavaliable!");
                    return;
                }

                Cart c = new Cart();
                c.setBid(bid);
                c.setUid(uid);
                c.setBookName(book.getBookName());
                c.setAuthor(book.getAuthor());
                c.setPrice(price);
                c.setQuantity(1);
                c.setTotalPrice(price);

                cartDao.addCart(c);
            }

            req.getSession().setAttribute("succMsg", "Book added to cart!");
            resp.getWriter().print("ok");
            return;

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().print("fail");
            return;
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Forward GET to POST safely
        doPost(req, resp);
    }
}
