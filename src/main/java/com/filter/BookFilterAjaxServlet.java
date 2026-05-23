package com.filter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.DAO.BookDAOImpl;
import com.DBMS.DBConnect;
import com.entity.BookDtls;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/books/filter-ajax")
public class BookFilterAjaxServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String genreParam = req.getParameter("genres");
        String sort = req.getParameter("sort");
        String minPrice = req.getParameter("minPrice");
        String maxPrice = req.getParameter("maxPrice");

        //  CLEAN PRICE INPUT
        if (minPrice != null)
            minPrice = minPrice.trim();
        if (maxPrice != null)
            maxPrice = maxPrice.trim();
        if (minPrice != null && minPrice.isEmpty())
            minPrice = null;
        if (maxPrice != null && maxPrice.isEmpty())
            maxPrice = null;

        int page = 1;
        int limit = 6;

        String pageParam = req.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (Exception e) {
                page = 1;
            }
        }

        int offset = (page - 1) * limit;

        List<Integer> selectedGenres = new ArrayList<>();

        if (genreParam != null && !genreParam.trim().isEmpty()) {
            String[] ids = genreParam.split(",");
            for (String id : ids) {
                if (id != null && !id.trim().isEmpty()) {
                    try {
                        selectedGenres.add(Integer.parseInt(id.trim()));
                    } catch (Exception ignored) {
                    }
                }
            }
        }

        BookDAOImpl dao = new BookDAOImpl(DBConnect.getConn());

        List<BookDtls> books = dao.filterBooksAdvanced(
                selectedGenres,
                sort,
                minPrice,
                maxPrice,
                limit,
                offset);

        int totalCount = dao.countFilteredBooks(
                selectedGenres,
                sort,
                minPrice,
                maxPrice);

        for (BookDtls b : books) {
            b.setGenres(dao.getGenresByBookId(b.getBookId()));
        }

        Map<String, Object> response = new HashMap<>();
        response.put("books", books);
        response.put("total", totalCount);

        Gson gson = new Gson();
        String json = gson.toJson(response);

        resp.getWriter().write(json);
    }
}
