package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.entity.Contact;

public class ContactDAO {

    private Connection conn;

    public ContactDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Contact> getAllMessages() {

        List<Contact> list = new ArrayList<>();

        try {
            String sql = "SELECT * FROM contact_messages ORDER BY id DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Contact c = new Contact();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setEmail(rs.getString("email"));
                c.setMessage(rs.getString("message"));
                c.setDate(rs.getString("created_at"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
