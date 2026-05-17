package com.safenepal.report.controller;

import com.safenepal.location.model.Location;
import com.safenepal.location.model.dao.LocationDAO;
import com.safenepal.notification.service.NotificationService;
import com.safenepal.report.model.Report;
import com.safenepal.report.model.dao.ReportDAO;
import com.safenepal.reportImage.model.ReportImage;
import com.safenepal.reportImage.model.dao.ReportImageDAO;
import com.safenepal.utils.SessionUtils;
import com.safenepal.utils.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

@WebServlet("/user/report")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB — buffer before writing to disk
    maxFileSize       = 50 * 1024 * 1024, // 50 MB max per file (for videos)
    maxRequestSize    = 150 * 1024 * 1024 // 150 MB max total request
)
public class ReportServlet extends HttpServlet {

    // Only these extensions are allowed for uploads
    private static final Set<String> ALLOWED_TYPES = new HashSet<>(
        Arrays.asList("image/jpeg", "image/jpg", "image/png", "video/mp4", "video/quicktime", "video/x-msvideo")
    );

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!SessionUtils.isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/register?error=Please register to submit a report.");
            return;
        }

        try {
            // Fetch list of locations for the dropdown
            List<Location> locations = new LocationDAO().getAllLocations();
            req.setAttribute("locations", locations);
        } catch (Exception e) {
            req.setAttribute("error", "Could not load locations: " + e.getMessage());
        }

        req.getRequestDispatcher("/pages/user/reportForm.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!SessionUtils.isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int    userId = SessionUtils.getUserId(req);
        String type   = req.getParameter("disasterType");
        String locStr = req.getParameter("locationId");
        String desc   = req.getParameter("description");

        // Validate required text fields
        if (ValidationUtil.isEmpty(type) || ValidationUtil.isEmpty(locStr) || desc == null || desc.length() < 10) {
            req.setAttribute("error", "Please fill all fields correctly.");
            doGet(req, resp); // Refresh form with locations
            return;
        }

        try {
            int locationId = Integer.parseInt(locStr);
            // 1. Insert the report and get the generated ID
            ReportDAO reportDAO = new ReportDAO();
            int reportId = reportDAO.insertReport(new Report(userId, type, locationId, desc));

            if (reportId == -1) {
                req.setAttribute("error", "Report submission failed. Please try again.");
                req.getRequestDispatcher("/pages/user/reportForm.jsp").forward(req, resp);
                return;
            }

            // 2. Process uploaded image files (optional — skip if none uploaded)
            Collection<Part> parts = req.getParts();
            ReportImageDAO imageDAO = new ReportImageDAO();

            // Determine the upload directory path (absolute path to webapp/uploads/)
            String uploadDir = getServletContext().getRealPath("/uploads");
            File uploadFolder = new File(uploadDir);
            if (!uploadFolder.exists()) {
                uploadFolder.mkdirs(); // Create directory if it doesn't exist
            }

            int imageCount = 0;
            for (Part part : parts) {
                // Skip non-file fields and empty uploads
                if (!"images".equals(part.getName())) continue;
                if (part.getSize() == 0 || part.getSubmittedFileName() == null
                        || part.getSubmittedFileName().isEmpty()) continue;

                // Limit to 3 images per report
                if (imageCount >= 3) break;

                // Validate file type
                String contentType = part.getContentType();
                if (!ALLOWED_TYPES.contains(contentType)) {
                    req.setAttribute("error", "Only JPG, PNG images and MP4, MOV, AVI videos are allowed.");
                    req.getRequestDispatcher("/pages/user/reportForm.jsp").forward(req, resp);
                    return;
                }

                // Validate file size (50 MB)
                if (part.getSize() > 50 * 1024 * 1024) {
                    req.setAttribute("error", "Each file must be under 50 MB.");
                    req.getRequestDispatcher("/pages/user/reportForm.jsp").forward(req, resp);
                    return;
                }

                // Generate a unique file name to avoid conflicts
                String originalName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String extension    = originalName.substring(originalName.lastIndexOf('.'));
                String uniqueName   = "report_" + reportId + "_" + System.currentTimeMillis() + "_" + imageCount + extension;
                String filePath     = uploadDir + File.separator + uniqueName;

                // Write the file to disk
                try (InputStream in = part.getInputStream()) {
                    Files.copy(in, new File(filePath).toPath());
                }

                // Save the relative path in the database
                String dbPath = "uploads/" + uniqueName;
                imageDAO.insertImage(new ReportImage(reportId, dbPath));
                imageCount++;
            }

            resp.sendRedirect(req.getContextPath() + "/user/dashboard?success=Report submitted successfully!");

            // Send in-app + email notification confirming submission
            NotificationService.notifyReportSubmitted(userId, type);

        } catch (Exception e) {
            req.setAttribute("error", "Error submitting report: " + e.getMessage());
            req.getRequestDispatcher("/pages/user/reportForm.jsp").forward(req, resp);
        }
    }
}