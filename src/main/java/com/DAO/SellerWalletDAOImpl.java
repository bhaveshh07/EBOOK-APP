package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.entity.SellerWalletTransaction;

public class SellerWalletDAOImpl {

    private Connection conn;

    public SellerWalletDAOImpl(Connection conn) {
        this.conn = conn;
    }

    // ================= CREDIT =================
    public boolean creditSeller(int sellerId, double amount, String desc) {

        try {
            String sql = "INSERT INTO seller_wallet_transactions "
                    + "(seller_id, amount, type, description) "
                    + "VALUES (?, ?, 'CREDIT', ?)";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, sellerId);
            ps.setDouble(2, amount);
            ps.setString(3, desc);

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= BALANCE =================
    public double getSellerBalance(int sellerId) {

        double balance = 0;

        try {
            String sql = "SELECT IFNULL(SUM(CASE " +
                    "WHEN type='CREDIT' THEN amount " +
                    "WHEN type='DEBIT' THEN -amount END),0) AS bal " +
                    "FROM seller_wallet_transactions WHERE seller_id=?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, sellerId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                balance = rs.getDouble("bal");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return balance;
    }

    // ================= TOTAL EARNINGS =================
    public double getSellerTotalEarnings(int sellerId) {

        double total = 0;

        try {
            String sql = "SELECT IFNULL(SUM(amount),0) FROM seller_wallet_transactions "
                    + "WHERE seller_id=? AND type='CREDIT'";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, sellerId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getDouble(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }

    // ================= BOOKS SOLD =================
    public int getSellerBooksSold(int sellerId) {

        int count = 0;

        try {
            String sql = "SELECT IFNULL(SUM(oi.quantity),0) " +
                    "FROM order_items oi " +
                    "JOIN book_dtls b ON oi.book_id = b.bookId " +
                    "JOIN book_order bo ON bo.order_id = oi.order_id " +
                    "WHERE b.userEmail = (SELECT email FROM user WHERE id=?) " +
                    "AND bo.status='DELIVERED'";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, sellerId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    // ================= TRANSACTIONS =================
    public List<SellerWalletTransaction> getSellerTransactions(int sellerId) {

        List<SellerWalletTransaction> list = new ArrayList<>();

        try {

            String sql = "SELECT * FROM seller_wallet_transactions "
                    + "WHERE seller_id=? ORDER BY id DESC LIMIT 5";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, sellerId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                SellerWalletTransaction t = new SellerWalletTransaction();
                t.setId(rs.getInt("id"));
                t.setSellerId(rs.getInt("seller_id"));
                t.setAmount(rs.getDouble("amount"));
                t.setType(rs.getString("type"));
                t.setDescription(rs.getString("description"));
                t.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(t);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= MONTHLY REVENUE =================
    public List<Double> getMonthlyRevenue(int sellerId) {

        List<Double> list = new ArrayList<>();

        try {

            String sql = "SELECT MONTH(created_at) m, SUM(amount) total " +
                    "FROM seller_wallet_transactions " +
                    "WHERE seller_id=? AND type='CREDIT' " +
                    "GROUP BY MONTH(created_at) ORDER BY m";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, sellerId);

            ResultSet rs = ps.executeQuery();

            double[] monthly = new double[12];

            while (rs.next()) {
                int month = rs.getInt("m");
                monthly[month - 1] = rs.getDouble("total");
            }

            for (double d : monthly) {
                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean debitSeller(int sellerId, double amount, String desc) {

        try {
            String sql = "INSERT INTO seller_wallet_transactions(seller_id, amount, type, description) " +
                    "VALUES (?, ?, 'DEBIT', ?)";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, sellerId);
            ps.setDouble(2, amount);
            ps.setString(3, desc);

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= RETURN COUNT LAST 30 DAYS =================
    public int getSellerReturnCountLast30Days(int sellerId) {

        int count = 0;

        try {

            String sql = "SELECT COUNT(*) " +
                    "FROM book_order bo " +
                    "JOIN book_dtls b ON bo.book_id = b.bookId " +
                    "JOIN user u ON b.userEmail = u.email " +
                    "WHERE u.id=? " +
                    "AND bo.return_status='APPROVED' " +
                    "AND bo.order_date >= NOW() - INTERVAL 30 DAY";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, sellerId);

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
