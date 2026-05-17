package com.safenepal.engagement.controller;

import com.safenepal.engagement.model.ReportComment;
import com.safenepal.engagement.model.dao.ReportCommentDAO;
import com.safenepal.utils.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Step 4 — post a comment on a verified community report (logged-in users only).
 */
@WebServlet("/user/report/comment")
public class ReportCommentServlet extends HttpServlet {

    private static final int MAX_BODY_LEN = 2000;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handleDelete(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String idStr = req.getParameter("reportId");
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
            new ReportCommentDAO().insert(new ReportComment(reportId, userId, trimmed));
        } catch (Exception e) {
            System.err.println("[ReportCommentServlet] " + e.getMessage());
        }

        resp.sendRedirect(redirect + "#report-" + reportId);
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String commentIdStr = req.getParameter("delete");
        String reportIdStr = req.getParameter("reportId");
        String redirect = sanitizeRedirect(req, req.getParameter("redirect"));

        if (commentIdStr == null || reportIdStr == null) {
            resp.sendRedirect(redirect);
            return;
        }

        try {
            int commentId = Integer.parseInt(commentIdStr);
            int reportId = Integer.parseInt(reportIdStr);
            int userId = (int) session.getAttribute("userId");

            ReportCommentDAO dao = new ReportCommentDAO();
            boolean deleted = dao.delete(commentId, userId);

            if (deleted) {
                resp.sendRedirect(redirect + "#report-" + reportId);
            } else {
                resp.sendRedirect(redirect + "?commentError=deleteFailed#report-" + reportId);
            }
        } catch (Exception e) {
            System.err.println("[ReportCommentServlet] Delete error: " + e.getMessage());
            resp.sendRedirect(redirect);
        }
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
