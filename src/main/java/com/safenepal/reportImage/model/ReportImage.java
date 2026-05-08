package com.safenepal.reportImage.model;

import java.sql.Timestamp;

// Model class representing the report_images table
public class ReportImage {

    private int imageId;
    private int reportId;
    private String imagePath;
    private String description;
    private Timestamp uploadedAt;

    // Default constructor
    public ReportImage() {}

    // Constructor for creating new image records
    public ReportImage(int reportId, String imagePath) {
        this.reportId = reportId;
        this.imagePath = imagePath;
    }

    public ReportImage(int reportId, String imagePath, String description) {
        this.reportId = reportId;
        this.imagePath = imagePath;
        this.description = description;
    }

    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Timestamp uploadedAt) {
        this.uploadedAt = uploadedAt;
    }
}
