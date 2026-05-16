package com.safenepal.engagement.model;

import java.sql.Timestamp;

public class AlertComment {

    private int commentId;
    private int alertId;
    private int userId;
    private String body;
    private Timestamp createdAt;
    private String userName;

    public AlertComment() {}

    public AlertComment(int alertId, int userId, String body) {
        this.alertId = alertId;
        this.userId = userId;
        this.body = body;
    }

    public int getCommentId() { return commentId; }
    public void setCommentId(int commentId) { this.commentId = commentId; }

    public int getAlertId() { return alertId; }
    public void setAlertId(int alertId) { this.alertId = alertId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getBody() { return body; }
    public void setBody(String body) { this.body = body; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
}
