package com.safenepal.report.controller;

import com.safenepal.report.model.Report;
import com.safenepal.report.model.dao.ReportDAO;
import com.safenepal.utils.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/user/report")
public class ReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/register?error=Please register to submit a report.");
            return;
        }
        req.getRequestDispatcher("/pages/user/reportForm.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        int userId = (int) session.getAttribute("userId");
        String type = req.getParameter("disasterType");
        String loc = req.getParameter("location");
        String desc = req.getParameter("description");

        if (ValidationUtil.isEmpty(type) || ValidationUtil.isEmpty(loc) || desc.length() < 10) {
            req.setAttribute("error", "Please fill all fields correctly.");
            req.getRequestDispatcher("/pages/user/reportForm.jsp").forward(req, resp);
            return;
        }

        try {
            if (new ReportDAO().insertReport(new Report(userId, type, loc, desc))) {
                resp.sendRedirect(req.getContextPath() + "/index.jsp?success=Report submitted!");
            } else {
                req.setAttribute("error", "Submission failed.");
                req.getRequestDispatcher("/pages/user/reportForm.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/pages/user/reportForm.jsp").forward(req, resp);
        }
    }
}