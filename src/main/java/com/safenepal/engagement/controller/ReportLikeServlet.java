package com.safenepal.engagement.controller;

import com.safenepal.engagement.model.dao.ReportLikeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Step 3 — toggle like on a verified community report (logged-in users only).
 */
@WebServlet("/user/report/like")
public class ReportLikeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String idStr = req.getParameter("reportId");
        String redirect = sanitizeRedirect(req, req.getParameter("redirect"));

        int reportId;
        try {
            reportId = Integer.parseInt(idStr);
            if (reportId <= 0) throw new NumberFormatException();
        } catch (Exception e) {
            resp.sendRedirect(redirect);
            return;
        }

        try {
            int userId = (int) session.getAttribute("userId");
            new ReportLikeDAO().toggleLike(reportId, userId);
        } catch (Exception e) {
            System.err.println("[ReportLikeServlet] " + e.getMessage());
        }

        resp.sendRedirect(redirect + "#report-" + reportId);
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
