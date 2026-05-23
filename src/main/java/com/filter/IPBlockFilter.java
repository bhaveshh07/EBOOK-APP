package com.filter;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.DBMS.DBConnect;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;

@WebFilter("/*")
public class IPBlockFilter implements Filter {

    public void doFilter(ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        String ip = req.getRemoteAddr();

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            conn = DBConnect.getConn();

            String sql = "SELECT 1 FROM blocked_ips " +
                    "WHERE ip_address=? AND blocked_until > NOW()";

            ps = conn.prepareStatement(sql);
            ps.setString(1, ip);

            rs = ps.executeQuery();

            if (rs.next()) {
                response.getWriter()
                        .write("Your IP is temporarily blocked.");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {

            try {
                if (rs != null)
                    rs.close();
                if (ps != null)
                    ps.close();
                if (conn != null)
                    conn.close(); //  CRITICAL
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        chain.doFilter(request, response);
    }

}
