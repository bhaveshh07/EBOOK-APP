package com.util;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/testMail")
public class TestEmailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) {


        boolean sent = EmailSender.sendEmail(
            "bhaveshpahujaonline@gmail.com",
            "Test Mail",
            "Hello Bhavesh, Email System Working!"
        );

        System.out.println(sent);
    }
}
