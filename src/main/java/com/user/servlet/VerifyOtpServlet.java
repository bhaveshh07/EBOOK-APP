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
@WebServlet("/verifyOtp")
public class VerifyOtpServlet extends HttpServlet {

protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

    HttpSession session = req.getSession();

    String userOtp = req.getParameter("otp");
    String sessionOtp = (String) session.getAttribute("otp");
    Long otpTime = (Long) session.getAttribute("otpTime");
    User us = (User) session.getAttribute("userData");

    // Debug (optional)
    System.out.println("User OTP: " + userOtp);
    System.out.println("Session OTP: " + sessionOtp);

    if(sessionOtp == null || otpTime == null){
        session.setAttribute("failedMsg","OTP Expired. Please register again.");
        resp.sendRedirect("Register.jsp");
        return;
    }

    long currentTime = System.currentTimeMillis();
    long diff = currentTime - otpTime;   // milliseconds

    // 5 minutes = 300000 ms
    if(diff > 300000){
        session.removeAttribute("otp");
        session.removeAttribute("otpTime");
        session.removeAttribute("userData");

        session.setAttribute("failedMsg","OTP Expired");
        resp.sendRedirect("Register.jsp");
        return;
    }

    if(userOtp != null && userOtp.trim().equals(sessionOtp.trim())){

        UserDAOImpl dao = new UserDAOImpl(DBConnect.getConn());
        dao.userRegister(us);

        session.removeAttribute("otp");
        session.removeAttribute("otpTime");
        session.removeAttribute("userData");

        session.setAttribute("succMsg","Registration Successful!");
        resp.sendRedirect("login.jsp");

    } else {
        session.setAttribute("failedMsg","Invalid OTP");
        resp.sendRedirect("otp.jsp");
    }
}
}
