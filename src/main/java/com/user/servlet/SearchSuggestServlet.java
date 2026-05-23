package com.user.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.DBMS.DBConnect;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/search-suggest")
public class SearchSuggestServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("term");

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        List<String> suggestions = new ArrayList<>();

        try {
            String sql = "SELECT bookName FROM book_dtls " +
                    "WHERE LOWER(bookName) LIKE ? AND status='Active' " +
                    "LIMIT 5";

            Connection conn = DBConnect.getConn();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, keyword.toLowerCase() + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                suggestions.add(rs.getString("bookName"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        out.print(new Gson().toJson(suggestions));
        out.flush();
    }
}