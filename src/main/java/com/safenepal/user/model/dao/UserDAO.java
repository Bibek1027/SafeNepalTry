package com.safenepal.user.model.dao;

import com.safenepal.user.model.User;
import com.safenepal.utils.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    public boolean insertUser(String name, String email, String phone,
                              String password, String role)
            throws SQLException {
        String query = "INSERT INTO users (name, email, phone, password, role) " +
                "VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, password); // ← fixed index
            ps.setString(5, role);     // ← fixed index

            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;
        }
    }

    public User loginUser(String email, String password)
            throws SQLException {
        String query = "SELECT * FROM users WHERE email = ?"; // ← fixed table name
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHashedPassword = rs.getString("password");
                if (BCrypt.checkpw(password, storedHashedPassword)) {
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String phone = rs.getString("phone");
                    String role = rs.getString("role");

                    return new User(id,name,email,phone,password,role);
                }
            }
        }
        return null;
    }
}