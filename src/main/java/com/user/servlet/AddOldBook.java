package com.user.servlet;

import java.io.IOException;
import java.sql.Connection;

import com.DAO.BookDAOImpl;
import com.DAO.GenreDAOImpl;
import com.DBMS.DBConnect;
import com.entity.BookDtls;
import com.entity.User;
import com.util.UploadUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/add_old_book")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
public class AddOldBook extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		HttpSession session = req.getSession(false);

		if (session == null || session.getAttribute("userobj") == null) {
			resp.sendRedirect("login.jsp");
			return;
		}

		try {

			User u = (User) session.getAttribute("userobj");

			String bookName = req.getParameter("bname");
			String author = req.getParameter("author");
			String price = req.getParameter("price");
			String description = req.getParameter("description");

			// NEW — GET STOCK
			int stock = 1; // default safe value

			try {
				stock = Integer.parseInt(req.getParameter("stock"));
				if (stock < 1)
					stock = 1;
			} catch (Exception e) {
				stock = 1;
			}

			String category = "Old";
			String status = "Active";
			String useremail = u.getEmail();

			Part part = req.getPart("bimg");

			String path = "D:/ebook_uploads/book";
			String fileName;

			try {
				fileName = UploadUtils.validateAndSaveImage(part, path);
			} catch (Exception ex) {
				session.setAttribute("failedMsg", ex.getMessage());
				resp.sendRedirect("sell_book.jsp");
				return;
			}

			if (fileName == null) {
				session.setAttribute("failedMsg", "Please upload a valid image");
				resp.sendRedirect("sell_book.jsp");
				return;
			}

			// Create object
			BookDtls b = new BookDtls(
					bookName,
					author,
					price,
					category,
					status,
					fileName,
					useremail,
					description);

			// SET STOCK HERE
			b.setStock(stock);

			try (Connection conn = DBConnect.getConn()) {

				BookDAOImpl dao = new BookDAOImpl(conn);
				boolean f = dao.addbooks(b);

				if (f) {

					String[] genreIds = req.getParameterValues("genreIds");

					if (genreIds != null) {

						int bookId = b.getBookId(); // SAFE GENERATED KEY

						GenreDAOImpl gdao = new GenreDAOImpl(conn);

						for (String gid : genreIds) {
							gdao.addBookGenreMapping(bookId, Integer.parseInt(gid));
						}
					}

					session.setAttribute("succMsg", "Book Added Successfully!");

				} else {
					session.setAttribute("failedMsg", "Something went wrong!");
				}
			}

			resp.sendRedirect("sell_book.jsp");

		} catch (Exception e) {
			e.printStackTrace();
			resp.sendRedirect("add_old_book");
		}
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		System.out.println("SELL BOOK DOGET CALLED");

		HttpSession session = req.getSession();

		if (session.getAttribute("CSRF_TOKEN") == null) {
			String token = java.util.UUID.randomUUID().toString();
			session.setAttribute("CSRF_TOKEN", token);
		}

		GenreDAOImpl gdao = new GenreDAOImpl(DBConnect.getConn());
		req.setAttribute("genreList", gdao.getActiveGenres());

		req.getRequestDispatcher("sell_book.jsp")
				.forward(req, resp);
	}

}
