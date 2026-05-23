package com.user.servlet;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;


import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;


import com.DAO.BookOrderImpl;
import com.DAO.CartDAOImpl;
import com.DBMS.DBConnect;
import com.entity.Book_Order;

import com.util.AuditLogger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/payment/verify")
public class PaymentVerifyServlet extends HttpServlet {

    private static final String RZP_SECRET = "ANbDQi0Sv7YMp4Ov4zp49t8z";

    private void debug(String msg) {
        System.out.println("[PAYMENT-DEBUG] " + msg);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        debug("PaymentVerifyServlet HIT");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        int sessionUserId = (int) session.getAttribute("userId");

        String orderId = req.getParameter("orderId");
        String razorpayPaymentId = req.getParameter("razorpay_payment_id");
        String razorpayOrderId = req.getParameter("razorpay_order_id");
        String razorpaySignature = req.getParameter("razorpay_signature");
        debug("orderId=" + orderId);
        debug("razorpay_payment_id=" + razorpayPaymentId);
        debug("razorpay_order_id=" + razorpayOrderId);
        debug("razorpay_signature length=" +
                (razorpaySignature != null ? razorpaySignature.length() : 0));

        if (orderId == null || razorpayPaymentId == null ||
                razorpayOrderId == null || razorpaySignature == null) {
            resp.sendRedirect(req.getContextPath() + "/payment_failed.jsp");
            return;
        }

        Connection conn = null;

        try {
            conn = DBConnect.getConn();
            conn.setAutoCommit(false); // START TRANSACTION
            debug("DB connection acquired, autoCommit=false");

            BookOrderImpl orderDao = new BookOrderImpl(conn);
            CartDAOImpl cartDao = new CartDAOImpl(conn);          

            Book_Order order = orderDao.getOrderByOrderId(orderId);
            debug("Order fetched: " + (order != null));
            if (order != null) {
                debug("Order.userId=" + order.getUserId());
                debug("Order.paymentStatus=" + order.getPaymentStatus());
                debug("Order.razorpayOrderId=" + order.getRazorpayOrderId());
            }

            // Security check
            if (order == null || order.getUserId() != sessionUserId) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            // Idempotency (already paid)
            if ("PAID".equals(order.getPaymentStatus())) {
                debug("Order already PAID – redirecting to success");
                AuditLogger.log(req,
                        "PAYMENT_DUPLICATE_ATTEMPT",
                        "ORDER",
                        order.getOrderId(),
                        "User tried to re-verify already paid order");

                resp.sendRedirect(req.getContextPath() + "/order_success.jsp");

                return;
            }

            if (!"INITIATED".equals(order.getPaymentStatus())) {
                debug("Invalid payment state: " + order.getPaymentStatus());
                resp.sendRedirect(req.getContextPath() + "/my_orders");
                return;
            }

            // Razorpay order mismatch
            if (!razorpayOrderId.equals(order.getRazorpayOrderId())) {

                debug(" Razorpay Order ID mismatch");
                debug("Expected: " + order.getRazorpayOrderId());
                debug("Received: " + razorpayOrderId);

                // Mark payment as failed
                orderDao.updatePaymentFailure(order.getId());

                // Mark order status clearly
                orderDao.updateOrderStatus(order.getId(), "PAYMENT_FAILED");

                // Optional but recommended: clear old Razorpay order id
                orderDao.updateRazorpayOrderId(order.getId(), null);

                conn.commit();
                AuditLogger.log(req,
                        "PAYMENT_FAILED",
                        "ORDER",
                        order.getOrderId(),
                        "Razorpay order ID mismatch");

                resp.sendRedirect(req.getContextPath() + "/payment_failed.jsp");
                return;
            }
            // Signature verification
            String payload = razorpayOrderId + "|" + razorpayPaymentId;
            String generatedSignature = hmacSHA256(payload, RZP_SECRET);

            if (!generatedSignature.equals(razorpaySignature)) {

                debug(" Signature verification FAILED");

                orderDao.updatePaymentFailure(order.getId());
                orderDao.updateOrderStatus(order.getId(), "PAYMENT_FAILED");
                orderDao.updateRazorpayOrderId(order.getId(), null);

                conn.commit();
                AuditLogger.log(req,
                        "PAYMENT_FAILED",
                        "ORDER",
                        order.getOrderId(),
                        "Signature verification failed");

                resp.sendRedirect(req.getContextPath() + "/payment_failed.jsp");
                return;
            }

            debug("Signature verified successfully");

            // ================= ATOMIC SUCCESS =================

            // Mark payment PAID + order PLACED
            boolean paid = orderDao.markPaymentPaid(
                    order.getId(),
                    razorpayPaymentId,
                    razorpaySignature);
            debug("Payment marked PAID in DB: " + paid);

            if (!paid) {

                throw new RuntimeException("Payment update failed");
            }

            // Clear cart
            cartDao.clearCartByUser(order.getUserId());
            debug("About to COMMIT transaction");
            conn.commit(); // COMMIT EVERYTHING
            AuditLogger.log(req,
                    "PAYMENT_SUCCESS",
                    "ORDER",
                    order.getOrderId(),
                    "Online payment verified and completed");

            debug("Transaction COMMITTED successfully");
            debug("Redirecting to order_success.jsp");
            resp.sendRedirect(req.getContextPath() + "/order_success.jsp");

        } catch (Exception e) {
            try {
                if (conn != null) {
                    debug("EXCEPTION occurred, rolling back");
                    conn.rollback();
                }
            } catch (Exception ex) {
            }

            e.printStackTrace();
            debug("Redirecting to payment_failed.jsp");

            resp.sendRedirect(req.getContextPath() + "/payment_failed.jsp");

        } finally {
            try {
                if (conn != null) {
                    conn.close();
                    debug("DB connection closed");
                }
            } catch (Exception e) {
            }
        }
    }

    // Razorpay signature helper
    private String hmacSHA256(String data, String key) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            mac.init(secretKey);

            byte[] rawHmac = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder hex = new StringBuilder();

            for (byte b : rawHmac) {
                hex.append(String.format("%02x", b));
            }
            return hex.toString();

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
