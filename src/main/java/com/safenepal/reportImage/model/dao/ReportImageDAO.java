package com.safenepal.reportImage.model.dao;

import com.safenepal.reportImage.model.ReportImage;
import com.safenepal.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// DAO class for all database operations related to report_images table
public class ReportImageDAO {

    /**
     * description: Insert a new image record linked to a report
     *
     * @param img
     * @return
     * @throws SQLException
     */
    public boolean insertImage(ReportImage img) throws SQLException {
        String query = "INSERT INTO report_images (report_id, image_path, description) VALUES (?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, img.getReportId());
            st.setString(2, img.getImagePath());
            st.setString(3, img.getDescription());

            return st.executeUpdate() > 0;
        }
    }

    /**
     * description: Fetch all images for a specific report
     *
     * @param reportId
     * @return
     * @throws SQLException
     */
    public List<ReportImage> getImagesByReportId(int reportId) throws SQLException {
        String query = "SELECT * FROM report_images WHERE report_id = ? ORDER BY uploaded_at ASC";
        List<ReportImage> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, reportId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    /**
     * description: Delete all images for a report (called when report is deleted)
     *
     * @param reportId
     * @return
     * @throws SQLException
     */
    public boolean deleteByReportId(int reportId) throws SQLException {
        String query = "DELETE FROM report_images WHERE report_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, reportId);
            return st.executeUpdate() > 0;
        }
    }

    /**
     * description: Helper method: map a ResultSet row to a ReportImage object
     *
     * @param rs
     * @return
     * @throws SQLException
     */
    private ReportImage mapRow(ResultSet rs) throws SQLException {
        ReportImage img = new ReportImage();
        img.setImageId(rs.getInt("image_id"));
        img.setReportId(rs.getInt("report_id"));
        img.setImagePath(rs.getString("image_path"));
        img.setDescription(rs.getString("description"));
        img.setUploadedAt(rs.getTimestamp("uploaded_at"));
        return img;
    }
}
