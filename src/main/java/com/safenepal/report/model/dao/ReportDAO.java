package com.safenepal.report.model.dao;

import com.safenepal.report.model.Report;
import com.safenepal.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// DAO class for all database operations related to reports table
public class ReportDAO {

    // Insert a new disaster report and return the generated report ID (-1 on failure)
    public int insertReport(Report report) throws SQLException {
        String query = "INSERT INTO reports (user_id, disaster_type, location_id, description) VALUES (?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            st.setInt(1, report.getUserId());
            st.setString(2, report.getDisasterType());
            st.setInt(3, report.getLocationId());
            st.setString(4, report.getDescription());

            int rows = st.executeUpdate();
            if (rows > 0) {
                ResultSet keys = st.getGeneratedKeys();
                if (keys.next()) return keys.getInt(1);
            }
        }
        return -1;
    }

    // Fetch a single report by its ID — used when sending notifications after approve/reject
    public Report getReportById(int reportId) throws SQLException {
        String query = "SELECT r.*, u.full_name AS reporter_name, l.location_name " +
                "FROM reports r " +
                "JOIN users u ON r.user_id = u.user_id " +
                "JOIN locations l ON r.location_id = l.location_id " +
                "WHERE r.report_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, reportId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    // Fetch all reports (admin view) — joined with user full_name
    public List<Report> getAllReports() throws SQLException {
        String query = "SELECT r.*, u.full_name AS reporter_name, l.location_name " +
                "FROM reports r " +
                "JOIN users u ON r.user_id = u.user_id " +
                "JOIN locations l ON r.location_id = l.location_id " +
                "ORDER BY r.reported_at DESC";
        List<Report> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query);
             ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    // Fetch reports submitted by a specific user
    public List<Report> getReportsByUser(int userId) throws SQLException {
        String query = "SELECT r.*, u.full_name AS reporter_name, l.location_name " +
                "FROM reports r " +
                "JOIN users u ON r.user_id = u.user_id " +
                "JOIN locations l ON r.location_id = l.location_id " +
                "WHERE r.user_id = ? ORDER BY r.reported_at DESC";
        List<Report> list = new ArrayList<>();

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

    // Update the status of a report (Approved / Rejected)
    public boolean updateStatus(int reportId, String status) throws SQLException {
        String query = "UPDATE reports SET status = ? WHERE report_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setString(1, status);
            st.setInt(2, reportId);
            return st.executeUpdate() > 0;
        }
    }

    // Delete a report by ID
    public boolean deleteReport(int reportId) throws SQLException {
        String query = "DELETE FROM reports WHERE report_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, reportId);
            return st.executeUpdate() > 0;
        }
    }



    // Count reports by status — used for dashboard stats
    public int countByStatus(String status) throws SQLException {
        String query = "SELECT COUNT(*) FROM reports WHERE status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setString(1, status);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // Count total reports by a specific user
    public int countByUser(int userId) throws SQLException {
        String query = "SELECT COUNT(*) FROM reports WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // Helper method: map a ResultSet row to a Report object
    private Report mapRow(ResultSet rs) throws SQLException {
        Report r = new Report();
        r.setId(rs.getInt("report_id"));
        r.setUserId(rs.getInt("user_id"));
        r.setDisasterType(rs.getString("disaster_type"));
        r.setLocationId(rs.getInt("location_id"));
        r.setDescription(rs.getString("description"));
        r.setStatus(rs.getString("status"));
        r.setReportedAt(rs.getTimestamp("reported_at"));
        try { r.setLocationName(rs.getString("location_name")); } catch (Exception ignored) {}
        try { r.setReporterName(rs.getString("reporter_name")); } catch (Exception ignored) {}
        return r;
    }
}