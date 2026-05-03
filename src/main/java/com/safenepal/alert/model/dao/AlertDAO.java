package com.safenepal.alert.model.dao;

import com.safenepal.alert.model.Alert;
import com.safenepal.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// DAO class for all database operations related to alerts table
public class AlertDAO {

    // Insert a new alert (created by admin)
    public boolean insertAlert(Alert alert) throws SQLException {
        String query = "INSERT INTO alerts (admin_id, message, severity, location) VALUES (?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, alert.getAdminId());
            st.setString(2, alert.getMessage());
            st.setString(3, alert.getSeverity());
            st.setString(4, alert.getLocation());

            return st.executeUpdate() > 0;
        }
    }

    // Fetch all alerts — joined with admin name
    public List<Alert> getAllAlerts() throws SQLException {
        String query = "SELECT a.*, u.full_name AS admin_name " +
                "FROM alerts a JOIN users u ON a.admin_id = u.id " +
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

    // Delete an alert by ID
    public boolean deleteAlert(int alertId) throws SQLException {
        String query = "DELETE FROM alerts WHERE id = ?";
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
        a.setId(rs.getInt("id"));
        a.setAdminId(rs.getInt("admin_id"));
        a.setMessage(rs.getString("message"));
        a.setSeverity(rs.getString("severity"));
        a.setLocation(rs.getString("location"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        a.setAdminName(rs.getString("admin_name"));
        return a;
    }
}