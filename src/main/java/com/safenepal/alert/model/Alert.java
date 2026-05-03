package com.safenepal.alert.model;

import java.sql.Timestamp;

// Model class representing the alerts table
public class Alert {

    private int id;
    private int adminId;
    private String message;
    private String severity;
    private String location;
    private Timestamp createdAt;
    private String adminName;

    public Alert() {

    }

    public Alert(int adminId, String message, String severity, String location) {
        this.adminId = adminId;
        this.message = message;
        this.severity = severity;
        this.location = location;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getSeverity() {
        return severity;
    }

    public void setSeverity(String severity) {
        this.severity = severity;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }
}