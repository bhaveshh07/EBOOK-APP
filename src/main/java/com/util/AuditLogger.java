package com.util;

import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import com.DBMS.DBConnect;

public class AuditLogger {

    public static void log(HttpServletRequest request,
            String actionType,
            String entity,
            String entityId,
            String description) {
        System.out.println(" AUDIT LOGGER TRIGGERED → " + actionType);

        try (Connection conn = DBConnect.getConn()) {

            HttpSession session = request.getSession(false);

            Integer userId = null;
            String role = "ANONYMOUS";

            if (session != null) {
                userId = (Integer) session.getAttribute("userId");

                Object userObj = session.getAttribute("userobj");
                if (userObj != null) {
                    role = "USER";
                }

                if ("admin@gmail.com".equals(
                        request.getParameter("email"))) {
                    role = "ADMIN";
                }
            }

            String ip = request.getRemoteAddr();
            String userAgent = request.getHeader("User-Agent");

            String sql = "INSERT INTO audit_logs " +
                    "(user_id, role, action_type, entity, entity_id, description, ip_address, user_agent) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            if (userId != null)
                ps.setInt(1, userId);
            else
                ps.setNull(1, java.sql.Types.INTEGER);

            ps.setString(2, role);
            ps.setString(3, actionType);
            ps.setString(4, entity);
            ps.setString(5, entityId);
            ps.setString(6, description);
            ps.setString(7, ip);
            ps.setString(8, userAgent);

            ps.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException("AUDIT INSERT FAILED", e);
        }

    }
}
