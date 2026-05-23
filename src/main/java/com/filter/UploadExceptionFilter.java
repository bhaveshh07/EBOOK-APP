package com.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/*")
public class UploadExceptionFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        try {
            chain.doFilter(req, res);

        } catch (IllegalStateException ex) {

            //  Handle multipart size exception
            if (ex.getCause() != null &&
                    ex.getCause().getClass().getName()
                            .contains("FileSizeLimitExceededException")) {

                HttpSession session = request.getSession();
                session.setAttribute(
                        "failedMsg",
                        "File size must be less than 5MB");

                String referer = request.getHeader("referer");
                response.sendRedirect(
                        referer != null ? referer : "index.jsp");

                return; // ✅ DO NOT rethrow
            }

            // Any other IllegalStateException → rethrow
            throw ex;
        }
    }

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void destroy() {
    }
}
