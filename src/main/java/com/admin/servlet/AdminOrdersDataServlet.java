package com.admin.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.DAO.BookOrderImpl;
import com.DBMS.DBConnect;
import com.entity.Book_Order;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/orders-data")
public class AdminOrdersDataServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        resp.setContentType("application/json");

        List<Book_Order> list = new BookOrderImpl(DBConnect.getConn()).getAllOrders();

        PrintWriter out = resp.getWriter();
        out.print("[");

        for (int i = 0; i < list.size(); i++) {

            Book_Order o = list.get(i);

            out.print("{");
            out.print("\"id\":" + o.getId() + ",");
            out.print("\"orderId\":\"" + o.getOrderId() + "\",");
            out.print("\"userName\":\"" + o.getUserName() + "\",");
            out.print("\"bookName\":\"" + o.getBookName() + "\",");
            out.print("\"price\":" + o.getPrice() + ",");
            out.print("\"quantity\":" + o.getQuantity() + ",");
            out.print("\"payment\":\"" + o.getPaymentMethod() + " (" + o.getPaymentStatus() + ")\",");
            out.print("\"status\":\"" + o.getStatus() + "\"");
            out.print("}");

            if (i < list.size() - 1)
                out.print(",");
        }

        out.print("]");
    }
}
