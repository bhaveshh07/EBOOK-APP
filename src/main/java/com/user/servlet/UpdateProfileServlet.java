package com.user.servlet;

import java.io.IOException;

import com.DAO.UserDAOImpl;
import com.DBMS.DBConnect;
import com.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/update_profile")
public class UpdateProfileServlet extends HttpServlet {
	private static final int MAX_ATTEMPTS = 3;
	private static final long WINDOW_TIME = 5 * 60 * 1000; // 5 minutes

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		HttpSession session = req.getSession();

		Long firstAttemptTime = (Long) session.getAttribute("PROFILE_ATTEMPT_TIME");
		Integer attemptCount = (Integer) session.getAttribute("PROFILE_ATTEMPTS");

		long now = System.currentTimeMillis();

		// Init if first time
		if (firstAttemptTime == null || attemptCount == null) {
			firstAttemptTime = now;
			attemptCount = 0;
		}

		// Reset window if expired
		if (now - firstAttemptTime > WINDOW_TIME) {
			attemptCount = 0;
			firstAttemptTime = now;
		}

		// Block if exceeded
		if (attemptCount >= MAX_ATTEMPTS) {
			session.setAttribute("failedMsg",
					"Too many attempts. Please try again after 5 minutes.");
			resp.sendRedirect("edit_profile.jsp");
			return;
		}

		try {
			int id = Integer.parseInt(req.getParameter("id"));
			String name = req.getParameter("fname");
			String email = req.getParameter("email");
			String phno = req.getParameter("phno");
			String password = req.getParameter("password");

			User us = new User();
			us.setId(id);
			us.setName(name);
			us.setEmail(email);
			us.setPhno(phno);

			UserDAOImpl dao = new UserDAOImpl(DBConnect.getConn());

			boolean validPassword = dao.checkPassword(id, password);

			if (validPassword) {

				boolean updated = dao.updateProfile(us);

				if (updated) {
					session.setAttribute("succMsg", "Profile updated successfully");

					// ✅ RESET rate limit on success
					session.removeAttribute("PROFILE_ATTEMPTS");
					session.removeAttribute("PROFILE_ATTEMPT_TIME");

				} else {
					session.setAttribute("failedMsg", "Server error. Try again.");
				}

			} else {
				attemptCount++;
				session.setAttribute("PROFILE_ATTEMPTS", attemptCount);
				session.setAttribute("PROFILE_ATTEMPT_TIME", firstAttemptTime);

				session.setAttribute("failedMsg",
						"Incorrect password. Attempts left: " + (MAX_ATTEMPTS - attemptCount));
			}

			resp.sendRedirect("edit_profile.jsp");

		} catch (Exception e) {
			e.printStackTrace();
			session.setAttribute("failedMsg", "Unexpected error occurred");
			resp.sendRedirect("edit_profile.jsp");
		}
	}

}