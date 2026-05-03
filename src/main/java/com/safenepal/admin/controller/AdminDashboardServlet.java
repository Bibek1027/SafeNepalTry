package com.safenepal.admin.controller;

import com.safenepal.alert.model.dao.AlertDAO;
import com.safenepal.report.model.dao.ReportDAO;
import com.safenepal.user.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            ReportDAO reportDAO = new ReportDAO();
            UserDAO   userDAO   = new UserDAO();
            AlertDAO  alertDAO  = new AlertDAO();

            req.setAttribute("pendingReports", reportDAO.countByStatus("Pending"));
            req.setAttribute("approvedReports", reportDAO.countByStatus("Approved"));
            req.setAttribute("totalUsers", userDAO.countTotalUsers());
            req.setAttribute("totalAlerts", alertDAO.countAlerts());

            req.setAttribute("recentReports",   reportDAO.getAllReports());

        } catch (Exception e) {
            req.setAttribute("error", "Error loading dashboard: " + e.getMessage());
        }
        req.getRequestDispatcher("/pages/admin/dashboard.jsp").forward(req, resp);
    }
}