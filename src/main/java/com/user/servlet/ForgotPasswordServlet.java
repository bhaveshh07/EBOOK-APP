package com.user.servlet;

import java.io.IOException;

import com.DAO.UserDAOImpl;
import com.DBMS.DBConnect;
import com.util.EmailSender;
import com.util.OTPGenerator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        String email = req.getParameter("email");

        // If coming from resend button
        if (email == null) {
            email = (String) session.getAttribute("fpEmail");
        }

        email = email.trim().toLowerCase();

        UserDAOImpl dao = new UserDAOImpl(DBConnect.getConn());

        // check user exists
        if (dao.isEmailExists(email)) {

            // ALWAYS generate fresh OTP
            String otp = OTPGenerator.generateOTP();

            String msg = "<h2>Ebook App - Password Reset</h2>" +
                    "<p>Your OTP is:</p>" +
                    "<h1 style='color:green'>" + otp + "</h1>" +
                    "<p>Valid for 5 minutes</p>";

            EmailSender.sendEmail(email, "Reset Password OTP", msg);

            // overwrite old OTP
            session.setAttribute("fpOtp", otp);
            session.setAttribute("fpEmail", email);
            session.setAttribute("fpOtpTime", System.currentTimeMillis());

            resp.sendRedirect(req.getContextPath() + "/verify_fp_otp.jsp");
        } else {
            session.setAttribute("failedMsg", "Email not registered!");
            resp.sendRedirect(req.getContextPath() + "/forgot_password.jsp");
        }
    }
}
