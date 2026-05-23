package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.entity.Cart;

public class CartDAOImpl implements CartDAO {

	private Connection conn;

	public CartDAOImpl(Connection conn) {
		this.conn = conn;
	}

	public int getBookIdByCartId(int cid) {

		int bid = 0;

		try {
			String sql = "SELECT bid FROM cart WHERE cid=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, cid);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				bid = rs.getInt("bid");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return bid;
	}

	// ---------------- ADD TO CART ----------------
	public boolean addCart(Cart c) {

		boolean f = false;

		try {
			String sql = "insert into cart(bid,uid,bookName,author,price,quantity,totalPrice) values(?,?,?,?,?,?,?)";

			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setInt(1, c.getBid());
			ps.setInt(2, c.getUid());
			ps.setString(3, c.getBookName());
			ps.setString(4, c.getAuthor());
			ps.setDouble(5, c.getPrice());
			ps.setInt(6, c.getQuantity());
			ps.setDouble(7, c.getTotalPrice());

			int i = ps.executeUpdate();
			if (i == 1)
				f = true;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return f;
	}

	// ---------------- GET CART ----------------
	public List<Cart> getBookByUser(int uid) {

		List<Cart> list = new ArrayList<>();

		try {

			String sql = "select * from cart where uid=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, uid);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				Cart c = new Cart();

				c.setCid(rs.getInt("cid"));
				c.setBid(rs.getInt("bid"));
				c.setUid(rs.getInt("uid"));
				c.setBookName(rs.getString("bookName"));
				c.setAuthor(rs.getString("author"));
				c.setPrice(rs.getDouble("price"));
				c.setQuantity(rs.getInt("quantity"));
				c.setTotalPrice(rs.getDouble("totalPrice")); // ✅ row total only

				list.add(c);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public boolean deleteBookByCartId(int cid) {

		boolean f = false;

		try {

			String sql = "DELETE FROM cart WHERE cid=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, cid);

			f = ps.executeUpdate() == 1;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return f;
	}

	public Cart findByUserAndBook(int uid, int bid) {

		Cart c = null;

		try {
			String sql = "select * from cart where uid=? and bid=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, uid);
			ps.setInt(2, bid);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				c = new Cart();
				c.setCid(rs.getInt("cid"));
				c.setQuantity(rs.getInt("quantity"));
				c.setTotalPrice(rs.getDouble("totalPrice"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return c;
	}

	public boolean updateQuantityOnly(int cid, int qty) {

		boolean f = false;

		try {

			String sql = "UPDATE cart SET quantity=?, totalPrice = price * ? WHERE cid=?";
			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setInt(1, qty);
			ps.setInt(2, qty);
			ps.setInt(3, cid);

			if (ps.executeUpdate() == 1) {
				f = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return f;
	}

	public double getGrandTotal(int uid) {

		double total = 0;

		try {
			String sql = "select sum(totalPrice) from cart where uid=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, uid);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				total = rs.getDouble(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return total;
	}

	@Override
	public boolean deleteCart(int userId) {

		boolean f = false;

		try {

			String sql = "delete from cart where uid=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, userId);

			int i = ps.executeUpdate();

			if (i >= 0) {
				f = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return f;
	}

	public boolean clearCartByUser(int userId) {
		boolean success = false;

		try {
			String sql = "DELETE FROM cart WHERE uid=?";

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, userId);

			ps.executeUpdate();
			success = true;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return success;
	}

}
