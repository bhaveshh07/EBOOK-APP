package com.user.servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.DAO.BookDAO;
import com.DAO.BookDAOImpl;
import com.DAO.BookOrderDAO;
import com.DAO.BookOrderImpl;
import com.DAO.SellerWalletDAOImpl;
import com.DAO.WalletDAOImpl;
import com.DBMS.DBConnect;
import com.entity.User;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userobj");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = user.getId();

        // ================= DAO INITIALIZATION =================
        BookOrderDAO orderDAO = new BookOrderImpl(DBConnect.getConn());
        WalletDAOImpl walletDAO = new WalletDAOImpl(DBConnect.getConn());
        BookDAO bookDAO = new BookDAOImpl(DBConnect.getConn());
        SellerWalletDAOImpl sellerWalletDao = new SellerWalletDAOImpl(DBConnect.getConn());

        // ================= BUYER STATS =================
        int totalOrders = orderDAO.getTotalOrdersByUser(userId);
        int activeOrders = orderDAO.getActiveOrdersByUser(userId);
        double walletBalance = walletDAO.getBalanceByUser(userId);

        // ================= SELLER STATS =================
        int totalListings = bookDAO.getTotalListingsByUser(userId);
        int booksSold = sellerWalletDao.getSellerBooksSold(userId);
        double totalEarnings = sellerWalletDao.getSellerTotalEarnings(userId);
        double sellerBalance = sellerWalletDao.getSellerBalance(userId);

        List<Double> monthlyRevenue = sellerWalletDao.getMonthlyRevenue(userId);

        // ================= SET ATTRIBUTES =================
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("activeOrders", activeOrders);
        request.setAttribute("walletBalance", walletBalance);

        request.setAttribute("totalListings", totalListings);
        request.setAttribute("booksSold", booksSold);
        request.setAttribute("totalEarnings", totalEarnings);
        request.setAttribute("sellerBalance", sellerBalance);
        request.setAttribute("monthlyRevenue", monthlyRevenue);

        request.getRequestDispatcher("setting.jsp").forward(request, response);
    }
}
