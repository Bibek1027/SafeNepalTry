package com.safenepal.engagement.model.dao;

import com.safenepal.engagement.model.ReportComment;
import com.safenepal.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReportCommentDAO {
    /**
     *
     * @param comment
     * @return
     * @throws SQLException
     */
    public boolean insert(ReportComment comment) throws SQLException {
        String query = "INSERT INTO report_comments (report_id, user_id, body) VALUES (?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {
            st.setInt(1, comment.getReportId());
            st.setInt(2, comment.getUserId());
            st.setString(3, comment.getBody());
            return st.executeUpdate() > 0;
        }
    }

    public List<ReportComment> getByReportId(int reportId) throws SQLException {
        String query = "SELECT c.*, u.full_name AS user_name FROM report_comments c " +
                "JOIN users u ON c.user_id = u.user_id " +
                "WHERE c.report_id = ? ORDER BY c.created_at ASC";
        List<ReportComment> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {
            st.setInt(1, reportId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public int countByReportId(int reportId) throws SQLException {
        String query = "SELECT COUNT(*) FROM report_comments WHERE report_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {
            st.setInt(1, reportId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public boolean delete(int commentId, int userId) throws SQLException {
        String query = "DELETE FROM report_comments WHERE comment_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {
            st.setInt(1, commentId);
            st.setInt(2, userId);
            return st.executeUpdate() > 0;
        }
    }

    private ReportComment mapRow(ResultSet rs) throws SQLException {
        ReportComment c = new ReportComment();
        c.setCommentId(rs.getInt("comment_id"));
        c.setReportId(rs.getInt("report_id"));
        c.setUserId(rs.getInt("user_id"));
        c.setBody(rs.getString("body"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        try { c.setUserName(rs.getString("user_name")); } catch (SQLException ignored) {}
        return c;
    }
}
