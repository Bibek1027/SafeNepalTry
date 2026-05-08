package com.safenepal.user.controller;

import com.safenepal.alert.model.dao.AlertDAO;
import com.safenepal.report.model.dao.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

// Shows the dashboard — accessible to guests AND logged-in users
@WebServlet("/user/dashboard")
public class UserDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("userId") != null);

        try {
            AlertDAO alertDAO = new AlertDAO();
            // Always load alerts — visible to everyone
            req.setAttribute("alerts", alertDAO.getAllAlerts());

            if (isLoggedIn) {
                // Load personal report data only for logged-in users
                int userId = (int) session.getAttribute("userId");
                ReportDAO reportDAO = new ReportDAO();
                req.setAttribute("myReports",    reportDAO.getReportsByUser(userId));
                req.setAttribute("totalReports", reportDAO.countByUser(userId));
            }

        } catch (Exception e) {
            req.setAttribute("error", "Could not load dashboard: " + e.getMessage());
        }

        req.getRequestDispatcher("/pages/user/dashboard.jsp").forward(req, resp);
    }
}