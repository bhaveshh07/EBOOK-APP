package com.user.servlet;

import java.io.IOException;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.DAO.BookOrderImpl;
import com.DBMS.DBConnect;
import com.entity.Book_Order;
import com.entity.Cart;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/order_items_details")
public class OrderItemsDetailsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderId = request.getParameter("orderId");

        if (orderId == null || orderId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        BookOrderImpl dao = new BookOrderImpl(DBConnect.getConn());

        List<Cart> items = dao.getOrderItems(orderId);
        Book_Order order = dao.getOrderByOrderId(orderId);

        double itemsTotal = 0;
        for (Cart c : items) {
            if (c.getTotalPrice() != null) {
                itemsTotal += c.getTotalPrice();
            }
        }

        double grandTotal = order != null ? order.getTotalAmount() : itemsTotal;
        double deliveryCharge = grandTotal - itemsTotal;

        Map<String, Object> result = new HashMap<>();
        result.put("items", items);
        result.put("itemsTotal", itemsTotal);
        result.put("deliveryCharge", deliveryCharge);
        result.put("grandTotal", grandTotal);

        if (order != null) {
            result.put("shippingAddress", order.getFullAdd());
            result.put("paymentMethod", order.getPaymentMethod());
            result.put("paymentStatus", order.getPaymentStatus());
            result.put("orderDate", order.getOrderDate());
            result.put("razorpayOrderId", order.getRazorpayOrderId());
            result.put("razorpayPaymentId", order.getRazorpayPaymentId());
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        new Gson().toJson(result, response.getWriter());
    }
}