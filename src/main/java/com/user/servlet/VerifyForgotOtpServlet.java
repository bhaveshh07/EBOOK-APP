package com.user.servlet;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/verifyForgotOtp")
public class VerifyForgotOtpServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        String userOtp = req.getParameter("otp");
        String sessionOtp = (String) session.getAttribute("fpOtp");
        Long otpTime = (Long) session.getAttribute("fpOtpTime");

        // OTP Expiry 5 min
        if (otpTime == null || System.currentTimeMillis() - otpTime > 300000) {
            session.setAttribute("failedMsg", "OTP Expired");
           resp.sendRedirect(req.getContextPath() + "/verify_fp_otp.jsp");

            return;
        }
        System.out.println("Session OTP = " + sessionOtp);
        System.out.println("User OTP = " + userOtp);

        if (userOtp != null && userOtp.equals(sessionOtp)) {

            session.setAttribute("otpVerified", true);

            resp.sendRedirect(req.getContextPath() + "/reset_password.jsp");
        } else {
            session.setAttribute("failedMsg", "Invalid OTP");
            resp.sendRedirect(req.getContextPath() + "/verify_fp_otp.jsp");

        }
    }
}
