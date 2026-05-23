package com.user.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

import com.DAO.BookOrderImpl;
import com.DAO.CartDAOImpl;
import com.DAO.WalletDAOImpl;
import com.DBMS.DBConnect;
import com.entity.Book_Order;
import com.entity.Cart;
import com.entity.User;
import com.util.AuditLogger;
import com.util.EmailSender;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        try {

            User user = (User) session.getAttribute("userobj");
            if (user == null) {
                resp.sendRedirect("login.jsp");
                return;
            }

            int userId = user.getId();

            String paymentType = req.getParameter("payment");
            if (paymentType == null) {
                session.setAttribute("failedMsg", "Choose payment method");
                resp.sendRedirect("checkout.jsp");
                return;
            }

            paymentType = paymentType.trim().toUpperCase();

            CartDAOImpl cartDao = new CartDAOImpl(DBConnect.getConn());
            List<Cart> cartList = cartDao.getBookByUser(userId);

            if (cartList.isEmpty()) {
                session.setAttribute("failedMsg", "Cart cannot be empty");
                resp.sendRedirect("checkout.jsp");
                return;
            }

            double subtotal = 0;
            int totalQty = 0;

            for (Cart c : cartList) {
                subtotal += c.getTotalPrice();
                totalQty += c.getQuantity();
            }

            double deliveryCharge = 40;
            double discount = 0;

            String couponCode = req.getParameter("coupon");

            if (couponCode != null && !couponCode.trim().isEmpty()) {
                couponCode = couponCode.trim().toUpperCase();

                switch (couponCode) {
                    case "SAVE100":
                        if (subtotal >= 599)
                            discount = 100;
                        break;
                    case "SAVE10":
                        if (subtotal >= 399)
                            discount = subtotal * 0.10;
                        break;
                    case "BIG20":
                        if (subtotal >= 999)
                            discount = subtotal * 0.20;
                        break;
                }
            }

            double grandTotal = (subtotal - discount) + deliveryCharge;
            if (grandTotal < 0)
                grandTotal = 0;

            String orderId = "ORD" + System.currentTimeMillis();

            Book_Order order = new Book_Order();
            order.setOrderId(orderId);
            order.setUserId(userId);
            order.setUserName(req.getParameter("username"));
            order.setEmail(req.getParameter("email"));
            order.setPhno(req.getParameter("phno"));
            order.setFullAdd(
                    req.getParameter("address") + ", " +
                            req.getParameter("landmark") + ", " +
                            req.getParameter("city") + ", " +
                            req.getParameter("state") + ", " +
                            req.getParameter("pincode"));
            order.setBookName("Multiple Items");
            order.setAuthor("-");
            order.setQuantity(totalQty);
            order.setPrice(grandTotal);
            order.setTotalAmount(grandTotal);

            Connection conn = DBConnect.getConn();
            conn.setAutoCommit(false);

            try {

                BookOrderImpl orderDao = new BookOrderImpl(conn);
                WalletDAOImpl walletDao = new WalletDAOImpl(conn);

                // ================= WALLET FLOW =================
                if (paymentType.equals("WALLET")) {

                    double walletBalance = walletDao.getBalanceByUser(userId);

                    if (walletBalance < grandTotal) {
                        conn.rollback();
                        session.setAttribute("failedMsg", "Insufficient wallet balance");
                        resp.sendRedirect("checkout.jsp");
                        return;
                    }

                    order.setPaymentMethod("WALLET");
                    order.setPaymentStatus("PAID");
                    order.setStatus("PLACED");

                    if (!orderDao.placeSingleOrderWithStock(order, cartList) ||
                            !orderDao.insertOrderItems(orderId, cartList)) {

                        conn.rollback();
                        session.setAttribute("failedMsg", "Order creation failed");
                        resp.sendRedirect("checkout.jsp");
                        return;
                    }

                    PreparedStatement ps = conn.prepareStatement(
                            "INSERT INTO wallet_transactions(user_id, amount, type, description) VALUES (?, ?, 'DEBIT', ?)");
                    ps.setInt(1, userId);
                    ps.setDouble(2, grandTotal);
                    ps.setString(3, "Order Payment - " + orderId);
                    ps.executeUpdate();
                }

                // ================= COD =================
                else if (paymentType.equals("COD")) {

                    order.setPaymentMethod("COD");
                    order.setPaymentStatus("PENDING");
                    order.setStatus("PLACED");

                    if (!orderDao.placeSingleOrderWithStock(order, cartList) ||
                            !orderDao.insertOrderItems(orderId, cartList)) {

                        conn.rollback();
                        session.setAttribute("failedMsg", "Stock not available");
                        resp.sendRedirect("checkout.jsp");
                        return;
                    }

                }

                // ================= ONLINE =================
                else {

                    order.setPaymentMethod("ONLINE");
                    order.setPaymentStatus("INITIATED");
                    order.setStatus("PAYMENT_PENDING");

                    if (!orderDao.placeSingleOrderWithStock(order, cartList) ||
                            !orderDao.insertOrderItems(orderId, cartList)) {

                        conn.rollback();
                        session.setAttribute("failedMsg", "Stock not available");
                        resp.sendRedirect("checkout.jsp");
                        return;
                    }

                }

                conn.commit();

            } catch (Exception e) {
                conn.rollback();
                throw e;
            } finally {
                conn.close();
            }

            cartDao.deleteCart(userId);

            if (paymentType.equals("ONLINE")) {
                resp.sendRedirect("payment/initiate?orderId=" + orderId);
            } else {
                AuditLogger.log(req,
                        "ORDER_PLACED",
                        "ORDER",
                        orderId,
                        "Order placed successfully via " + paymentType);

                EmailSender.sendOrderPlacedEmail(order.getEmail(), order.getUserName(), orderId);
                resp.sendRedirect("order_success.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("failedMsg", "Something went wrong");
            resp.sendRedirect("checkout.jsp");
        }
    }
}
