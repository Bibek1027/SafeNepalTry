package com.safenepal.engagement.model.dao;

import com.safenepal.utils.DBConnection;

import java.sql.*;

public class ReportLikeDAO {

    public boolean toggleLike(int reportId, int userId) throws SQLException {
        if (hasUserLiked(reportId, userId)) {
            return removeLike(reportId, userId);
        }
        return addLike(reportId, userId);
    }

    public boolean addLike(int reportId, int userId) throws SQLException {
        String query = "INSERT INTO report_likes (report_id, user_id) VALUES (?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {
            st.setInt(1, reportId);
            st.setInt(2, userId);
            return st.executeUpdate() > 0;
        }
    }

    public boolean removeLike(int reportId, int userId) throws SQLException {
        String query = "DELETE FROM report_likes WHERE report_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {
            st.setInt(1, reportId);
            st.setInt(2, userId);
            return st.executeUpdate() > 0;
        }
    }

    public boolean hasUserLiked(int reportId, int userId) throws SQLException {
        String query = "SELECT 1 FROM report_likes WHERE report_id = ? AND user_id = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {
            st.setInt(1, reportId);
            st.setInt(2, userId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        }
    }

    public int countByReportId(int reportId) throws SQLException {
        String query = "SELECT COUNT(*) FROM report_likes WHERE report_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {
            st.setInt(1, reportId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }
}
