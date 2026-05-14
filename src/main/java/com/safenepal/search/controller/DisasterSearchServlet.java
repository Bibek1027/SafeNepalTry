package com.safenepal.search.controller;

import com.safenepal.alert.model.Alert;
import com.safenepal.alert.model.dao.AlertDAO;
import com.safenepal.report.model.Report;
import com.safenepal.report.model.dao.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

/**
 * Public search: approved community reports and alerts by disaster type, location, or keywords.
 */
@WebServlet("/search")
public class DisasterSearchServlet extends HttpServlet {

    private static final int MAX_QUERY_LEN = 200;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String raw = req.getParameter("q");
        String q = raw == null ? "" : raw.trim();
        if (q.length() > MAX_QUERY_LEN) {
            q = q.substring(0, MAX_QUERY_LEN);
        }

        req.setAttribute("query", q);

        if (q.isEmpty()) {
            req.setAttribute("reports", Collections.emptyList());
            req.setAttribute("alerts", Collections.emptyList());
            req.setAttribute("searched", false);
        } else {
            req.setAttribute("searched", true);
            try {
                ReportDAO reportDAO = new ReportDAO();
                AlertDAO alertDAO = new AlertDAO();
                List<Report> reports = reportDAO.searchApprovedReports(q);
                List<Alert> alerts = alertDAO.searchAlerts(q);
                req.setAttribute("reports", reports);
                req.setAttribute("alerts", alerts);
            } catch (Exception e) {
                req.setAttribute("error", "Search failed: " + e.getMessage());
                req.setAttribute("reports", Collections.emptyList());
                req.setAttribute("alerts", Collections.emptyList());
            }
        }

        req.getRequestDispatcher("/pages/search.jsp").forward(req, resp);
    }
}
