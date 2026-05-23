package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

import com.entity.LoginAttempt;

public class LoginAttemptDAOImpl implements LoginAttemptDAO {

    private Connection conn;

    public LoginAttemptDAOImpl(Connection conn) {
        this.conn = conn;
    }

    // Get record by user id
    @Override
    public LoginAttempt getByUserId(int userId) {

        LoginAttempt la = null;

        try {

            String sql =
                "SELECT * FROM login_attempts WHERE user_id=?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                la = new LoginAttempt();
                la.setUserId(rs.getInt("user_id"));
                la.setAttemptCount(rs.getInt("attempt_count"));
                la.setLockUntil(rs.getTimestamp("lock_until"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return la;
    }

    // Create row if missing
    @Override
    public void createIfNotExists(int userId) {

        try {

            String sql =
              "INSERT IGNORE INTO login_attempts(user_id,attempt_count,lock_until) " +
              "VALUES (?,0,NULL)";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Increase failed attempt
    @Override
    public void increaseAttempt(int userId) {

        try {

            String sql =
              "UPDATE login_attempts " +
              "SET attempt_count = attempt_count + 1 " +
              "WHERE user_id=?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Reset after success
    @Override
    public void resetAttempts(int userId) {

        try {

            String sql =
              "UPDATE login_attempts " +
              "SET attempt_count=0, lock_until=NULL " +
              "WHERE user_id=?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Check if locked
    @Override
    public boolean isAccountLocked(int userId) {

        boolean locked = false;

        try {

            String sql =
              "SELECT lock_until FROM login_attempts WHERE user_id=?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Timestamp lockUntil = rs.getTimestamp("lock_until");

                if (lockUntil != null &&
                    lockUntil.after(new Timestamp(System.currentTimeMillis()))) {

                    locked = true;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return locked;
    }
}
