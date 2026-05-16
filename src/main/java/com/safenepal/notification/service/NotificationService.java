package com.safenepal.notification.service;

import com.safenepal.notification.model.Notification;
import com.safenepal.notification.model.dao.NotificationDAO;
import com.safenepal.user.model.User;
import com.safenepal.user.model.dao.UserDAO;
import com.safenepal.utils.EmailUtil;

import java.sql.SQLException;
import java.util.List;

// Service class that creates in-app notifications AND sends email notifications
public class NotificationService {

    private static final NotificationDAO notifDAO = new NotificationDAO();
    private static final UserDAO userDAO = new UserDAO();

    /**
     * Called when admin APPROVES a user's disaster report.
     * Sends in-app notification + email to the report owner.
     */
    public static void notifyReportApproved(int userId, String disasterType) {
        String title   = "Report Approved";
        String message = "Your " + disasterType + " disaster report has been reviewed and approved by the admin.";
        sendToUser(userId, title, message, "report_approved");

        // Send email notification
        try {
            User user = userDAO.getUserById(userId);
            if (user != null && user.getEmail() != null) {
                String htmlBody = EmailUtil.reportApprovedBody(user.getFullName(), disasterType);
                EmailUtil.sendEmail(user.getEmail(), "SafeNepal — Report Approved", htmlBody);
            }
        } catch (SQLException e) {
            System.err.println("[NotificationService] Failed to send approval email: " + e.getMessage());
        }
    }

    /**
     * Called when admin REJECTS a user's disaster report.
     * Sends in-app notification + email to the report owner.
     */
    public static void notifyReportRejected(int userId, String disasterType) {
        String title   = "Report Rejected";
        String message = "Your " + disasterType + " disaster report was reviewed but could not be approved at this time.";
        sendToUser(userId, title, message, "report_rejected");

        // Send email notification
        try {
            User user = userDAO.getUserById(userId);
            if (user != null && user.getEmail() != null) {
                String htmlBody = EmailUtil.reportRejectedBody(user.getFullName(), disasterType);
                EmailUtil.sendEmail(user.getEmail(), "SafeNepal — Report Not Approved", htmlBody);
            }
        } catch (SQLException e) {
            System.err.println("[NotificationService] Failed to send rejection email: " + e.getMessage());
        }
    }

    /**
     * Called when admin creates a NEW ALERT.
     * Sends in-app notification + email to ALL active regular users.
     */
    public static void notifyNewAlert(String alertMessage, String severity) {
        String title   = "New " + severity + " Alert";
        String message = "A new emergency alert has been issued: " + alertMessage;

        try {
            // Fetch all active users for both in-app and email notifications
            List<User> activeUsers = userDAO.getAllActiveUsers();

            for (User user : activeUsers) {
                // In-app notification
                sendToUser(user.getId(), title, message, "new_alert");

                // Email notification
                if (user.getEmail() != null) {
                    String htmlBody = EmailUtil.newAlertBody(user.getFullName(), alertMessage, severity);
                    EmailUtil.sendEmail(user.getEmail(), "SafeNepal — Emergency Alert: " + severity, htmlBody);
                }
            }
        } catch (SQLException e) {
            // Log and continue — notification failure should not block alert creation
            System.err.println("[NotificationService] Failed to send alert notifications: " + e.getMessage());
        }
    }

    /**
     * Called when a user changes their password.
     * Sends in-app notification + email confirmation.
     */
    public static void notifyPasswordChanged(int userId) {
        String title   = "Password Changed";
        String message = "Your account password has been changed successfully. If you did not make this change, contact support immediately.";
        sendToUser(userId, title, message, "password_changed");

        // Send email notification
        try {
            User user = userDAO.getUserById(userId);
            if (user != null && user.getEmail() != null) {
                String htmlBody = EmailUtil.passwordChangedBody(user.getFullName());
                EmailUtil.sendEmail(user.getEmail(), "SafeNepal — Password Changed", htmlBody);
            }
        } catch (SQLException e) {
            System.err.println("[NotificationService] Failed to send password change email: " + e.getMessage());
        }
    }

    /**
     * Called when a user updates their profile information.
     * Sends in-app notification + email confirmation.
     */
    public static void notifyProfileUpdated(int userId) {
        String title   = "Profile Updated";
        String message = "Your profile information has been updated successfully.";
        sendToUser(userId, title, message, "profile_updated");

        // Send email notification
        try {
            User user = userDAO.getUserById(userId);
            if (user != null && user.getEmail() != null) {
                String htmlBody = EmailUtil.profileUpdatedBody(user.getFullName());
                EmailUtil.sendEmail(user.getEmail(), "SafeNepal — Profile Updated", htmlBody);
            }
        } catch (SQLException e) {
            System.err.println("[NotificationService] Failed to send profile update email: " + e.getMessage());
        }
    }

    /**
     * Called when a user submits a new disaster report.
     * Sends in-app notification + email confirmation to the reporter.
     */
    public static void notifyReportSubmitted(int userId, String disasterType) {
        String title   = "Report Submitted";
        String message = "Your " + disasterType + " disaster report has been submitted and is pending admin review.";
        sendToUser(userId, title, message, "report_submitted");

        // Send email notification
        try {
            User user = userDAO.getUserById(userId);
            if (user != null && user.getEmail() != null) {
                String htmlBody = EmailUtil.reportSubmittedBody(user.getFullName(), disasterType);
                EmailUtil.sendEmail(user.getEmail(), "SafeNepal — Report Submitted", htmlBody);
            }
        } catch (SQLException e) {
            System.err.println("[NotificationService] Failed to send report submission email: " + e.getMessage());
        }
    }

    // ─── Private Helper ───────────────────────────────────────────

    // Sends a single in-app notification to one user — swallows exceptions so main flows aren't broken
    private static void sendToUser(int userId, String title, String message, String type) {
        try {
            Notification n = new Notification(userId, title, message, type);
            notifDAO.insertNotification(n);
        } catch (SQLException e) {
            System.err.println("[NotificationService] Failed to send notification to user " + userId + ": " + e.getMessage());
        }
    }
}
