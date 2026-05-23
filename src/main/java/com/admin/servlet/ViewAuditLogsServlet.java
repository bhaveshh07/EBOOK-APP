package com.admin.servlet;

import java.io.IOException;
import java.util.List;

import com.DAO.AuditLogDAOImpl;
import com.entity.AuditLog;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/audit")
public class ViewAuditLogsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {     
        AuditLogDAOImpl dao = new AuditLogDAOImpl();
        List<AuditLog> logs = dao.getAllLogs();

        req.setAttribute("logs", logs);
        req.getRequestDispatcher("/admin/audit_logs.jsp")
                .forward(req, resp);
    }
}
