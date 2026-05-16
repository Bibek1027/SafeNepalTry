package com.safenepal.user.controller;

import com.safenepal.notification.service.NotificationService;
import com.safenepal.user.model.User;
import com.safenepal.user.model.dao.UserDAO;
import com.safenepal.utils.SessionUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/user/profile")
public class ProfileServlet extends HttpServlet {

    // GET — load the logged-in user's data and show profile page
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!SessionUtils.isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            int userId = SessionUtils.getUserId(req);
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserById(userId);
            req.setAttribute("profileUser", user);
        } catch (Exception e) {
            req.setAttribute("error", "Could not load profile: " + e.getMessage());
        }

        req.getRequestDispatcher("/pages/user/profile.jsp").forward(req, resp);
    }

    // POST — handles either profile update or password change
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!SessionUtils.isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = SessionUtils.getUserId(req);
        String action = req.getParameter("action");
        UserDAO userDAO = new UserDAO();

        try {
            if ("updateProfile".equals(action)) {
                // --- Update name and phone ---
                String fullName = req.getParameter("fullName");
                String phone    = req.getParameter("phone");

                if (fullName == null || fullName.trim().isEmpty()) {
                    req.setAttribute("profileError", "Full name cannot be empty.");
                } else if (phone == null || phone.trim().isEmpty()) {
                    req.setAttribute("profileError", "Phone number cannot be empty.");
                } else {
                    boolean updated = userDAO.updateProfile(userId, fullName.trim(), phone.trim());
                    if (updated) {
                        // Refresh the name shown in the header
                        SessionUtils.setAttribute(req, SessionUtils.KEY_USER_NAME, fullName.trim());
                        req.setAttribute("profileSuccess", "Profile updated successfully.");
                        // Send in-app + email notification
                        NotificationService.notifyProfileUpdated(userId);
                    } else {
                        req.setAttribute("profileError", "Update failed. Please try again.");
                    }
                }

            } else if ("changePassword".equals(action)) {
                // --- Change password ---
                String currentPassword = req.getParameter("currentPassword");
                String newPassword     = req.getParameter("newPassword");
                String confirmPassword = req.getParameter("confirmPassword");

                User user = userDAO.getUserById(userId);

                if (user == null || !BCrypt.checkpw(currentPassword, user.getPassword())) {
                    req.setAttribute("passwordError", "Current password is incorrect.");
                } else if (newPassword == null || newPassword.length() < 6) {
                    req.setAttribute("passwordError", "New password must be at least 6 characters.");
                } else if (!newPassword.equals(confirmPassword)) {
                    req.setAttribute("passwordError", "New passwords do not match.");
                } else {
                    String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                    boolean updated = userDAO.updatePassword(userId, hashed);
                    if (updated) {
                        req.setAttribute("passwordSuccess", "Password changed successfully.");
                        // Send in-app + email notification
                        NotificationService.notifyPasswordChanged(userId);
                    } else {
                        req.setAttribute("passwordError", "Password update failed. Please try again.");
                    }
                }
            }

            // Re-load the user to reflect any changes
            User user = userDAO.getUserById(userId);
            req.setAttribute("profileUser", user);

        } catch (Exception e) {
            req.setAttribute("profileError", "Error: " + e.getMessage());
        }

        req.getRequestDispatcher("/pages/user/profile.jsp").forward(req, resp);
    }
}
