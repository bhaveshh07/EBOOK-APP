package com.user.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.DBMS.DBConnect;
import com.util.EmailSender;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/contactMessage")
public class ContactServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        boolean saved = false;

        try {
            Connection con = DBConnect.getConn();
            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO contact_messages(name,email,message) VALUES(?,?,?)");

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, message);

            ps.executeUpdate();
            saved = true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (saved) {

            // admin receives
            EmailSender.sendContactMessageEmail(name, email, message);

            // user receives auto reply
            EmailSender.sendAutoReply(email, name);

            response.sendRedirect("contact.jsp?success=1");
        } else {
            response.sendRedirect("contact.jsp?error=1");
        }
    }
}
