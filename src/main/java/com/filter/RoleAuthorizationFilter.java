package com.filter;

import java.io.IOException;

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
public class RoleAuthorizationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String context = req.getContextPath();
        String path = uri.substring(context.length());

        HttpSession session = req.getSession(false);

        /*
         * =========================================================
         *  ALLOW STATIC RESOURCES (VERY IMPORTANT)
         * =========================================================
         */

        if (path.contains(".css") ||
                path.contains(".js") ||
                path.contains(".png") ||
                path.contains(".jpg") ||
                path.contains(".jpeg") ||
                path.contains(".gif") ||
                path.contains(".svg") ||
                path.contains(".woff") ||
                path.contains(".woff2") ||
                path.contains(".ttf") ||
                path.contains(".ico")) {

            chain.doFilter(request, response);
            return;
        }

        /*
         * =========================================================
         *  PUBLIC ROUTES (NO LOGIN REQUIRED)
         * =========================================================
         */

        if (path.equals("/") ||
                path.equals("/index.jsp") ||

                path.equals("/login.jsp") ||
                path.equals("/Register.jsp") ||
                path.equals("/forgot_password.jsp") ||
                path.equals("/verify_fp_otp.jsp") ||
                path.equals("/reset_password.jsp") ||
                path.equals("/otp.jsp") ||

                path.equals("/login") ||
                path.equals("/Register") ||
                path.equals("/forgotPassword") ||
                path.equals("/verifyForgotOtp") ||
                path.equals("/resetPassword") ||
                path.equals("/verifyOtp")) {

            chain.doFilter(request, response);
            return;
        }

        /*
         * =========================================================
         *  BLOCK IF NOT LOGGED IN
         * =========================================================
         */

        if (session == null || session.getAttribute("role") == null) {
            resp.sendRedirect(context + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");

        /*
         * =========================================================
         *  ADMIN PROTECTION
         * =========================================================
         */

        if (path.startsWith("/admin/") && !"ADMIN".equals(role)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin Only");
            return;
        }

        /*
         * =========================================================
         *  USER PROTECTION
         * =========================================================
         */

        if ((path.startsWith("/order") ||
                path.startsWith("/checkout") ||
                path.startsWith("/payment")) &&
                !"USER".equals(role)) {

            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: User Only");
            return;
        }

        /*
         * =========================================================
         *  ALLOW EVERYTHING ELSE
         * =========================================================
         */

        chain.doFilter(request, response);
    }
}
