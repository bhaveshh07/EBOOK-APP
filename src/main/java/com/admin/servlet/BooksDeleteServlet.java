package com.admin.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.DBMS.DBConnect;
import com.util.AuditLogger;
import com.DAO.BookDAOImpl;

@WebServlet("/admin/delete-book")
public class BooksDeleteServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			int id = Integer.parseInt(req.getParameter("id"));

			BookDAOImpl dao = new BookDAOImpl(DBConnect.getConn());
			boolean f = dao.deleteBooks(id);
			HttpSession session = req.getSession();
			if (f) {
				AuditLogger.log(req,
						"BOOK_DELETED",
						"BOOK",
						String.valueOf(id),
						"Admin deleted book");

				session.setAttribute("succMsg", "Book Deleted Successfully...");
				resp.sendRedirect(req.getContextPath() + "/admin/books");

			} else {
				session.setAttribute("FailedMsg", "Something Went Wrong on Server");
				resp.sendRedirect(req.getContextPath() + "/admin/books");

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}