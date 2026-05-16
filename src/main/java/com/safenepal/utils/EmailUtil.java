package com.safenepal.utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

/**
 * Utility class for sending HTML email notifications via Gmail SMTP.
 * All emails are sent asynchronously on a separate thread so servlet
 * responses are never blocked by network latency.
 */
public class EmailUtil {

    // ─── Gmail SMTP Configuration ────────────────────────────────────
    // IMPORTANT: Update SENDER_EMAIL to the Gmail address that owns the App
    // Password below.
    private static final String SENDER_EMAIL = "beebektamang90@gmail.com";
    private static final String APP_PASSWORD = "sflc veyh mrvv tjos";
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final int SMTP_PORT = 587;

    // Reusable mail session (thread-safe)
    private static final Session MAIL_SESSION;

    static {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", String.valueOf(SMTP_PORT));
        props.put("mail.smtp.ssl.trust", SMTP_HOST);

        MAIL_SESSION = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, APP_PASSWORD);
            }
        });
    }

    /**
     * Sends an HTML email asynchronously. Failures are logged to stderr
     * but never propagated — email delivery should not break main flows.
     *
     * @param toEmail  recipient email address
     * @param subject  email subject line
     * @param htmlBody HTML content for the email body
     */
    public static void sendEmail(String toEmail, String subject, String htmlBody) {
        new Thread(() -> {
            try {
                Message message = new MimeMessage(MAIL_SESSION);
                message.setFrom(new InternetAddress(SENDER_EMAIL, "SafeNepal"));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
                message.setSubject(subject);
                message.setContent(htmlBody, "text/html; charset=utf-8");

                Transport.send(message);
                System.out.println("[EmailUtil] Email sent to " + toEmail + " — Subject: " + subject);

            } catch (Exception e) {
                System.err.println("[EmailUtil] Failed to send email to " + toEmail + ": " + e.getMessage());
            }
        }).start();
    }

    // ─── Professional HTML Email Templates ───────────────────────────

    /**
     * Wraps content in a branded SafeNepal HTML email layout.
     */
    private static String wrapInTemplate(String title, String bodyContent) {
        return "<!DOCTYPE html>" +
                "<html><head><meta charset='utf-8'/></head>" +
                "<body style='margin:0;padding:0;font-family:Arial,Helvetica,sans-serif;background:#f4f6f8;'>" +
                "<table width='100%' cellpadding='0' cellspacing='0' style='background:#f4f6f8;padding:30px 0;'>" +
                "<tr><td align='center'>" +
                "<table width='600' cellpadding='0' cellspacing='0' style='background:#ffffff;border-radius:8px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,0.08);'>"
                +

                // Header
                "<tr><td style='background:linear-gradient(135deg,#1a73e8,#0d47a1);padding:24px 32px;'>" +
                "<h1 style='margin:0;color:#ffffff;font-size:22px;font-weight:600;'>SafeNepal</h1>" +
                "<p style='margin:4px 0 0;color:#bbdefb;font-size:13px;'>Disaster Reporting &amp; Alert System</p>" +
                "</td></tr>" +

                // Title bar
                "<tr><td style='padding:20px 32px 0;'>" +
                "<h2 style='margin:0;color:#1a73e8;font-size:18px;font-weight:600;'>" + title + "</h2>" +
                "<hr style='border:none;border-top:1px solid #e0e0e0;margin:12px 0 0;'/>" +
                "</td></tr>" +

                // Body
                "<tr><td style='padding:16px 32px 24px;color:#333333;font-size:14px;line-height:1.7;'>" +
                bodyContent +
                "</td></tr>" +

                // Footer
                "<tr><td style='background:#f9fafb;padding:16px 32px;border-top:1px solid #e8eaed;'>" +
                "<p style='margin:0;color:#999999;font-size:12px;text-align:center;'>" +
                "This is an automated notification from SafeNepal. Please do not reply to this email." +
                "</p></td></tr>" +

                "</table></td></tr></table></body></html>";
    }

    // ─── Pre-built Email Bodies ──────────────────────────────────────

    /** Email body for password change confirmation */
    public static String passwordChangedBody(String userName) {
        String content = "<p>Hello <strong>" + userName + "</strong>,</p>" +
                "<p>Your SafeNepal account password has been changed successfully.</p>" +
                "<div style='background:#e8f5e9;border-left:4px solid #43a047;padding:12px 16px;margin:16px 0;border-radius:4px;'>"
                +
                "<strong>Security Notice:</strong> If you did not make this change, please contact the system administrator immediately."
                +
                "</div>" +
                "<p>For your security, you may need to log in again on your other devices.</p>";
        return wrapInTemplate("Password Changed", content);
    }

    /** Email body for profile update confirmation */
    public static String profileUpdatedBody(String userName) {
        String content = "<p>Hello <strong>" + userName + "</strong>,</p>" +
                "<p>Your profile information has been updated successfully on SafeNepal.</p>" +
                "<div style='background:#e3f2fd;border-left:4px solid #1a73e8;padding:12px 16px;margin:16px 0;border-radius:4px;'>"
                +
                "If you did not make these changes, please review your account settings or contact support." +
                "</div>";
        return wrapInTemplate("Profile Updated", content);
    }

    /** Email body for new report submission confirmation */
    public static String reportSubmittedBody(String userName, String disasterType) {
        String content = "<p>Hello <strong>" + userName + "</strong>,</p>" +
                "<p>Your <strong>" + disasterType + "</strong> disaster report has been submitted successfully.</p>" +
                "<div style='background:#fff3e0;border-left:4px solid #ef6c00;padding:12px 16px;margin:16px 0;border-radius:4px;'>"
                +
                "<strong>What happens next?</strong> An administrator will review your report shortly. " +
                "You will receive another notification once a decision has been made." +
                "</div>" +
                "<p>Thank you for helping keep Nepal safe.</p>";
        return wrapInTemplate("Report Submitted", content);
    }

    /** Email body for report approval */
    public static String reportApprovedBody(String userName, String disasterType) {
        String content = "<p>Hello <strong>" + userName + "</strong>,</p>" +
                "<p>Your <strong>" + disasterType
                + "</strong> disaster report has been reviewed and <span style='color:#2e7d32;font-weight:bold;'>approved</span> by the administrator.</p>"
                +
                "<div style='background:#e8f5e9;border-left:4px solid #43a047;padding:12px 16px;margin:16px 0;border-radius:4px;'>"
                +
                "Your report is now visible to the community and will help coordinate disaster response efforts." +
                "</div>" +
                "<p>Thank you for your valuable contribution to public safety.</p>";
        return wrapInTemplate("Report Approved", content);
    }

    /** Email body for report rejection */
    public static String reportRejectedBody(String userName, String disasterType) {
        String content = "<p>Hello <strong>" + userName + "</strong>,</p>" +
                "<p>Your <strong>" + disasterType
                + "</strong> disaster report has been reviewed but could <span style='color:#c62828;font-weight:bold;'>not be approved</span> at this time.</p>"
                +
                "<div style='background:#ffebee;border-left:4px solid #c62828;padding:12px 16px;margin:16px 0;border-radius:4px;'>"
                +
                "<strong>Possible reasons:</strong> Insufficient details, duplicate submission, or unverifiable information. "
                +
                "You may submit a new report with additional details." +
                "</div>";
        return wrapInTemplate("Report Not Approved", content);
    }

    /** Email body for new emergency alert */
    public static String newAlertBody(String userName, String alertMessage, String severity) {
        String severityColor;
        switch (severity != null ? severity.toLowerCase() : "") {
            case "critical":
                severityColor = "#c62828";
                break;
            case "high":
                severityColor = "#ef6c00";
                break;
            case "medium":
                severityColor = "#f9a825";
                break;
            default:
                severityColor = "#1a73e8";
                break;
        }

        String content = "<p>Hello <strong>" + userName + "</strong>,</p>" +
                "<p>A new emergency alert has been issued by SafeNepal administration:</p>" +
                "<div style='background:#fff3e0;border-left:4px solid " + severityColor
                + ";padding:12px 16px;margin:16px 0;border-radius:4px;'>" +
                "<p style='margin:0 0 8px;'><strong>Severity:</strong> <span style='color:" + severityColor
                + ";font-weight:bold;text-transform:uppercase;'>" + severity + "</span></p>" +
                "<p style='margin:0;'><strong>Details:</strong> " + alertMessage + "</p>" +
                "</div>" +
                "<p>Please stay safe and follow instructions from local authorities.</p>";
        return wrapInTemplate("Emergency Alert", content);
    }
}
