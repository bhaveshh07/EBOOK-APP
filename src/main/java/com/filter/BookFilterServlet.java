package com.filter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.DAO.BookDAOImpl;
import com.DAO.GenreDAO;
import com.DAO.GenreDAOImpl;
import com.DBMS.DBConnect;
import com.entity.BookDtls;
import com.entity.Genre;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/books/filter")
public class BookFilterServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String genreParam = req.getParameter("genres");
        String sort = req.getParameter("sort");
        String minPrice = req.getParameter("minPrice");
        String maxPrice = req.getParameter("maxPrice");

        // CLEAN PRICE INPUT
        if (minPrice != null)
            minPrice = minPrice.trim();
        if (maxPrice != null)
            maxPrice = maxPrice.trim();
        if (minPrice != null && minPrice.isEmpty())
            minPrice = null;
        if (maxPrice != null && maxPrice.isEmpty())
            maxPrice = null;

        // Pagination
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

        List<BookDtls> bookList = dao.filterBooksAdvanced(
                selectedGenres,
                sort,
                minPrice,
                maxPrice,
                limit,
                offset);

        int totalBooks = dao.countFilteredBooks(
                selectedGenres,
                sort,
                minPrice,
                maxPrice);

        int totalPages = (int) Math.ceil((double) totalBooks / limit);

        Map<Integer, List<String>> bookGenresMap = new HashMap<>();
        for (BookDtls b : bookList) {
            bookGenresMap.put(
                    b.getBookId(),
                    dao.getGenresByBookId(b.getBookId()));
        }

        GenreDAO genreDao = new GenreDAOImpl(DBConnect.getConn());
        List<Genre> genreList = genreDao.getAllGenres();

        req.setAttribute("bookList", bookList);
        req.setAttribute("genreList", genreList);
        req.setAttribute("selectedGenres", selectedGenres);
        req.setAttribute("bookGenresMap", bookGenresMap);
        req.setAttribute("sort", sort);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalBooks", totalBooks);

        req.getRequestDispatcher("/filter_books.jsp")
                .forward(req, resp);
    }
}
