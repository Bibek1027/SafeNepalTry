package com.safenepal.engagement.controller;

import com.safenepal.engagement.model.AlertComment;
import com.safenepal.engagement.model.dao.AlertCommentDAO;
import com.safenepal.utils.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Step 2 — post a comment on an alert (logged-in users only).
 */
@WebServlet("/user/alert/comment")
public class AlertCommentServlet extends HttpServlet {

    private static final int MAX_BODY_LEN = 2000;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String idStr = req.getParameter("alertId");
        String body = req.getParameter("body");
        String redirect = sanitizeRedirect(req, req.getParameter("redirect"));

        if (ValidationUtil.isEmpty(body)) {
            resp.sendRedirect(redirect + "?commentError=empty");
            return;
        }

        String trimmed = body.trim();
        if (trimmed.length() > MAX_BODY_LEN) {
            trimmed = trimmed.substring(0, MAX_BODY_LEN);
        }

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
            new AlertCommentDAO().insert(new AlertComment(alertId, userId, trimmed));
        } catch (Exception e) {
            System.err.println("[AlertCommentServlet] " + e.getMessage());
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
