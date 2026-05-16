package com.safenepal.engagement.controller;

import com.safenepal.engagement.model.dao.AlertLikeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Step 1 — toggle like on an alert (logged-in users only).
 */
@WebServlet("/user/alert/like")
public class AlertLikeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String idStr = req.getParameter("alertId");
        String redirect = sanitizeRedirect(req, req.getParameter("redirect"));

        int alertId;
        try {
            alertId = Integer.parseInt(idStr);
            if (alertId <= 0) throw new NumberFormatException();
        } catch (Exception e) {
            resp.sendRedirect(redirect);
            return;
        }

        try {
            int userId = (int) session.getAttribute("userId");
            new AlertLikeDAO().toggleLike(alertId, userId);
        } catch (Exception e) {
            System.err.println("[AlertLikeServlet] " + e.getMessage());
        }

        resp.sendRedirect(redirect + "#alert-" + alertId);
    }

    private String sanitizeRedirect(HttpServletRequest req, String redirect) {
        String fallback = req.getContextPath() + "/";
        if (redirect == null || redirect.isBlank()) {
            return fallback;
        }
        String path = redirect.trim();
        if (path.startsWith("http://") || path.startsWith("https://") || path.startsWith("//")) {
            return fallback;
        }
        if (!path.startsWith("/")) {
            path = "/" + path;
        }
        return req.getContextPath() + path;
    }
}
