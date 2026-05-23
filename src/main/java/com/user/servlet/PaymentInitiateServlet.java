package com.user.servlet;

import java.io.IOException;
import java.sql.Connection;

import com.DAO.BookOrderImpl;
import com.DBMS.DBConnect;
import com.entity.Book_Order;
import com.razorpay.Order;
import com.razorpay.RazorpayClient;

import org.json.JSONObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/payment/initiate")
public class PaymentInitiateServlet extends HttpServlet {

    private static final String RZP_KEY = "rzp_test_S4rlK1Kg7FHbvF";
    private static final String RZP_SECRET = "ANbDQi0Sv7YMp4Ov4zp49t8z";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String orderId = req.getParameter("orderId");
        if (orderId == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        Connection conn = null;

        try {
            conn = DBConnect.getConn();
            conn.setAutoCommit(false);

            BookOrderImpl orderDao = new BookOrderImpl(conn);
            Book_Order order = orderDao.getOrderByOrderId(orderId);

            if (order == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            if (!"ONLINE".equals(order.getPaymentMethod())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            if (!("INITIATED".equals(order.getPaymentStatus()) ||
                    "FAILED".equals(order.getPaymentStatus()))) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            // If retry (previously FAILED)
            if ("FAILED".equals(order.getPaymentStatus())) {

                System.out.println("Retry detected — resetting payment state");

                //  Reset payment state correctly
                orderDao.resetPaymentToInitiated(order.getId());

                // Clear old Razorpay order id
                orderDao.updateRazorpayOrderId(order.getId(), null);

                conn.commit();

                // Reload fresh order
                order = orderDao.getOrderByOrderId(orderId);
            }

            Integer sessionUserId = (Integer) session.getAttribute("userId");
            if (order.getUserId() != sessionUserId) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            int amountPaise = (int) (order.getTotalAmount() * 100);

            System.out.println("STEP 3 HIT → orderId = " + orderId);
            System.out.println(
                    "Order found: " + order.getOrderId() +
                            " | paymentMethod=" + order.getPaymentMethod() +
                            " | paymentStatus=" + order.getPaymentStatus() +
                            " | amount=" + order.getTotalAmount());

            // Only reuse Razorpay order if still INITIATED
            if ("INITIATED".equals(order.getPaymentStatus())
                    && order.getRazorpayOrderId() != null) {

                System.out.println("Reusing Razorpay orderId: " + order.getRazorpayOrderId());

                req.setAttribute("razorpayOrderId", order.getRazorpayOrderId());
                req.setAttribute("amount", amountPaise);
                req.setAttribute("orderId", order.getOrderId());
                req.setAttribute("razorpayKey", RZP_KEY);
                req.getRequestDispatcher("/razorpay.jsp").forward(req, resp);
                return;
            }

            // Create Razorpay order
            RazorpayClient client = new RazorpayClient(RZP_KEY, RZP_SECRET);

            JSONObject options = new JSONObject();
            options.put("amount", amountPaise);
            options.put("currency", "INR");
            options.put("receipt", order.getOrderId());
            options.put("payment_capture", 1);

            Order razorpayOrder = client.orders.create(options);
            String rpOrderId = razorpayOrder.get("id");

            boolean updated = orderDao.updateRazorpayOrderId(order.getId(), rpOrderId);
            if (!updated) {
                throw new RuntimeException("Failed to store Razorpay order ID");
            }

            conn.commit();

            System.out.println("Razorpay order created & saved: " + rpOrderId);

            req.setAttribute("razorpayOrderId", rpOrderId);
            req.setAttribute("amount", amountPaise);
            req.setAttribute("orderId", order.getOrderId());
            req.setAttribute("razorpayKey", RZP_KEY);

            req.getRequestDispatcher("/razorpay.jsp").forward(req, resp);

        } catch (Exception e) {
            try {
                if (conn != null)
                    conn.rollback();
            } catch (Exception ex) {
            }
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

        } finally {
            try {
                if (conn != null)
                    conn.close();
            } catch (Exception e) {
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
