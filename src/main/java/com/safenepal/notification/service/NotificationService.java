package com.safenepal.notification.service;

import com.safenepal.notification.model.Notification;
import com.safenepal.notification.model.dao.NotificationDAO;
import com.safenepal.user.model.dao.UserDAO;

import java.sql.SQLException;
import java.util.List;

// Service class that creates notifications automatically based on admin actions
public class NotificationService {

    private static final NotificationDAO notifDAO = new NotificationDAO();

    /**
     * Called when admin APPROVES a user's disaster report.
     * Sends a notification to the report owner.
     */
    public static void notifyReportApproved(int userId, String disasterType) {
        String title   = "✅ Report Approved";
        String message = "Your " + disasterType + " disaster report has been reviewed and approved by the admin.";
        sendToUser(userId, title, message, "report_approved");
    }

    /**
     * Called when admin REJECTS a user's disaster report.
     * Sends a notification to the report owner.
     */
    public static void notifyReportRejected(int userId, String disasterType) {
        String title   = "❌ Report Rejected";
        String message = "Your " + disasterType + " disaster report was reviewed but could not be approved at this time.";
        sendToUser(userId, title, message, "report_rejected");
    }

    /**
     * Called when admin creates a NEW ALERT.
     * Sends a notification to ALL active regular users.
     */
    public static void notifyNewAlert(String alertMessage, String severity) {
        String title   = "🚨 New " + severity + " Alert";
        String message = "A new emergency alert has been issued: " + alertMessage;

        try {
            // Fetch all active user IDs (role = 'user', status = 'active')
            UserDAO userDAO = new UserDAO();
            List<Integer> userIds = userDAO.getAllActiveUserIds();

            for (int userId : userIds) {
                sendToUser(userId, title, message, "new_alert");
            }
        } catch (SQLException e) {
            // Log and continue — notification failure should not block alert creation
            System.err.println("[NotificationService] Failed to send alert notifications: " + e.getMessage());
        }
    }

    // ─── Private Helper ───────────────────────────────────────────

    // Sends a single notification to one user — swallows exceptions so main flows aren't broken
    private static void sendToUser(int userId, String title, String message, String type) {
        try {
            Notification n = new Notification(userId, title, message, type);
            notifDAO.insertNotification(n);
        } catch (SQLException e) {
            System.err.println("[NotificationService] Failed to send notification to user " + userId + ": " + e.getMessage());
        }
    }
}
