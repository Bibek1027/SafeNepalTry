package com.safenepal.feedback.model.dao;

import com.safenepal.feedback.model.Feedback;
import com.safenepal.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// DAO class for all database operations related to feedback table
public class FeedbackDAO {

    /**
     * description: Insert a new feedback
     *
     * @param feedback
     * @return
     * @throws SQLException
     */
    public boolean insertFeedback(Feedback feedback) throws SQLException {
        String query = "INSERT INTO feedback (user_id, message, rating) VALUES (?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            st.setInt(1, feedback.getUserId());
            st.setString(2, feedback.getMessage());
            st.setInt(3, feedback.getRating());

            int rowsInserted = st.executeUpdate();
            
            // Set the generated feedback ID
            if (rowsInserted > 0) {
                ResultSet rs = st.getGeneratedKeys();
                if (rs.next()) {
                    feedback.setFeedbackId(rs.getInt(1));
                }
            }
            return rowsInserted > 0;
        }
    }

    /**
     * description: Get all feedback for admin view
     *
     * @return
     * @throws SQLException
     */
    public List<Feedback> getAllFeedback() throws SQLException {
        String query = "SELECT * FROM feedback ORDER BY created_at DESC";
        List<Feedback> feedbackList = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query);
             ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                Feedback feedback = mapRow(rs);
                feedbackList.add(feedback);
                System.out.println("[FeedbackDAO] Found feedback: ID=" + feedback.getFeedbackId() + 
                                 ", Rating=" + feedback.getRating() + ", Message="
                                + feedback.getMessage().substring(0, Math.min(20, feedback.getMessage().length())));
            }
            System.out.println("[FeedbackDAO] Total feedback loaded: " + feedbackList.size());
        } catch (SQLException e) {
            System.err.println("[FeedbackDAO] SQL Error: " + e.getMessage());
            throw e;
        }
        return feedbackList;
    }

    /**
     * description: Get feedback by a specific user
     *
     * @param userId
     * @return
     * @throws SQLException
     */
    public List<Feedback> getFeedbackByUserId(int userId) throws SQLException {
        String query = "SELECT * FROM feedback WHERE user_id = ? ORDER BY created_at DESC";
        List<Feedback> feedbackList = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                feedbackList.add(mapRow(rs));
            }
        }
        return feedbackList;
    }

    /**
     * description: Delete feedback by ID
     *
     * @param feedbackId
     * @return
     * @throws SQLException
     */
    public boolean deleteFeedback(int feedbackId) throws SQLException {
        String query = "DELETE FROM feedback WHERE feedback_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query)) {

            st.setInt(1, feedbackId);
            return st.executeUpdate() > 0;
        }
    }

    /**
     * description:  Get average rating for all feedback
     *
     * @return
     * @throws SQLException
     */
    public double getAverageRating() throws SQLException {
        String query = "SELECT AVG(rating) as avg_rating FROM feedback";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query);
             ResultSet rs = st.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble("avg_rating");
            }
        }
        return 0.0;
    }

    /**
     * description: Get total feedback count
     *
     * @return
     * @throws SQLException
     */
    public int getFeedbackCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM feedback";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query);
             ResultSet rs = st.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * description: Helper method: map a ResultSet row to a Feedback object
     *
     * @param rs
     * @return
     * @throws SQLException
     */
    private Feedback mapRow(ResultSet rs) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setFeedbackId(rs.getInt("feedback_id"));
        feedback.setUserId(rs.getInt("user_id"));
        feedback.setMessage(rs.getString("message"));
        feedback.setRating(rs.getInt("rating"));
        feedback.setCreatedAt(rs.getTimestamp("created_at"));
        return feedback;
    }
}
