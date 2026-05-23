package com.admin.servlet;

import java.io.IOException;
import java.util.List;

import com.DAO.ContactDAO;
import com.DBMS.DBConnect;
import com.entity.Contact;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/contact")
public class AdminContactServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        ContactDAO dao = new ContactDAO(DBConnect.getConn());
        List<Contact> list = dao.getAllMessages();

        req.setAttribute("contactList", list);
        req.getRequestDispatcher("/admin/contact_inbox.jsp")
           .forward(req, resp);
    }
}
