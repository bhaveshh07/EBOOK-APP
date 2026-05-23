package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.entity.Review;

public class ReviewDAOImpl {

    private Connection conn;

    public ReviewDAOImpl(Connection conn) {
        this.conn = conn;
    }

    // ================= ADD REVIEW =================
    public boolean addReview(Review r) {

        boolean f = false;

        try {
            String sql = "INSERT INTO book_review(book_id,user_id,rating,review_text,image) VALUES(?,?,?,?,?)";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, r.getBookId());
            ps.setInt(2, r.getUserId());
            ps.setInt(3, r.getRating());
            ps.setString(4, r.getReviewText());
            ps.setString(5, r.getImage());

            if (ps.executeUpdate() == 1) {
                f = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return f;
    }

    // ================= CHECK USER REVIEWED =================
    public boolean hasUserReviewed(int bookId, int userId) {
        try {
            String sql = "SELECT * FROM book_review WHERE book_id=? AND user_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ================= AVERAGE RATING =================
    public double getAverageRating(int bookId) {
        try {
            String sql = "SELECT AVG(rating) FROM book_review WHERE book_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ================= PAGINATION =================
    public List<Review> getReviewPage(int bid, int start) {

        List<Review> list = new ArrayList<>();

        try {

            String sql = "SELECT r.*, u.name " +
                    "FROM book_review r " +
                    "JOIN user u ON r.user_id=u.id " +
                    "WHERE book_id=? " +
                    "ORDER BY review_id DESC LIMIT ?,5";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, bid); // FIRST ?
            ps.setInt(2, start); // SECOND ?

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Review r = new Review();
                r.setReviewId(rs.getInt("review_id"));
                r.setRating(rs.getInt("rating"));
                r.setReviewText(rs.getString("review_text"));
                r.setUserName(rs.getString("name"));

                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= Updation =================
    public boolean updateReviewFull(int rid,
            String text,
            int rating,
            String image) {

        boolean f = false;

        try {

            String sql;

            if (image != null) {
                sql = "UPDATE book_review SET review_text=?, rating=?, image=? WHERE review_id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, text);
                ps.setInt(2, rating);
                ps.setString(3, image);
                ps.setInt(4, rid);
                f = ps.executeUpdate() == 1;
            } else {
                sql = "UPDATE book_review SET review_text=?, rating=? WHERE review_id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, text);
                ps.setInt(2, rating);
                ps.setInt(3, rid);
                f = ps.executeUpdate() == 1;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return f;
    }

    // ================= DELETE =================
    public boolean deleteReview(int id) {
        try {
            String sql = "DELETE FROM book_review WHERE review_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int addHelpful(int rid) {

        int count = 0;

        try {
            String sql = "UPDATE book_review SET helpful = helpful + 1 WHERE review_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, rid);
            ps.executeUpdate();

            String q = "SELECT helpful FROM book_review WHERE review_id=?";
            PreparedStatement ps2 = conn.prepareStatement(q);
            ps2.setInt(1, rid);
            ResultSet rs = ps2.executeQuery();

            if (rs.next()) {
                count = rs.getInt("helpful");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    public List<Review> getReviewsSortedPaged(int bid, String sort, int start, int limit) {

        String sql = "";

        if ("high".equals(sort)) {
            sql = "SELECT r.*,u.name FROM book_review r JOIN user u ON r.user_id=u.id WHERE book_id=? ORDER BY rating DESC LIMIT ?,?";
        } else if ("low".equals(sort)) {
            sql = "SELECT r.*,u.name FROM book_review r JOIN user u ON r.user_id=u.id WHERE book_id=? ORDER BY rating ASC LIMIT ?,?";
        } else if ("helpful".equals(sort)) {
            sql = "SELECT r.*,u.name FROM book_review r JOIN user u ON r.user_id=u.id WHERE book_id=? ORDER BY helpful DESC LIMIT ?,?";
        } else {
            sql = "SELECT r.*,u.name FROM book_review r JOIN user u ON r.user_id=u.id WHERE book_id=? ORDER BY review_id DESC LIMIT ?,?";
        }

        List<Review> list = new ArrayList<>();

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bid);
            ps.setInt(2, start);
            ps.setInt(3, limit);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Review r = new Review();
                r.setReviewId(rs.getInt("review_id"));
                r.setRating(rs.getInt("rating"));
                r.setReviewText(rs.getString("review_text"));
                r.setUserName(rs.getString("name"));
                r.setHelpfulCount(rs.getInt("helpful"));
                r.setImage(rs.getString("image"));
                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countReviews(int bid) {

        int count = 0;

        try {
            String sql = "SELECT COUNT(*) FROM book_review WHERE book_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bid);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

   
    public boolean insertHelpfulUser(int rid, int uid) {

        boolean inserted = false;

        try {
            String sql = "INSERT IGNORE INTO review_helpful(review_id, user_id) VALUES(?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, rid);
            ps.setInt(2, uid);

            int rows = ps.executeUpdate();
            inserted = rows > 0; // true only if actually inserted

        } catch (Exception e) {
            e.printStackTrace();
        }

        return inserted;
    }

    public void incrementHelpful(int rid) {

        try {
            String sql = "UPDATE book_review SET helpful = helpful + 1 WHERE review_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, rid);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int getHelpfulCount(int rid) {

        int count = 0;

        try {
            String sql = "SELECT helpful FROM book_review WHERE review_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, rid);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt("helpful");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    public String getReviewImageById(int reviewId) {

        String img = null;

        try {
            String sql = "SELECT image FROM book_review WHERE review_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, reviewId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                img = rs.getString("image");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return img;
    }

    public int[] getRatingDistribution(int bookId) {

        int[] counts = new int[5]; // index 0 = 1⭐, 4 = 5⭐

        try {
            String sql = "SELECT rating, COUNT(*) as total " +
                    "FROM book_review " +
                    "WHERE book_id=? " +
                    "GROUP BY rating";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int rating = rs.getInt("rating");
                int total = rs.getInt("total");

                if (rating >= 1 && rating <= 5) {
                    counts[rating - 1] = total;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return counts;
    }

    public int getRecentReviewCount(int bookId, int days) {

        int count = 0;

        try {
            String sql = "SELECT COUNT(*) FROM book_review " +
                    "WHERE book_id=? " +
                    "AND review_date >= NOW() - INTERVAL ? DAY";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookId);
            ps.setInt(2, days);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

}