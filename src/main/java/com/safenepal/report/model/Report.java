package com.safenepal.report.model;

import java.sql.Timestamp;

// Model class representing the reports table
public class Report {

    private int id;
    private int  userId;
    private String disasterType;
    private String location;
    private String description;
    private String status;         // Pending / Approved / Rejected
    private Timestamp createdAt;
    private String reporterName;   // Joined from users table for display

    // Default constructor
    public Report() {}

    // Constructor for creating new report
    public Report(int userId, String disasterType, String location, String description) {
        this.userId = userId;
        this.disasterType = disasterType;
        this.location = location;
        this.description = description;
        this.status = "Pending";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getDisasterType() {
        return disasterType;
    }

    public void setDisasterType(String disasterType) {
        this.disasterType = disasterType;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getReporterName() {
        return reporterName;
    }

    public void setReporterName(String reporterName) {
        this.reporterName = reporterName;
    }
}