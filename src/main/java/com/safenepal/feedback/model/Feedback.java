package com.safenepal.feedback.model;

import java.sql.Timestamp;

// Model class representing the feedback table
public class Feedback {

    private int feedbackId;
    private int userId;
    private String message;
    private int rating;
    private Timestamp createdAt;

    // Default constructor
    public Feedback() {}

    // Constructor for creating new feedback
    public Feedback(int userId, String message, int rating) {
        this.userId = userId;
        this.message = message;
        this.rating = rating;
    }

    public int getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
