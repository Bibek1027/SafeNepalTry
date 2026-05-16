package com.safenepal.engagement.model.dao;

import com.safenepal.utils.DBConnection;

import java.sql.*;

public class AlertLikeDAO {

    public boolean toggleLike(int alertId, int userId) throws SQLException {
        if (hasUserLiked(alertId, userId)) {
            return removeLike(alertId, userId);
        }
        return addLike(alertId, userId);
    }

    public boolean addLike(int alertId, int userId) throws SQLException {
        String query = "INSERT INTO alert_likes (alert_id, user_id) VALUES (?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {
            st.setInt(1, alertId);
            st.setInt(2, userId);
            return st.executeUpdate() > 0;
        }
    }

    public boolean removeLike(int alertId, int userId) throws SQLException {
        String query = "DELETE FROM alert_likes WHERE alert_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {
            st.setInt(1, alertId);
            st.setInt(2, userId);
            return st.executeUpdate() > 0;
        }
    }

    public boolean hasUserLiked(int alertId, int userId) throws SQLException {
        String query = "SELECT 1 FROM alert_likes WHERE alert_id = ? AND user_id = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {
            st.setInt(1, alertId);
            st.setInt(2, userId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        }
    }

    public int countByAlertId(int alertId) throws SQLException {
        String query = "SELECT COUNT(*) FROM alert_likes WHERE alert_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {
            st.setInt(1, alertId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }
}
