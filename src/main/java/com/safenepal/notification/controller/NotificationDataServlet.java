package com.safenepal.notification.controller;

import com.safenepal.notification.model.Notification;
import com.safenepal.notification.model.dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

// Serves notifications as JSON for the navbar dropdown AJAX call
@WebServlet("/user/notifications/data")
public class NotificationDataServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int userId = (int) session.getAttribute("userId");
        resp.setContentType("application/json; charset=UTF-8");

        try {
            List<Notification> list = new NotificationDAO().getRecentUnread(userId);
            PrintWriter out = resp.getWriter();
            out.print("[");
            for (int i = 0; i < list.size(); i++) {
                Notification n = list.get(i);
                if (i > 0) out.print(",");
                out.print("{");
                out.print("\"notificationId\":" + n.getNotificationId() + ",");
                out.print("\"userId\":" + n.getUserId() + ",");
                out.print("\"title\":\"" + escJson(n.getTitle()) + "\",");
                out.print("\"message\":\"" + escJson(n.getMessage()) + "\",");
                out.print("\"type\":\"" + escJson(n.getType()) + "\",");
                out.print("\"read\":" + n.isRead() + ",");
                String ts = n.getCreatedAt() != null ? n.getCreatedAt().toString() : "";
                out.print("\"createdAt\":\"" + ts + "\"");
                out.print("}");
            }
            out.print("]");
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().print("[]");
        }
    }

    // Escape special chars for safe JSON string embedding
    private String escJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
