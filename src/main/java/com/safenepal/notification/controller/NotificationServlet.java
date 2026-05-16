package com.safenepal.notification.controller;

import com.safenepal.notification.model.Notification;
import com.safenepal.notification.model.dao.NotificationDAO;
import com.safenepal.utils.SessionUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/user/notifications")
public class NotificationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Session check — must be a logged-in user
        if (!SessionUtils.isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = SessionUtils.getUserId(req);
        String action = req.getParameter("action");
        NotificationDAO dao = new NotificationDAO();

        try {
            // Mark a single notification as read
            if ("markRead".equals(action)) {
                String idStr = req.getParameter("id");
                if (idStr != null) {
                    dao.markAsRead(Integer.parseInt(idStr));
                }
                resp.sendRedirect(req.getContextPath() + "/user/notifications");
                return;
            }

            // Mark all notifications as read
            if ("markAllRead".equals(action)) {
                dao.markAllAsRead(userId);
                resp.sendRedirect(req.getContextPath() + "/user/notifications");
                return;
            }

            // Default: load full notification list and display page
            List<Notification> notifications = dao.getByUserId(userId);
            int unreadCount = dao.countUnread(userId);

            req.setAttribute("notifications", notifications);
            req.setAttribute("unreadCount", unreadCount);
            req.getRequestDispatcher("/pages/user/notifications.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error", "Could not load notifications: " + e.getMessage());
            req.getRequestDispatcher("/pages/user/notifications.jsp").forward(req, resp);
        }
    }
}
