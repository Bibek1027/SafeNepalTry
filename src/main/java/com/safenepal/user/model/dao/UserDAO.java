package com.safenepal.user.model.dao;

import com.safenepal.user.model.User;
import com.safenepal.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// DAO class for all database operations related to users table
public class UserDAO {

    // Insert a new user — auto-approved so they can log in immediately
    public boolean insertUser(User user) throws SQLException {
        String query = "INSERT INTO users (full_name, email, phone, password, role, is_approved) VALUES (?,?,?,?,?,1)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setString(1, user.getFullName());
            st.setString(2, user.getEmail());
            st.setString(3, user.getPhone());
            st.setString(4, user.getPassword());
            st.setString(5, user.getRole());

            int rowsInserted = st.executeUpdate();
            return rowsInserted > 0;
        }
    }

    // Find user by email — used for login
    public User getUserByEmail(String email) throws SQLException {
        String query = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setString(1, email);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
        }
        return null;
    }

    // Find user by phone — used for duplicate check during registration
    public User getUserByPhone(String phone) throws SQLException {
        String query = "SELECT * FROM users WHERE phone = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setString(1, phone);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
        }
        return null;
    }

    // Get all regular users (for admin management page)
    public List<User> getAllUsers() throws SQLException {
        String query = "SELECT * FROM users WHERE role = 'user' ORDER BY created_at DESC";
        List<User> users = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query);
             ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                users.add(mapRow(rs));
            }
        }
        return users;
    }

    // Approve or suspend a user account
    public boolean updateApproval(int userId, int status) throws SQLException {
        String query = "UPDATE users SET is_approved = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, status);
            st.setInt(2, userId);
            return st.executeUpdate() > 0;
        }
    }

    // Delete a user by ID
    public boolean deleteUser(int userId) throws SQLException {
        String query = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, userId);
            return st.executeUpdate() > 0;
        }
    }

    // Count users pending approval (for admin dashboard stats)
    public int countPendingUsers() throws SQLException {
        String query = "SELECT COUNT(*) FROM users WHERE is_approved = 0 AND role = 'user'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query);
             ResultSet rs = st.executeQuery()) {

            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // Count total registered users
    public int countTotalUsers() throws SQLException {
        String query = "SELECT COUNT(*) FROM users WHERE role = 'user'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query);
             ResultSet rs = st.executeQuery()) {

            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // Helper method: map a ResultSet row to a User object
    private User mapRow(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setApproved(rs.getInt("is_approved") == 1);
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}