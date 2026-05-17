package com.safenepal.user.model.dao;

import com.safenepal.user.model.User;
import com.safenepal.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// DAO class for all database operations related to users table
public class UserDAO {

    /**
     * description: Insert a new user — immediately active, no approval needed
     *
     * @param user
     * @return
     * @throws SQLException
     */
    public boolean insertUser(User user) throws SQLException {
        String query = "INSERT INTO users (full_name, email, phone, password, role) VALUES (?,?,?,?,?)";
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

    /**
     *
     * description Find user by email — used for login
     * @param email
     * @return
     * @throws SQLException
     */
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

    /**
     * description: Find user by phone — used for duplicate check during registration
     * @param phone
     * @return
     * @throws SQLException
     */
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

    /**
     * description: Get all regular users (for admin management page)
     * @return
     * @throws SQLException
     */
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

    /**
     * description: Count total registered users
     * @return
     * @throws SQLException
     */
    public int countTotalUsers() throws SQLException {
        String query = "SELECT COUNT(*) FROM users WHERE role = 'user'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query);
             ResultSet rs = st.executeQuery()) {

            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    /**
     * description: Get a single user by their primary key — used by profile page
     * @param id
     * @return
     * @throws SQLException
     */
    public User getUserById(int id) throws SQLException {
        String query = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    /**
     * description: Update name and phone for a user — used by profile update
     * @param id
     * @param fullName
     * @param phone
     * @return
     * @throws SQLException
     */
    public boolean updateProfile(int id, String fullName, String phone) throws SQLException {
        String query = "UPDATE users SET full_name = ?, phone = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setString(1, fullName);
            st.setString(2, phone);
            st.setInt(3, id);
            return st.executeUpdate() > 0;
        }
    }

    /**
     * decription:  Update hashed password for a user — used by change password form
     * @param id
     * @param hashedPassword
     * @return
     * @throws SQLException
     */
    public boolean updatePassword(int id, String hashedPassword) throws SQLException {
        String query = "UPDATE users SET password = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setString(1, hashedPassword);
            st.setInt(2, id);
            return st.executeUpdate() > 0;
        }
    }

    /**
     * description: Update user status (active/suspended) — used by admin panel
     * @param userId
     * @param status
     * @return
     * @throws SQLException
     */
    public boolean updateStatus(int userId, String status) throws SQLException {
        String query = "UPDATE users SET status = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setString(1, status);
            st.setInt(2, userId);
            return st.executeUpdate() > 0;
        }
    }

    /**
     * description: Delete a user by ID — used by admin panel
     * @param userId
     * @return
     * @throws SQLException
     */
    public boolean deleteUser(int userId) throws SQLException {
        String query = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, userId);
            return st.executeUpdate() > 0;
        }
    }

    /**
     * description: Get all active regular user IDs
     * used by NotificationService to broadcast alert notifications
     * @return
     * @throws SQLException
     */
    public List<Integer> getAllActiveUserIds() throws SQLException {
        String query = "SELECT user_id FROM users WHERE role = 'user' AND status = 'active'";
        List<Integer> ids = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query);
             ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                ids.add(rs.getInt("user_id"));
            }
        }
        return ids;
    }

    /**
     * description: Get all active regular users (full objects)
     * — used by NotificationService for email notifications
     * @return
     * @throws SQLException
     */
    public List<User> getAllActiveUsers() throws SQLException {
        String query = "SELECT * FROM users WHERE role = 'user' AND status = 'active'";
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

    /**
     * description: Helper method: map a ResultSet row to a User object
     * @param rs
     * @return
     * @throws SQLException
     */
    private User mapRow(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getString("status"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}