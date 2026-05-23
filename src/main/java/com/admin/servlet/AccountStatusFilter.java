package com.admin.servlet;

import java.io.IOException;

import com.DAO.UserDAOImpl;
import com.DBMS.DBConnect;
import com.entity.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/*")
public class AccountStatusFilter implements Filter {

    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        if (session != null) {

            User user = (User) session.getAttribute("userobj");

            if (user != null) {

                UserDAOImpl dao = new UserDAOImpl(DBConnect.getConn());
                User freshUser = dao.getUserByEmail(user.getEmail());

                if (freshUser != null &&
                        ("FROZEN".equalsIgnoreCase(freshUser.getAccountStatus())
                        || "TERMINATED".equalsIgnoreCase(freshUser.getAccountStatus()))) {

                    session.invalidate();
                    resp.sendRedirect(req.getContextPath() + "/login.jsp");
                    return;
                }
            }
        }

        chain.doFilter(request, response);
    }
}