package com.safenepal.admin.controller;

import com.safenepal.alert.model.Alert;
import com.safenepal.alert.model.dao.AlertDAO;
import com.safenepal.location.model.dao.LocationDAO;
import com.safenepal.notification.service.NotificationService;
import com.safenepal.utils.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/alerts")
public class AdminAlertServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String idStr  = req.getParameter("id");

        try {
            AlertDAO alertDAO = new AlertDAO();

            if ("delete".equals(action) && idStr != null) {
                alertDAO.deleteAlert(Integer.parseInt(idStr));
                resp.sendRedirect(req.getContextPath() + "/admin/alerts?msg=Alert deleted.");
                return;
            }

            req.setAttribute("locations", new LocationDAO().getAllLocations());
            req.setAttribute("alerts", alertDAO.getAllAlerts());
            req.getRequestDispatcher("/pages/admin/manageAlerts.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/pages/admin/manageAlerts.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session  = req.getSession(false);
        int adminId  = (int) session.getAttribute("userId");

        String message  = req.getParameter("message");
        String severity = req.getParameter("severity");
        String locStr   = req.getParameter("locationId");
        String type     = req.getParameter("alertType");

        if (ValidationUtil.isEmpty(message)) {
            req.setAttribute("error", "Alert message is required.");
            loadAndForward(req, resp);
            return;
        }
        if (ValidationUtil.isEmpty(severity)) {
            req.setAttribute("error", "Please select a severity level.");
            loadAndForward(req, resp);
            return;
        }

        try {
            AlertDAO alertDAO = new AlertDAO();
            Alert alert = new Alert();
            alert.setAdminId(adminId);
            alert.setMessage(message);
            alert.setSeverity(severity);
            alert.setAlertType(type != null ? type : "Emergency");
            alert.setLocationId(Integer.parseInt(locStr));
            
            alertDAO.insertAlert(alert);

            // Notify ALL active users about the new emergency alert
            NotificationService.notifyNewAlert(message, severity);

            resp.sendRedirect(req.getContextPath() + "/admin/alerts?msg=Alert published successfully!");

        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            loadAndForward(req, resp);
        }
    }

    private void loadAndForward(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("locations", new LocationDAO().getAllLocations());
            req.setAttribute("alerts", new AlertDAO().getAllAlerts());
        } catch (Exception ignored) {}
        req.getRequestDispatcher("/pages/admin/manageAlerts.jsp").forward(req, resp);
    }
}