package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.entity.Genre;

public class GenreDAOImpl implements GenreDAO {

    private Connection conn; // THIS WAS MISSING

    // Constructor
    public GenreDAOImpl(Connection conn) {
        this.conn = conn;
    }

    public boolean addGenre(Genre g) {

        boolean f = false;

        try {
            String sql = "INSERT INTO genre(name, slug, description, is_active, is_featured, display_order) VALUES(?,?,?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, g.getName());
            ps.setString(2, g.getSlug());
            ps.setString(3, g.getDescription());
            ps.setBoolean(4, g.isActive());
            ps.setBoolean(5, g.isFeatured());
            ps.setInt(6, g.getDisplayOrder());

            int i = ps.executeUpdate();

            if (i == 1) {
                f = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return f;
    }

    public List<Genre> getAllGenres() {

        List<Genre> list = new ArrayList<>();

        try {
            String sql = "SELECT g.*, COUNT(bg.book_id) AS total_books " +
                    "FROM genre g " +
                    "LEFT JOIN book_genre bg ON g.id = bg.genre_id " +
                    "GROUP BY g.id " +
                    "ORDER BY g.display_order ASC";

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Genre g = new Genre();
                g.setId(rs.getInt("id"));
                g.setName(rs.getString("name"));
                g.setSlug(rs.getString("slug"));
                g.setDescription(rs.getString("description"));
                g.setActive(rs.getBoolean("is_active"));
                g.setFeatured(rs.getBoolean("is_featured"));
                g.setDisplayOrder(rs.getInt("display_order"));
                g.setTotalBooks(rs.getInt("total_books"));

                list.add(g);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public boolean toggleGenreStatus(int id) {

        boolean f = false;

        try {
            String sql = "UPDATE genre SET is_active = NOT is_active WHERE id=?";
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
    public Genre getGenreById(int id) {

        Genre g = null;

        try {
            String sql = "SELECT * FROM genre WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                g = new Genre();
                g.setId(rs.getInt("id"));
                g.setName(rs.getString("name"));
                g.setSlug(rs.getString("slug"));
                g.setDescription(rs.getString("description"));
                g.setActive(rs.getBoolean("is_active"));
                g.setFeatured(rs.getBoolean("is_featured"));
                g.setDisplayOrder(rs.getInt("display_order"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return g;
    }

    @Override
    public boolean updateGenre(Genre g) {

        boolean f = false;

        try {
            String sql = "UPDATE genre SET name=?, slug=?, description=?, " +
                    "is_active=?, is_featured=?, display_order=? WHERE id=?";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, g.getName());
            ps.setString(2, g.getSlug());
            ps.setString(3, g.getDescription());
            ps.setBoolean(4, g.isActive());
            ps.setBoolean(5, g.isFeatured());
            ps.setInt(6, g.getDisplayOrder());
            ps.setInt(7, g.getId());

            int i = ps.executeUpdate();

            if (i == 1) {
                f = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return f;
    }

    public void addBookGenreMapping(int bookId, int genreId) {

        try {
            String sql = "INSERT INTO book_genre(book_id, genre_id) VALUES(?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, bookId);
            ps.setInt(2, genreId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Integer> getGenreIdsByBookId(int bookId) {

        List<Integer> list = new ArrayList<>();

        try {
            String sql = "SELECT genre_id FROM book_genre WHERE book_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(rs.getInt("genre_id"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void deleteBookGenres(int bookId) {

        try {
            String sql = "DELETE FROM book_genre WHERE book_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Genre> getActiveGenres() {

        List<Genre> list = new ArrayList<>();

        try {
            String sql = "SELECT * FROM genre WHERE is_active=1 ORDER BY display_order ASC";

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Genre g = new Genre();
                g.setId(rs.getInt("id"));
                g.setName(rs.getString("name"));
                g.setSlug(rs.getString("slug"));
                g.setDescription(rs.getString("description"));
                g.setActive(rs.getBoolean("is_active"));
                g.setFeatured(rs.getBoolean("is_featured"));
                g.setDisplayOrder(rs.getInt("display_order"));

                list.add(g);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}
