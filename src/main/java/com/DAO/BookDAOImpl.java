package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.DBMS.DBConnect;
import com.entity.BookDtls;
import com.util.SearchUtils;

public class BookDAOImpl implements BookDAO {

	private Connection conn;

	public BookDAOImpl(Connection conn) {
		super();
		this.conn = conn;
	}

	@Override
	public boolean addbooks(BookDtls b) {

		boolean f = false;

		try {

			String sql = "INSERT INTO book_dtls "
					+ "(bookname, author, price, bookCategory, status, photo, userEmail, description, stock) "
					+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

			PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);

			ps.setString(1, b.getBookName());
			ps.setString(2, b.getAuthor());
			ps.setString(3, b.getPrice());
			ps.setString(4, b.getBookCategory());
			ps.setString(5, b.getStatus());
			ps.setString(6, b.getPhotoName());
			ps.setString(7, b.getEmail()); // THIS IS THE FIX
			ps.setString(8, b.getDescription());
			ps.setInt(9, b.getStock());

			int i = ps.executeUpdate();
			ResultSet rs = ps.getGeneratedKeys();
			if (rs.next()) {
				b.setBookId(rs.getInt(1));
			}

			if (i == 1) {
				f = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return f;
	}

	public List<BookDtls> getAllBooks() {
		List<BookDtls> list = new ArrayList<>();
		String sql = "select * from book_dtls";

		try (PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				BookDtls b = new BookDtls();
				b.setBookId(rs.getInt(1));
				b.setBookName(rs.getString(2));
				b.setAuthor(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setBookCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
				b.setDescription(rs.getString("description"));

				list.add(b);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public BookDtls getBookById(int id) {
		BookDtls b = null;
		String sql = "select * from book_dtls where bookId=?";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					b = new BookDtls();
					b.setBookId(rs.getInt(1));
					b.setBookName(rs.getString(2));
					b.setAuthor(rs.getString(3));
					b.setPrice(rs.getString(4));
					b.setBookCategory(rs.getString(5));
					b.setStatus(rs.getString(6));
					b.setPhotoName(rs.getString(7));
					b.setEmail(rs.getString(8));
					b.setDescription(rs.getString("description"));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return b;
	}

	public boolean updateEditBooks(BookDtls b) {

		boolean f = false;

		try {

			String sql = "update book_dtls set bookName=?, author=?, price=?, status=?, photo=? where bookId=?";

			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setString(1, b.getBookName());
			ps.setString(2, b.getAuthor());
			ps.setString(3, b.getPrice());
			ps.setString(4, b.getStatus());
			ps.setString(5, b.getPhotoName());
			ps.setInt(6, b.getBookId());

			int i = ps.executeUpdate();

			if (i == 1) {
				f = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return f;
	}

	@Override
	public boolean deleteBooks(int id) {
		boolean f = false;

		try {

			String sql = "delete from book_dtls where bookId=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			int i = ps.executeUpdate();
			if (i == 1) {
				f = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return f;
	}

	@Override
	public List<BookDtls> getNewBooks() {
		List<BookDtls> list = new ArrayList<BookDtls>();
		BookDtls b = null;

		try {
			String sql = "select * from book_dtls where bookCategory=? and  status=? order by bookId DESC";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, "New");
			ps.setString(2, "Active");
			ResultSet rs = ps.executeQuery();
			int i = 1;
			while (rs.next() && i <= 4) {
				b = new BookDtls();
				b.setBookId(rs.getInt(1));
				b.setBookName(rs.getString(2));
				b.setAuthor(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setBookCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
				b.setDescription(rs.getString("description"));
				list.add(b);
				i++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	@Override
	public List<BookDtls> getRecentBooks() {
		List<BookDtls> list = new ArrayList<BookDtls>();
		BookDtls b = null;
		try {
			String sql = "select * from book_dtls where status=? order by bookId DESC";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, "Active");
			ResultSet rs = ps.executeQuery();
			int i = 1;
			while (rs.next() && i <= 4) {
				b = new BookDtls();
				b.setBookId(rs.getInt(1));
				b.setBookName(rs.getString(2));
				b.setAuthor(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setBookCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
				b.setDescription(rs.getString("description"));
				list.add(b);
				i++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public List<BookDtls> getOldBooks() {
		List<BookDtls> list = new ArrayList<BookDtls>();
		BookDtls b = null;

		try {
			String sql = "select * from book_dtls where bookCategory=? and  status=? order by bookId DESC";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, "Old");
			ps.setString(2, "Active");
			ResultSet rs = ps.executeQuery();
			int i = 1;
			while (rs.next() && i <= 4) {
				b = new BookDtls();
				b.setBookId(rs.getInt(1));
				b.setBookName(rs.getString(2));
				b.setAuthor(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setBookCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
				b.setDescription(rs.getString("description"));
				list.add(b);
				i++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	@Override
	public List<BookDtls> AllRecentBooks() {
		List<BookDtls> list = new ArrayList<BookDtls>();
		BookDtls b = null;
		try {
			String sql = "select * from book_dtls where status=? order by bookId DESC";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, "Active");
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				b = new BookDtls();
				b.setBookId(rs.getInt(1));
				b.setBookName(rs.getString(2));
				b.setAuthor(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setBookCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
				b.setDescription(rs.getString("description"));
				list.add(b);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public List<BookDtls> AllNewBooks() {
		List<BookDtls> list = new ArrayList<BookDtls>();
		BookDtls b = null;

		try {
			String sql = "select * from book_dtls where bookCategory=? and  status=? order by bookId DESC";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, "New");
			ps.setString(2, "Active");
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				b = new BookDtls();
				b.setBookId(rs.getInt(1));
				b.setBookName(rs.getString(2));
				b.setAuthor(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setBookCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
				b.setDescription(rs.getString("description"));
				list.add(b);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	@Override
	public List<BookDtls> AllOldBooks() {
		List<BookDtls> list = new ArrayList<BookDtls>();
		BookDtls b = null;

		try {
			String sql = "select * from book_dtls where bookCategory=? and  status=? order by bookId DESC";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, "Old");
			ps.setString(2, "Active");
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				b = new BookDtls();
				b.setBookId(rs.getInt(1));
				b.setBookName(rs.getString(2));
				b.setAuthor(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setBookCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
				b.setDescription(rs.getString("description"));
				list.add(b);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	@Override
	public List<BookDtls> getBookByOld(String email, String cate) {
		List<BookDtls> list = new ArrayList<BookDtls>();
		BookDtls b = null;
		try {
			String sql = "select * from book_dtls where bookCategory=? and userEmail=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, cate);
			ps.setString(2, email);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				b = new BookDtls();
				b.setBookId(rs.getInt(1));
				b.setBookName(rs.getString(2));
				b.setAuthor(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setBookCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
				b.setDescription(rs.getString("description"));
				list.add(b);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	@Override
	public boolean oldBookDelete(String email, String cat, int id) {
		boolean f = false;

		try {
			String sql = "delete from book_dtls where bookCategory=? and userEmail=? and bookId =?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, cat);
			ps.setString(2, email);
			ps.setInt(3, id);

			int i = ps.executeUpdate();
			if (i == 1) {
				f = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return f;
	}

	@Override
	public List<BookDtls> getBookBySearch(
			String ch,
			String sort,
			String category,
			double minPrice,
			double maxPrice,
			int start,
			int limit,
			Integer userId) {

		List<BookDtls> list = new ArrayList<>();

		try {

			String keyword = SearchUtils.normalize(ch);
			System.out.println("RAW: " + ch);
			System.out.println("NORMALIZED: " + keyword);
			if (keyword.isEmpty())
				return list;

			String orderBy = " ORDER BY relevance_score DESC ";
			if ("price_low".equals(sort)) {
				orderBy = " ORDER BY b.price ASC ";
			} else if ("price_high".equals(sort)) {
				orderBy = " ORDER BY b.price DESC ";
			} else if ("rating".equals(sort)) {
				orderBy = " ORDER BY b.avgRating DESC ";
			}

			String sql = "SELECT b.*, " +
					"(" +
					"  (CASE WHEN LOWER(b.bookName) = ? THEN 100 ELSE 0 END) + " +
					"  (CASE WHEN LOWER(b.bookName) LIKE ? THEN 80 ELSE 0 END) + " +
					"  (CASE WHEN LOWER(b.bookName) LIKE ? THEN 60 ELSE 0 END) + " +
					"  (CASE WHEN LOWER(b.author) LIKE ? THEN 40 ELSE 0 END) + " +
					"  (CASE WHEN LOWER(b.bookCategory) LIKE ? THEN 20 ELSE 0 END) + " +
					"  (CASE WHEN SOUNDEX(b.bookName) = SOUNDEX(?) THEN 50 ELSE 0 END) + " +
					"  (MATCH(b.bookName, b.author, b.description) " +
					"   AGAINST (? IN NATURAL LANGUAGE MODE) * 25) + " +
					"  (b.avgRating * 10) + " +
					"  (LOG(IFNULL(bp.views,0)+1) * 5) + " +
					"  (LOG(IFNULL(bp.purchases,0)+1) * 20) + " +

					"  0 ) AS relevance_score " +

					"FROM book_dtls b " +
					"LEFT JOIN book_popularity bp ON b.bookId = bp.book_id " +

					"WHERE b.status='Active' " +
					"AND b.price BETWEEN ? AND ? " +
					(category != null && !category.isEmpty() ? "AND b.bookCategory=? " : "") +
					"AND (" +
					" LOWER(b.bookName) LIKE ? OR " +
					" LOWER(b.author) LIKE ? OR " +
					" LOWER(b.bookCategory) LIKE ? OR " +
					" SOUNDEX(b.bookName)=SOUNDEX(?) OR " +
					" MATCH(b.bookName,b.author,b.description) " +
					"   AGAINST (? IN NATURAL LANGUAGE MODE) " +
					") " +
					orderBy +
					" LIMIT ?, ?";

			PreparedStatement ps = conn.prepareStatement(sql);

			int i = 1;

			ps.setString(i++, keyword);
			ps.setString(i++, keyword + "%");
			ps.setString(i++, "%" + keyword + "%");
			ps.setString(i++, "%" + keyword + "%");
			ps.setString(i++, "%" + keyword + "%");
			ps.setString(i++, keyword);
			ps.setString(i++, keyword);

			ps.setDouble(i++, minPrice);
			ps.setDouble(i++, maxPrice);

			if (category != null && !category.isEmpty()) {
				ps.setString(i++, category);
			}

			ps.setString(i++, "%" + keyword + "%");
			ps.setString(i++, "%" + keyword + "%");
			ps.setString(i++, "%" + keyword + "%");
			ps.setString(i++, keyword);
			ps.setString(i++, keyword);

			ps.setInt(i++, start);
			ps.setInt(i++, limit);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				BookDtls b = new BookDtls();
				b.setBookId(rs.getInt("bookId"));
				b.setBookName(rs.getString("bookName"));
				b.setAuthor(rs.getString("author"));
				b.setPrice(rs.getString("price"));
				b.setBookCategory(rs.getString("bookCategory"));
				b.setPhotoName(rs.getString("photo"));
				b.setDescription(rs.getString("description"));
				list.add(b);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public int getSearchCount(String ch,
			String category,
			double minPrice,
			double maxPrice) {

		int count = 0;

		try {

			String keyword = SearchUtils.normalize(ch);

			String sql = "SELECT COUNT(*) FROM book_dtls b " +
					"WHERE b.status='Active' " +
					"AND b.price BETWEEN ? AND ? " +
					(category != null && !category.isEmpty()
							? "AND b.bookCategory=? "
							: "")
					+
					"AND (" +
					" LOWER(b.bookName) LIKE ? OR " +
					" LOWER(b.author) LIKE ? OR " +
					" LOWER(b.bookCategory) LIKE ? OR " +
					" MATCH(b.bookName,b.author,b.description) " +
					"   AGAINST (? IN NATURAL LANGUAGE MODE)" +
					")";

			PreparedStatement ps = conn.prepareStatement(sql);

			int i = 1;
			ps.setDouble(i++, minPrice);
			ps.setDouble(i++, maxPrice);

			if (category != null && !category.isEmpty()) {
				ps.setString(i++, category);
			}

			ps.setString(i++, "%" + keyword + "%");
			ps.setString(i++, "%" + keyword + "%");
			ps.setString(i++, "%" + keyword + "%");
			ps.setString(i++, keyword);

			ResultSet rs = ps.executeQuery();
			if (rs.next())
				count = rs.getInt(1);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return count;
	}

	// ====================smartrecommendation================
	public List<BookDtls> getSmartRecommendations(int currentBookId, String category) {

		List<BookDtls> list = new ArrayList<>();

		try {

			String sql = "SELECT b.* " +
					"FROM book_dtls b " +
					"LEFT JOIN book_popularity p ON b.bookId = p.book_id " +
					"WHERE b.bookCategory=? AND b.bookId<>? " +
					"ORDER BY IFNULL(p.views,0) DESC " +
					"LIMIT 4";

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, category);
			ps.setInt(2, currentBookId);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				BookDtls b = new BookDtls();
				b.setBookId(rs.getInt("bookId"));
				b.setBookName(rs.getString("bookName"));
				b.setAuthor(rs.getString("author"));
				b.setPrice(rs.getString("price"));
				b.setBookCategory(rs.getString("bookCategory"));
				b.setPhotoName(rs.getString("photo"));
				b.setStatus(rs.getString("status"));
				b.setDescription(rs.getString("description"));

				list.add(b);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}
	// =======================================================logbook=========

	public void logBookView(Integer userId, int bookId) {

		try {

			// 1) Log user activity
			String q1 = "INSERT INTO user_activity(user_id, book_id, action) VALUES(?,?,?)";

			PreparedStatement ps1 = conn.prepareStatement(q1);
			ps1.setInt(1, userId);
			ps1.setInt(2, bookId);
			ps1.setString(3, "VIEW");
			ps1.executeUpdate();

			// 2) Increase popularity
			String q2 = "INSERT INTO book_popularity(book_id, views) VALUES(?,1) " +
					"ON DUPLICATE KEY UPDATE views = views + 1";

			PreparedStatement ps2 = conn.prepareStatement(q2);
			ps2.setInt(1, bookId);
			ps2.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public int getStockByBookId(int bid) {

		int stock = 0;

		try {
			String sql = "SELECT stock FROM book_dtls WHERE bookId=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, bid);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				stock = rs.getInt("stock");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return stock;
	}

	public boolean reduceStock(int bookId, int qty) {

		boolean f = false;

		try {
			String sql = "UPDATE book_dtls SET stock = stock - ? WHERE bookId=? AND stock >= ?";
			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setInt(1, qty);
			ps.setInt(2, bookId);
			ps.setInt(3, qty);

			f = ps.executeUpdate() == 1;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return f;
	}

	public int countBooks() {
		int count = 0;

		try {
			String sql = "SELECT COUNT(*) FROM book_dtls";
			PreparedStatement ps = conn.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				count = rs.getInt(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return count;
	}

	public int getLastInsertedBookId() {

		int id = 0;

		try {
			String sql = "SELECT MAX(bookId) FROM book_dtls";
			PreparedStatement ps = conn.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				id = rs.getInt(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return id;
	}

	public List<BookDtls> filterBooksByGenres(List<Integer> genreIds) {

		List<BookDtls> list = new ArrayList<>();

		if (genreIds == null || genreIds.isEmpty())
			return list;

		try {

			StringBuilder sql = new StringBuilder(
					"SELECT b.* FROM book_dtls b " +
							"JOIN book_genre bg ON b.bookId = bg.book_id " +
							"WHERE bg.genre_id IN (");

			for (int i = 0; i < genreIds.size(); i++) {
				sql.append("?");
				if (i < genreIds.size() - 1)
					sql.append(",");
			}

			sql.append(") GROUP BY b.bookId HAVING COUNT(DISTINCT bg.genre_id) = ?");

			PreparedStatement ps = conn.prepareStatement(sql.toString());

			int index = 1;
			for (Integer id : genreIds) {
				ps.setInt(index++, id);
			}

			ps.setInt(index, genreIds.size());

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				BookDtls b = new BookDtls();
				b.setBookId(rs.getInt("bookId"));
				b.setBookName(rs.getString("bookName"));
				b.setAuthor(rs.getString("author"));
				b.setPrice(rs.getString("price"));
				b.setPhotoName(rs.getString("photo"));
				b.setStatus(rs.getString("status"));
				b.setBookCategory(rs.getString("bookCategory"));
				b.setDescription(rs.getString("description"));
				b.setStock(rs.getInt("stock"));

				list.add(b);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public List<String> getGenresByBookId(int bookId) {

		List<String> genres = new ArrayList<>();

		try {
			String sql = "SELECT g.name FROM genre g "
					+ "JOIN book_genre bg ON g.id = bg.genre_id "
					+ "WHERE bg.book_id = ?";

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, bookId);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				genres.add(rs.getString("name"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return genres;
	}

	public List<BookDtls> filterBooksAdvanced(
			List<Integer> genreIds,
			String sort,
			String minPrice,
			String maxPrice,
			int limit,
			int offset) {

		List<BookDtls> list = new ArrayList<>();
		double C = getGlobalAverageRating();
		int m = 5;
		StringBuilder sql = new StringBuilder(
				"SELECT b.*, " +
						"IFNULL(AVG(r.rating),0) AS avg_rating, " +
						"COUNT(r.review_id) AS total_reviews, " +

						"((COUNT(r.review_id) / (COUNT(r.review_id) + " + m + ")) * IFNULL(AVG(r.rating),0) + " +
						"(" + m + " / (COUNT(r.review_id) + " + m + ")) * " + C + ") AS weighted_rating " +

						"FROM book_dtls b " +
						"LEFT JOIN book_review r ON b.bookId = r.book_id ");

		// Join genre table only if needed
		if (genreIds != null && !genreIds.isEmpty()) {
			sql.append("JOIN book_genre bg ON b.bookId = bg.book_id ");
		}

		sql.append("WHERE 1=1 ");

		// Genre filter
		if (genreIds != null && !genreIds.isEmpty()) {
			sql.append("AND bg.genre_id IN (");
			for (int i = 0; i < genreIds.size(); i++) {
				sql.append("?");
				if (i < genreIds.size() - 1) {
					sql.append(",");
				}
			}
			sql.append(") ");
		}

		// Price filter
		if (minPrice != null && !minPrice.trim().isEmpty()) {
			sql.append("AND CAST(b.price AS DECIMAL(10,2)) >= ? ");
		}

		if (maxPrice != null && !maxPrice.trim().isEmpty()) {
			sql.append("AND CAST(b.price AS DECIMAL(10,2)) <= ? ");
		}

		// IMPORTANT — GROUP BY before ORDER BY
		sql.append("GROUP BY b.bookId ");

		// Sorting
		if (sort != null) {
			switch (sort) {
				case "price_asc":
					sql.append("ORDER BY CAST(b.price AS DECIMAL(10,2)) ASC ");
					break;

				case "price_desc":
					sql.append("ORDER BY CAST(b.price AS DECIMAL(10,2)) DESC ");
					break;

				case "newest":
					sql.append("ORDER BY b.bookId DESC ");
					break;
				case "rating_asc":
					sql.append("ORDER BY avg_rating ASC ");
					break;

				case "rating_desc":
					sql.append("ORDER BY avg_rating DESC ");
					break;
				case "top_rated":
					sql.append("ORDER BY weighted_rating DESC ");
					break;

			}
		}

		// Pagination
		sql.append("LIMIT ? OFFSET ? ");

		try (Connection con = DBConnect.getConn();
				PreparedStatement ps = con.prepareStatement(sql.toString())) {

			int index = 1;

			if (genreIds != null && !genreIds.isEmpty()) {
				for (Integer id : genreIds) {
					ps.setInt(index++, id);
				}
			}

			if (minPrice != null && !minPrice.trim().isEmpty()) {
				ps.setBigDecimal(index++, new java.math.BigDecimal(minPrice.trim()));
			}

			if (maxPrice != null && !maxPrice.trim().isEmpty()) {
				ps.setBigDecimal(index++, new java.math.BigDecimal(maxPrice.trim()));
			}

			ps.setInt(index++, limit);
			ps.setInt(index++, offset);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				BookDtls b = new BookDtls();
				b.setBookId(rs.getInt("bookId"));
				b.setBookName(rs.getString("bookName"));
				b.setAuthor(rs.getString("author"));
				b.setPrice(rs.getString("price"));
				b.setPhotoName(rs.getString("photo"));
				b.setBookCategory(rs.getString("bookCategory"));

				// NEW FIELDS
				b.setAvgRating(rs.getDouble("avg_rating"));
				b.setTotalReviews(rs.getInt("total_reviews"));
				b.setWeightedRating(rs.getDouble("weighted_rating"));

				list.add(b);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public int countFilteredBooks(
			List<Integer> genreIds,
			String sort,
			String minPrice,
			String maxPrice) {

		int count = 0;

		StringBuilder sql = new StringBuilder(
				"SELECT COUNT(DISTINCT b.bookId) FROM book_dtls b ");

		if (genreIds != null && !genreIds.isEmpty()) {
			sql.append("JOIN book_genre bg ON b.bookId = bg.book_id ");
		}

		sql.append("WHERE 1=1 ");

		if (genreIds != null && !genreIds.isEmpty()) {
			sql.append("AND bg.genre_id IN (");
			for (int i = 0; i < genreIds.size(); i++) {
				sql.append("?");
				if (i < genreIds.size() - 1) {
					sql.append(",");
				}
			}
			sql.append(") ");
		}

		if (minPrice != null && !minPrice.isEmpty()) {
			sql.append("AND CAST(b.price AS DECIMAL(10,2)) >= ? ");
		}

		if (maxPrice != null && !maxPrice.isEmpty()) {
			sql.append("AND CAST(b.price AS DECIMAL(10,2)) <= ? ");
		}

		try (Connection con = DBConnect.getConn();
				PreparedStatement ps = con.prepareStatement(sql.toString())) {

			int index = 1;

			if (genreIds != null && !genreIds.isEmpty()) {
				for (Integer id : genreIds) {
					ps.setInt(index++, id);
				}
			}

			if (minPrice != null && !minPrice.isEmpty()) {
				ps.setBigDecimal(index++, new java.math.BigDecimal(minPrice));
			}

			if (maxPrice != null && !maxPrice.isEmpty()) {
				ps.setBigDecimal(index++, new java.math.BigDecimal(maxPrice));
			}

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				count = rs.getInt(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return count;
	}

	public int[] getRatingDistribution(int bookId) {

		int[] dist = new int[5]; // index 0 = 1 star, index 4 = 5 star

		try {
			String sql = "SELECT rating, COUNT(*) AS total " +
					"FROM book_review " +
					"WHERE book_id=? " +
					"GROUP BY rating";

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, bookId);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				int rating = rs.getInt("rating");
				int count = rs.getInt("total");

				if (rating >= 1 && rating <= 5) {
					dist[rating - 1] = count;
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return dist;
	}

	public double getGlobalAverageRating() {

		double avg = 0;

		try {
			String sql = "SELECT IFNULL(AVG(rating),0) FROM book_review";
			PreparedStatement ps = conn.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				avg = rs.getDouble(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return avg;
	}

	public List<BookDtls> getTrendingBooks(int limit) {

		List<BookDtls> list = new ArrayList<>();

		try {

			double C = getGlobalAverageRating();
			int m = 5;

			String sql = "SELECT b.*, " +
					"IFNULL(AVG(r.rating),0) AS avg_rating, " +
					"COUNT(r.review_id) AS total_reviews, " +

					"((COUNT(r.review_id) / (COUNT(r.review_id) + " + m + ")) * IFNULL(AVG(r.rating),0) + " +
					"(" + m + " / (COUNT(r.review_id) + " + m + ")) * " + C + ") AS weighted_rating, " +

					"(bp.views * 1 + bp.purchases * 8) AS score " +

					"FROM book_dtls b " +
					"JOIN book_popularity bp ON b.bookId = bp.book_id " +
					"LEFT JOIN book_review r ON b.bookId = r.book_id " +
					"GROUP BY b.bookId " +
					"ORDER BY score DESC " +
					"LIMIT ?";

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, limit);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				BookDtls b = new BookDtls();

				b.setBookId(rs.getInt("bookId"));
				b.setBookName(rs.getString("bookName"));
				b.setAuthor(rs.getString("author"));
				b.setPrice(rs.getString("price"));
				b.setPhotoName(rs.getString("photo"));
				b.setBookCategory(rs.getString("bookCategory"));
				b.setAvgRating(rs.getDouble("avg_rating"));
				b.setTotalReviews(rs.getInt("total_reviews"));
				b.setWeightedRating(rs.getDouble("weighted_rating"));

				list.add(b);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	@Override
	public int getTotalListingsByUser(int userId) {

		int count = 0;

		try {
			String sql = "SELECT COUNT(*) FROM book_dtls WHERE userEmail = (SELECT email FROM user WHERE id=?)";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, userId);

			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				count = rs.getInt(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return count;
	}

	public int getBooksSoldByUser(int userId) {

		int count = 0;

		try {

			String sql = "SELECT IFNULL(SUM(oi.quantity),0) AS totalSold " +
					"FROM order_items oi " +
					"JOIN book_dtls b ON oi.book_id = b.bookId " +
					"JOIN book_order bo ON bo.order_id = oi.order_id " +
					"WHERE b.userEmail = (SELECT email FROM user WHERE id=?) " +
					"AND bo.payment_status='PAID'";

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, userId);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				count = rs.getInt("totalSold");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return count;
	}

	public double getTotalEarningsByUser(int userId) {

		double total = 0;

		try {

			String sql = "SELECT IFNULL(SUM(oi.price * oi.quantity),0) AS totalEarnings " +
					"FROM order_items oi " +
					"JOIN book_dtls b ON oi.book_id = b.bookId " +
					"JOIN book_order bo ON bo.order_id = oi.order_id " +
					"WHERE b.userEmail = (SELECT email FROM user WHERE id=?) " +
					"AND bo.payment_status='PAID'";

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, userId);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				total = rs.getDouble("totalEarnings");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return total;
	}

	public List<String[]> getTopSearchKeywords(int limit) {

		List<String[]> list = new ArrayList<>();

		try {

			String sql = "SELECT keyword, COUNT(*) as total " +
					"FROM search_analytics " +
					"GROUP BY keyword " +
					"ORDER BY total DESC " +
					"LIMIT ?";

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, limit);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				list.add(new String[] {
						rs.getString("keyword"),
						rs.getString("total")
				});
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public List<String[]> getZeroResultKeywords(int limit) {

		List<String[]> list = new ArrayList<>();

		try {

			String sql = "SELECT keyword, COUNT(*) as total " +
					"FROM search_analytics " +
					"WHERE result_count = 0 " +
					"GROUP BY keyword " +
					"ORDER BY total DESC " +
					"LIMIT ?";

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, limit);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				list.add(new String[] {
						rs.getString("keyword"),
						rs.getString("total")
				});
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public List<BookDtls> getMostViewedBooks(int limit) {

		List<BookDtls> list = new ArrayList<>();

		try {

			String sql = "SELECT b.bookId, b.bookName, b.author, b.price, " +
					"IFNULL(bp.views,0) as views " +
					"FROM book_dtls b " +
					"LEFT JOIN book_popularity bp ON b.bookId = bp.book_id " +
					"ORDER BY views DESC " +
					"LIMIT ?";

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, limit);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				BookDtls b = new BookDtls();

				b.setBookId(rs.getInt("bookId"));
				b.setBookName(rs.getString("bookName"));
				b.setAuthor(rs.getString("author"));
				b.setPrice(rs.getString("price"));
				b.setViews(rs.getInt("views"));

				list.add(b);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public List<BookDtls> getMostPurchasedBooks(int limit) {

		List<BookDtls> list = new ArrayList<>();

		try {

			String sql = "SELECT b.bookId, b.bookName, b.author, b.price, " +
					"IFNULL(bp.purchases,0) as purchases " +
					"FROM book_dtls b " +
					"LEFT JOIN book_popularity bp ON b.bookId = bp.book_id " +
					"ORDER BY purchases DESC " +
					"LIMIT ?";

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, limit);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				BookDtls b = new BookDtls();
				b.setBookId(rs.getInt("bookId"));
				b.setBookName(rs.getString("bookName"));
				b.setAuthor(rs.getString("author"));
				b.setPrice(rs.getString("price"));

				// CORRECT FIELD
				b.setPurchases(rs.getInt("purchases"));

				list.add(b);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

}