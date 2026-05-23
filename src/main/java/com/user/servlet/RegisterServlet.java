package com.user.servlet;

import java.io.IOException;

import com.DAO.UserDAOImpl;
import com.DBMS.DBConnect;
import com.entity.User;
import com.util.EmailSender;
import com.util.OTPGenerator;
import com.util.PasswordHash;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/Register")
public class RegisterServlet extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		try {

			HttpSession session = req.getSession();

			String name = req.getParameter("fname");
			if (name == null || name.trim().isEmpty()) {
				session.setAttribute("failedMsg", "Name cannot be empty");
				resp.sendRedirect(req.getContextPath() + "/Register.jsp");

				return;
			}
			name = name.trim();
			String email = req.getParameter("email");
			if (email == null || email.trim().isEmpty()) {
				session.setAttribute("failedMsg", "Email cannot be empty");
				resp.sendRedirect(req.getContextPath() + "/Register.jsp");

				return;
			}
			email = email.trim().toLowerCase();

			String phno = req.getParameter("phno");

			if (phno == null || phno.trim().isEmpty()) {
				session.setAttribute("failedMsg", "Phone number cannot be empty");
				resp.sendRedirect(req.getContextPath() + "/Register.jsp");

				return;
			}

			phno = phno.trim();

			String password = req.getParameter("password");
			if (password == null || password.trim().isEmpty()) {
				session.setAttribute("failedMsg", "Password cannot be empty");
				resp.sendRedirect(req.getContextPath() + "/Register.jsp");

				return;
			}

			if (password.length() < 6) {
				session.setAttribute("failedMsg", "Password must be at least 6 characters");
				resp.sendRedirect(req.getContextPath() + "/Register.jsp");

				return;
			}

			String check = req.getParameter("check");
			if (check == null) {
				session.setAttribute("failedMsg", "Please Agree the Terms and Conditions...");
				resp.sendRedirect(req.getContextPath() + "/Register.jsp");

				return;
			}

			// Hash password
			String encPassword = PasswordHash.hashPassword(password);

			// Create user object
			User us = new User();
			us.setName(name);
			us.setEmail(email);
			us.setPhno(phno);
			us.setPassword(encPassword);

			UserDAOImpl dao = new UserDAOImpl(DBConnect.getConn());

			// Check if user already exists
			boolean exists = dao.isEmailExists(email);

			if (!exists) {

				String otp = OTPGenerator.generateOTP();

				String message = "<div style='font-family:Arial;max-width:600px;margin:auto;border:1px solid #ddd;padding:20px;border-radius:10px'>"
						+
						"<h2 style='color:#2c3e50;text-align:center'>Ebook App Verification</h2>" +
						"<p>Hello,</p>" +
						"<p>Thank you for registering with <b>Ebook App</b>.</p>" +
						"<p>Please use the following OTP to verify your email:</p>" +
						"<div style='text-align:center;margin:20px'>" +
						"<span style='font-size:28px;letter-spacing:5px;font-weight:bold;color:#27ae60'>" + otp
						+ "</span>" +
						"</div>" +
						"<p>This OTP is valid for 5 minutes.</p>" +
						"<hr>" +
						"<p style='font-size:12px;color:gray;text-align:center'>© 2026 Ebook App</p>" +
						"</div>";

				EmailSender.sendEmail(email, "Verify Your Email - Ebook App", message);

				session.setAttribute("otp", otp);
				session.setAttribute("otpTime", System.currentTimeMillis());
				session.setAttribute("userData", us);

				resp.sendRedirect(req.getContextPath() + "/otp.jsp");

			} else {
				session.setAttribute("failedMsg", "User Already Exists!!");
				resp.sendRedirect(req.getContextPath() + "/Register.jsp");

			}

		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
