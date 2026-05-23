package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.entity.WalletTransaction;

public class WalletDAOImpl {

    private Connection conn;

    public WalletDAOImpl(Connection conn) {
        this.conn = conn;
    }

    // ================= GET LEDGER BALANCE =================
    public double getBalanceByUser(int userId) {

        double balance = 0;

        try {

            String sql = "SELECT IFNULL(SUM(" +
                    "CASE " +
                    "WHEN type='CREDIT' THEN amount " +
                    "WHEN type='DEBIT' THEN -amount " +
                    "END),0) AS balance " +
                    "FROM wallet_transactions WHERE user_id=?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                balance = rs.getDouble("balance");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return balance;
    }

    // ================= ADD TRANSACTION =================
    public boolean addTransaction(int userId, double amount,
            String type, String description) {

        boolean success = false;

        try {

            String sql = "INSERT INTO wallet_transactions " +
                    "(user_id, amount, type, description) " +
                    "VALUES (?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setDouble(2, amount);
            ps.setString(3, type);
            ps.setString(4, description);

            success = ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return success;
    }

    // ================= CHECK SUFFICIENT BALANCE =================
    public boolean hasSufficientBalance(int userId, double amount) {

        return getBalanceByUser(userId) >= amount;
    }

    // ================= GET TRANSACTIONS =================
    public List<WalletTransaction> getByUser(int userId) {

        List<WalletTransaction> list = new ArrayList<>();

        try {

            String sql = "SELECT * FROM wallet_transactions " +
                    "WHERE user_id=? ORDER BY id DESC";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                WalletTransaction w = new WalletTransaction();

                w.setId(rs.getInt("id"));
                w.setUserId(rs.getInt("user_id"));
                w.setAmount(rs.getDouble("amount"));
                w.setType(rs.getString("type"));
                w.setDescription(rs.getString("description"));
                w.setCreatedAt(rs.getString("created_at"));

                list.add(w);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
