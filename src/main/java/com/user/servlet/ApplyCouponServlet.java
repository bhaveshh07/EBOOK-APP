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

@WebServlet("/applyCoupon")
public class ApplyCouponServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");

        try {

            User u = (User) req.getSession().getAttribute("userobj");
            if (u == null) {
                resp.getWriter().print("{\"status\":\"fail\",\"message\":\"Login required\"}");
                return;
            }

            String code = req.getParameter("coupon");
            CartDAOImpl cartDao = new CartDAOImpl(DBConnect.getConn());

            double subtotal = cartDao.getGrandTotal(u.getId());
            double delivery = 40.0;
            double discount = 0;

            if (code == null || code.trim().isEmpty()) {
                resp.getWriter().print("{\"status\":\"fail\",\"message\":\"Enter coupon code\"}");
                return;
            }

            code = code.trim().toUpperCase();

            switch (code) {

                case "SAVE100":
                    if (subtotal >= 599) {
                        discount = 100;
                    } else {
                        resp.getWriter().print("{\"status\":\"fail\",\"message\":\"Minimum order ₹399 required\"}");
                        return;
                    }
                    break;

                case "SAVE10":
                    if (subtotal >= 399) {
                        discount = subtotal * 0.10;
                    } else {
                        resp.getWriter().print("{\"status\":\"fail\",\"message\":\"Minimum order ₹299 required\"}");
                        return;
                    }
                    break;

                case "BIG20":
                    if (subtotal >= 999) {
                        discount = subtotal * 0.20;
                    } else {
                        resp.getWriter().print("{\"status\":\"fail\",\"message\":\"Minimum order ₹999 required\"}");
                        return;
                    }
                    break;

                default:
                    resp.getWriter().print("{\"status\":\"fail\",\"message\":\"Invalid coupon\"}");
                    return;
            }

            double grandTotal = (subtotal - discount) + delivery;

            resp.getWriter().print(
                    "{"
                            + "\"status\":\"ok\","
                            + "\"subtotal\":" + subtotal + ","
                            + "\"delivery\":" + delivery + ","
                            + "\"discount\":" + discount + ","
                            + "\"grandTotal\":" + grandTotal
                            + "}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().print("{\"status\":\"fail\",\"message\":\"Server error\"}");
        }
    }
}
