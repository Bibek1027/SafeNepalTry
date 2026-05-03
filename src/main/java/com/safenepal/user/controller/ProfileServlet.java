package com.safenepal.user.controller;

import com.safenepal.user.model.User;
import com.safenepal.user.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/user/profile")
public class ProfileServlet extends HttpServlet {

    // GET — load the logged-in user's data and show profile page
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            int userId = (int) session.getAttribute("userId");
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

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
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
                        session.setAttribute("userName", fullName.trim());
                        req.setAttribute("profileSuccess", "Profile updated successfully.");
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
