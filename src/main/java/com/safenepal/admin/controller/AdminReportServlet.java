package com.safenepal.admin.controller;

import com.safenepal.report.model.dao.ReportDAO;
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
                    case "approve":
                        reportDAO.updateStatus(reportId, "Approved");
                        resp.sendRedirect(req.getContextPath() + "/admin/reports?msg=Report approved.");
                        return;

                    case "reject":
                        reportDAO.updateStatus(reportId, "Rejected");
                        resp.sendRedirect(req.getContextPath() + "/admin/reports?msg=Report rejected.");
                        return;

                    case "delete":
                        reportDAO.deleteReport(reportId);
                        resp.sendRedirect(req.getContextPath() + "/admin/reports?msg=Report deleted.");
                        return;

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