package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import org.mindrot.jbcrypt.BCrypt;
import com.entity.User;
import com.util.PasswordHash;

public class UserDAOImpl implements UserDAO {

	private Connection conn;

	public UserDAOImpl(Connection conn) {
		this.conn = conn;

		if (conn == null) {
			System.out.println("Database connection failed.");
		}
	}

	@Override
	public boolean userRegister(User us) {
		boolean f = false;
		try {
			String sql = "insert into user(name,email,phno,password) values(?,?,?,?)";
			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setString(1, us.getName());
			ps.setString(2, us.getEmail());
			ps.setString(3, us.getPhno());
			ps.setString(4, us.getPassword());

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
	public User login(String email, String inputPassword) {

		User us = null;

		try {
			String sql = "SELECT * FROM user WHERE email=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, email);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {

				String hashedPassword = rs.getString("password");

				// THIS is where BCrypt.checkpw() belongs
				if (BCrypt.checkpw(inputPassword, hashedPassword)) {

					us = new User();
					us.setId(rs.getInt("id"));
					us.setName(rs.getString("name"));
					us.setEmail(rs.getString("email"));
					us.setPassword(hashedPassword);
					us.setPhno(rs.getString("phno"));
					us.setAddress(rs.getString("address"));
					us.setLandmark(rs.getString("landmark"));
					us.setCity(rs.getString("city"));
					us.setState(rs.getString("state"));
					us.setPincode(rs.getString("pincode"));
					us.setWallet(rs.getDouble("wallet"));

				} else {
					// password mismatch → return null
					return null;
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return us;
	}

	public boolean checkPassword(int userId, String plainPassword) {

		boolean match = false;

		try {
			String sql = "SELECT password FROM user WHERE id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, userId);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				String hashedPasswordFromDB = rs.getString("password");

				match = PasswordHash.checkPassword(plainPassword, hashedPasswordFromDB);

			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return match;
	}

	@Override
	public boolean updateProfile(User u) {

		boolean f = false;
		try {
			String sql = "update user set name=?,email=?,phno=? where id=?";
			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setString(1, u.getName());
			ps.setString(2, u.getEmail());
			ps.setString(3, u.getPhno());
			ps.setInt(4, u.getId());

			int i = ps.executeUpdate();
			if (i == 1) {
				f = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return f;
	}

	public boolean updatePassword(String email, String password) {

		boolean f = false;

		try {
			String sql = "update user set password=? where email=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, password);
			ps.setString(2, email);

			int i = ps.executeUpdate();
			if (i == 1) {
				f = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return f;
	}

	public boolean isEmailExists(String email) {
		boolean exists = false;

		try {
			String sql = "SELECT id FROM user WHERE email=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, email);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				exists = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return exists;
	}

	public boolean addToWallet(int userId, double amount) {

		boolean f = false;

		try {
			String sql = "UPDATE user SET wallet=wallet+? WHERE id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setDouble(1, amount);
			ps.setInt(2, userId);
			f = ps.executeUpdate() == 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return f;
	}

	public User getUserByEmail(String email) {

		User u = null;

		try {

			String sql = "SELECT * FROM user WHERE email=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, email);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				u = new User();
				u.setId(rs.getInt("id"));
				u.setName(rs.getString("name"));
				u.setEmail(rs.getString("email"));
				u.setPassword(rs.getString("password"));
				u.setAccountStatus(rs.getString("account_status"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return u;
	}

	public double getWalletBalance(int userId) {

		double balance = 0;

		try {
			String sql = "SELECT wallet FROM user WHERE id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, userId);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				balance = rs.getDouble("wallet");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return balance;
	}

}