package com.safenepal.admin.controller;

import com.safenepal.notification.service.NotificationService;
import com.safenepal.report.model.Report;
import com.safenepal.report.model.dao.ReportDAO;
import com.safenepal.reportImage.model.dao.ReportImageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String idStr  = req.getParameter("id");

        try {
            ReportDAO reportDAO = new ReportDAO();

            if (action != null && idStr != null) {
                int reportId = Integer.parseInt(idStr);

                switch (action) {
                    case "approve": {
                        // Fetch report first so we can send notification with details
                        Report report = reportDAO.getReportById(reportId);
                        reportDAO.updateStatus(reportId, "Approved");
                        // Notify the user whose report was approved
                        if (report != null) {
                            NotificationService.notifyReportApproved(report.getUserId(), report.getDisasterType());
                        }
                        resp.sendRedirect(req.getContextPath() + "/admin/reports?msg=Report approved.");
                        return;
                    }

                    case "reject": {
                        // Fetch report first so we can send notification with details
                        Report report = reportDAO.getReportById(reportId);
                        reportDAO.updateStatus(reportId, "Rejected");
                        // Notify the user whose report was rejected
                        if (report != null) {
                            NotificationService.notifyReportRejected(report.getUserId(), report.getDisasterType());
                        }
                        resp.sendRedirect(req.getContextPath() + "/admin/reports?msg=Report rejected.");
                        return;
                    }

                    case "delete": {
                        // Delete associated images from report_images table first
                        new ReportImageDAO().deleteByReportId(reportId);
                        reportDAO.deleteReport(reportId);
                        resp.sendRedirect(req.getContextPath() + "/admin/reports?msg=Report deleted.");
                        return;
                    }

                    default:
                        break;
                }
            }

            req.setAttribute("reports", reportDAO.getAllReports());
            req.getRequestDispatcher("/pages/admin/manageReports.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/pages/admin/manageReports.jsp").forward(req, resp);
        }
    }
}