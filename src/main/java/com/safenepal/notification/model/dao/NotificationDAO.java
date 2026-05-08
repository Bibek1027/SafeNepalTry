package com.safenepal.notification.model.dao;

import com.safenepal.notification.model.Notification;
import com.safenepal.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// DAO class for all database operations related to notifications table
public class NotificationDAO {

    // Insert a new notification
    public boolean insertNotification(Notification n) throws SQLException {
        String query = "INSERT INTO notifications (user_id, title, message, type, is_read) VALUES (?,?,?,?,0)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, n.getUserId());
            st.setString(2, n.getTitle());
            st.setString(3, n.getMessage());
            st.setString(4, n.getType());

            return st.executeUpdate() > 0;
        }
    }

    // Fetch all notifications for a specific user (newest first)
    public List<Notification> getByUserId(int userId) throws SQLException {
        String query = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC";
        List<Notification> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    // Fetch only the latest 5 unread notifications for navbar dropdown
    public List<Notification> getRecentUnread(int userId) throws SQLException {
        String query = "SELECT * FROM notifications WHERE user_id = ? AND is_read = 0 ORDER BY created_at DESC LIMIT 5";
        List<Notification> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    // Count unread notifications for a specific user (used for badge)
    public int countUnread(int userId) throws SQLException {
        String query = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // Mark a single notification as read
    public boolean markAsRead(int notificationId) throws SQLException {
        String query = "UPDATE notifications SET is_read = 1 WHERE notification_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, notificationId);
            return st.executeUpdate() > 0;
        }
    }

    // Mark all notifications as read for a specific user
    public boolean markAllAsRead(int userId) throws SQLException {
        String query = "UPDATE notifications SET is_read = 1 WHERE user_id = ? AND is_read = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, userId);
            return st.executeUpdate() > 0;
        }
    }

    // Helper method: map a ResultSet row to a Notification object
    private Notification mapRow(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setNotificationId(rs.getInt("notification_id"));
        n.setUserId(rs.getInt("user_id"));
        n.setTitle(rs.getString("title"));
        n.setMessage(rs.getString("message"));
        n.setType(rs.getString("type"));
        n.setRead(rs.getBoolean("is_read"));
        n.setCreatedAt(rs.getTimestamp("created_at"));
        return n;
    }
}
