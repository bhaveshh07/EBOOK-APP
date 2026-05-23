package com.DAO;

import java.util.List;

import com.entity.BookDtls;

public interface BookDAO {

    public boolean addbooks(BookDtls b);

    public List<BookDtls> getAllBooks();

    public BookDtls getBookById(int id);

    public boolean updateEditBooks(BookDtls b);

    public boolean deleteBooks(int id);

    public List<BookDtls> getNewBooks();

    public List<BookDtls> getRecentBooks();

    public List<BookDtls> getOldBooks();

    public List<BookDtls> AllRecentBooks();

    public List<BookDtls> AllNewBooks();

    public List<BookDtls> AllOldBooks();

    public List<BookDtls> getBookByOld(String email, String cate);

    public boolean oldBookDelete(String email, String cat, int id);

    public int getTotalListingsByUser(int userId);

    public int getBooksSoldByUser(int userId);

    public double getTotalEarningsByUser(int userId);

    List<BookDtls> getBookBySearch(
            String ch,
            String sort,
            String category,
            double minPrice,
            double maxPrice,
            int start,
            int limit,
            Integer userId);

    int getSearchCount(
            String ch,
            String category,
            double minPrice,
            double maxPrice);
}