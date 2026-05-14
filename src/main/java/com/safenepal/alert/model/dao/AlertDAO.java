package com.safenepal.alert.model.dao;

import com.safenepal.alert.model.Alert;
import com.safenepal.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

// DAO class for all database operations related to alerts table
public class AlertDAO {

    // Insert a new alert (created by admin)
    public boolean insertAlert(Alert alert) throws SQLException {
        String query = "INSERT INTO alerts (admin_id, location_id, message, severity, alert_type, expiry_time) VALUES (?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, alert.getAdminId());
            st.setInt(2, alert.getLocationId());
            st.setString(3, alert.getMessage());
            st.setString(4, alert.getSeverity());
            st.setString(5, alert.getAlertType());
            st.setTimestamp(6, alert.getExpiryTime());

            return st.executeUpdate() > 0;
        }
    }

    // Fetch all alerts — joined with admin name
    public List<Alert> getAllAlerts() throws SQLException {
        String query = "SELECT a.*, u.full_name AS admin_name, l.location_name " +
                "FROM alerts a " +
                "JOIN users u ON a.admin_id = u.user_id " +
                "JOIN locations l ON a.location_id = l.location_id " +
                "ORDER BY a.created_at DESC";
        List<Alert> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query);
             ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    /**
     * Search alerts by type, message, or location fields.
     */
    public List<Alert> searchAlerts(String keyword) throws SQLException {
        if (keyword == null || keyword.isBlank()) {
            return new ArrayList<>();
        }
        String term = "%" + keyword.toLowerCase(Locale.ROOT).trim() + "%";
        String query = "SELECT a.*, u.full_name AS admin_name, l.location_name " +
                "FROM alerts a " +
                "JOIN users u ON a.admin_id = u.user_id " +
                "JOIN locations l ON a.location_id = l.location_id " +
                "WHERE (" +
                "LOWER(IFNULL(a.alert_type,'')) LIKE ? OR LOWER(IFNULL(a.message,'')) LIKE ? OR " +
                "LOWER(l.location_name) LIKE ? OR LOWER(IFNULL(l.district,'')) LIKE ? OR " +
                "LOWER(IFNULL(l.province,'')) LIKE ?) " +
                "ORDER BY a.created_at DESC";
        List<Alert> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            for (int i = 1; i <= 5; i++) {
                st.setString(i, term);
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    // Delete an alert by ID
    public boolean deleteAlert(int alertId) throws SQLException {
        String query = "DELETE FROM alerts WHERE alert_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, alertId);
            return st.executeUpdate() > 0;
        }
    }

    // Count total alerts — used for dashboard stats
    public int countAlerts() throws SQLException {
        String query = "SELECT COUNT(*) FROM alerts";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query);
             ResultSet rs = st.executeQuery()) {

            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // Helper method: map a ResultSet row to an Alert object
    private Alert mapRow(ResultSet rs) throws SQLException {
        Alert a = new Alert();
        a.setAlertId(rs.getInt("alert_id"));
        a.setAdminId(rs.getInt("admin_id"));
        a.setLocationId(rs.getInt("location_id"));
        a.setMessage(rs.getString("message"));
        a.setSeverity(rs.getString("severity"));
        a.setAlertType(rs.getString("alert_type"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        a.setExpiryTime(rs.getTimestamp("expiry_time"));
        try { a.setLocationName(rs.getString("location_name")); } catch (Exception ignored) {}
        try { a.setAdminName(rs.getString("admin_name")); } catch (Exception ignored) {}
        return a;
    }
}