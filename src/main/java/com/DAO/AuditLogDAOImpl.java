package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.DBMS.DBConnect;
import com.entity.AuditLog;

public class AuditLogDAOImpl {

    private Connection conn;

    public AuditLogDAOImpl() {
        conn = DBConnect.getConn();
    }

    public List<AuditLog> getAllLogs() {

        List<AuditLog> list = new ArrayList<>();

        try {

            String sql = "SELECT * FROM audit_logs ORDER BY created_at DESC LIMIT 200";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                AuditLog log = new AuditLog();

                log.setId(rs.getInt("id"));
                log.setUserId(rs.getInt("user_id"));
                log.setRole(rs.getString("role"));
                log.setActionType(rs.getString("action_type"));
                log.setEntity(rs.getString("entity"));
                log.setEntityId(rs.getString("entity_id"));
                log.setDescription(rs.getString("description"));
                log.setIpAddress(rs.getString("ip_address"));
                log.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(log);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countFailedLoginsLastHour(int userId) {

        try {
            String sql = "SELECT COUNT(*) FROM audit_logs " +
                    "WHERE user_id=? AND action_type='LOGIN_FAILED' " +
                    "AND created_at > NOW() - INTERVAL 1 HOUR";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next())
                return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int countFailedLoginsFromIPLastHour(String ip) {

        try {

            String sql = "SELECT COUNT(*) FROM audit_logs " +
                    "WHERE ip_address=? AND action_type='LOGIN_FAILED' " +
                    "AND created_at > NOW() - INTERVAL 1 HOUR";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, ip);

            ResultSet rs = ps.executeQuery();

            if (rs.next())
                return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

}
