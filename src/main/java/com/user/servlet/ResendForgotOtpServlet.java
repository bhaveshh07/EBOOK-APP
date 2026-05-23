package com.user.servlet;

import java.io.IOException;

import com.util.EmailSender;
import com.util.OTPGenerator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/resendForgotOtp")
public class ResendForgotOtpServlet extends HttpServlet {

protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
            

    HttpSession session = req.getSession();
    String email = (String) session.getAttribute("fpEmail");

    String otp = OTPGenerator.generateOTP();

    String msg =
        "<h2>Ebook App</h2>" +
        "<p>Your new OTP:</p>" +
        "<h1>" + otp + "</h1>";

    EmailSender.sendEmail(email,"Resend OTP",msg);

    session.setAttribute("fpOtp", otp);
    session.setAttribute("fpOtpTime", System.currentTimeMillis());

    session.setAttribute("succMsg","New OTP Sent!");
    resp.sendRedirect("verify_fp_otp.jsp");
}
}
