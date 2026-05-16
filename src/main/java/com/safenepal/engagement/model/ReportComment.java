package com.safenepal.engagement.model;

import java.sql.Timestamp;

public class ReportComment {

    private int commentId;
    private int reportId;
    private int userId;
    private String body;
    private Timestamp createdAt;
    private String userName;

    public ReportComment() {}

    public ReportComment(int reportId, int userId, String body) {
        this.reportId = reportId;
        this.userId = userId;
        this.body = body;
    }

    public int getCommentId() { return commentId; }
    public void setCommentId(int commentId) { this.commentId = commentId; }

    public int getReportId() { return reportId; }
    public void setReportId(int reportId) { this.reportId = reportId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getBody() { return body; }
    public void setBody(String body) { this.body = body; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
}
