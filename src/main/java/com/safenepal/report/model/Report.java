package com.safenepal.report.model;

import com.safenepal.reportImage.model.ReportImage;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

// Model class representing the reports table
public class Report {

    private int id;
    private int userId;
    private int locationId;
    private String disasterType;
    private String locationName; // Added for convenience in UI display
    private String description;
    private String status;
    private Timestamp reportedAt;
    private String reporterName;
    private List<ReportImage> images = new ArrayList<>();

    public Report() {}

    public Report(int userId, String disasterType, int locationId, String description) {
        this.userId = userId;
        this.disasterType = disasterType;
        this.locationId = locationId;
        this.description = description;
        this.status = "Pending";
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getLocationId() { return locationId; }
    public void setLocationId(int locationId) { this.locationId = locationId; }

    public String getDisasterType() { return disasterType; }
    public void setDisasterType(String disasterType) { this.disasterType = disasterType; }

    public String getLocationName() { return locationName; }
    public void setLocationName(String locationName) { this.locationName = locationName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getReportedAt() { return reportedAt; }
    public void setReportedAt(Timestamp reportedAt) { this.reportedAt = reportedAt; }

    public String getReporterName() { return reporterName; }
    public void setReporterName(String reporterName) { this.reporterName = reporterName; }

    public List<ReportImage> getImages() { return images; }
    public void setImages(List<ReportImage> images) { this.images = images; }
}