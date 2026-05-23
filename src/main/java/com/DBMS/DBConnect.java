package com.DBMS;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnect {

    private static final String url = "jdbc:mysql://localhost:3306/ebook?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "063105";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static Connection getConn() {
        try {
            return DriverManager.getConnection(url, USER, PASS);
        } catch (Exception e) {
            throw new RuntimeException("Database connection failed", e);
        }
    }
}
