package com.admin.servlet;

import java.io.IOException;
import java.util.List;

import com.DAO.BookDAOImpl;
import com.DBMS.DBConnect;
import com.entity.BookDtls;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/books")
public class AdminBooksServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        BookDAOImpl dao = new BookDAOImpl(DBConnect.getConn());
        List<BookDtls> list = dao.getAllBooks();

        req.setAttribute("bookList", list);

        req.getRequestDispatcher("/admin/all_books.jsp")
                .forward(req, resp);
    }
}
