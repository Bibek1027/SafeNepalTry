package com.safenepal.engagement.model.dao;

import com.safenepal.engagement.model.AlertComment;
import com.safenepal.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AlertCommentDAO {

    public boolean insert(AlertComment comment) throws SQLException {
        String query = "INSERT INTO alert_comments (alert_id, user_id, body) VALUES (?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {
            st.setInt(1, comment.getAlertId());
            st.setInt(2, comment.getUserId());
            st.setString(3, comment.getBody());
            return st.executeUpdate() > 0;
        }
    }

    public List<AlertComment> getByAlertId(int alertId) throws SQLException {
        String query = "SELECT c.*, u.full_name AS user_name FROM alert_comments c " +
                "JOIN users u ON c.user_id = u.user_id " +
                "WHERE c.alert_id = ? ORDER BY c.created_at ASC";
        List<AlertComment> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {
            st.setInt(1, alertId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public int countByAlertId(int alertId) throws SQLException {
        String query = "SELECT COUNT(*) FROM alert_comments WHERE alert_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {
            st.setInt(1, alertId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    private AlertComment mapRow(ResultSet rs) throws SQLException {
        AlertComment c = new AlertComment();
        c.setCommentId(rs.getInt("comment_id"));
        c.setAlertId(rs.getInt("alert_id"));
        c.setUserId(rs.getInt("user_id"));
        c.setBody(rs.getString("body"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        try { c.setUserName(rs.getString("user_name")); } catch (SQLException ignored) {}
        return c;
    }
}
