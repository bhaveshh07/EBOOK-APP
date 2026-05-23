package com.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CSRFFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String method = req.getMethod();
        String path = req.getRequestURI()
                .substring(req.getContextPath().length());

        // =====================================================
        // Allow SAFE HTTP METHODS
        // =====================================================
        if ("GET".equalsIgnoreCase(method) ||
                "HEAD".equalsIgnoreCase(method) ||
                "OPTIONS".equalsIgnoreCase(method)) {

            chain.doFilter(request, response);
            return;
        }

        // =====================================================
        // Allow STATIC RESOURCES
        // =====================================================
        if (path.contains("/css/") ||
                path.contains("/js/") ||
                path.contains("/img/") ||
                path.endsWith(".css") ||
                path.endsWith(".js") ||
                path.endsWith(".png") ||
                path.endsWith(".jpg") ||
                path.endsWith(".jpeg") ||
                path.endsWith(".gif")) {

            chain.doFilter(request, response);
            return;
        }

        // =====================================================
        // Allow RAZORPAY CALLBACK (NO CSRF TOKEN HERE)
        // =====================================================
        if (path.contains("/payment/verify")) {
            chain.doFilter(request, response);
            return;
        }

        // =====================================================
        // CSRF PROTECTION FOR POST REQUESTS
        // =====================================================
        if ("POST".equalsIgnoreCase(method)) {

            // Allow auth related endpoints without CSRF
            if (path.endsWith("/login") ||
                    path.endsWith("/Register") ||
                    path.endsWith("/verifyOtp") ||
                    path.endsWith("/forgotPassword") ||
                    path.endsWith("/resetPassword") ||
                    path.endsWith("/verifyForgotOtp") ||
                    path.endsWith("/resendForgotOtp")) {

                chain.doFilter(request, response);
                return;
            }

            HttpSession session = req.getSession(false);
            if (session == null) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Session expired");
                return;
            }

            String sessionToken = (String) session.getAttribute("CSRF_TOKEN");

            // Check both header (AJAX) and form param
            String requestToken = req.getHeader("X-CSRF-TOKEN");

            if (requestToken == null || requestToken.isEmpty()) {
                requestToken = req.getParameter("csrf_token");
            }

            if (sessionToken == null ||
                    requestToken == null ||
                    !sessionToken.equals(requestToken)) {

                res.sendError(HttpServletResponse.SC_FORBIDDEN, "CSRF validation failed");
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
