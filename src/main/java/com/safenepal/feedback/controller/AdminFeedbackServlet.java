package com.safenepal.feedback.controller;

import com.safenepal.feedback.model.Feedback;
import com.safenepal.feedback.model.dao.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/feedback")
public class AdminFeedbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Session check — must be admin
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            
            // Load all feedback for admin view
            List<Feedback> allFeedback = feedbackDAO.getAllFeedback();
            System.out.println("[AdminFeedbackServlet] Loaded " + allFeedback.size() + " feedback entries");
            req.setAttribute("allFeedback", allFeedback);
            
            // Load statistics
            double avgRating = feedbackDAO.getAverageRating();
            int totalFeedback = feedbackDAO.getFeedbackCount();
            System.out.println("[AdminFeedbackServlet] Stats - Avg: " + avgRating + ", Total: " + totalFeedback);
            req.setAttribute("avgRating", avgRating);
            req.setAttribute("totalFeedback", totalFeedback);

            req.getRequestDispatcher("/pages/admin/manageFeedback.jsp").forward(req, resp);

        } catch (Exception e) {
            System.err.println("[AdminFeedbackServlet] Error: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Could not load feedback: " + e.getMessage());
            req.getRequestDispatcher("/pages/admin/manageFeedback.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Session check — must be admin
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        String idStr = req.getParameter("id");

        try {
            FeedbackDAO feedbackDAO = new FeedbackDAO();

            if ("delete".equals(action) && idStr != null) {
                int feedbackId = Integer.parseInt(idStr);
                boolean success = feedbackDAO.deleteFeedback(feedbackId);
                
                if (success) {
                    resp.sendRedirect(req.getContextPath() + "/admin/feedback?msg=Feedback deleted successfully!");
                } else {
                    req.setAttribute("error", "Failed to delete feedback.");
                    doGet(req, resp);
                }
            } else {
                req.setAttribute("error", "Invalid action.");
                doGet(req, resp);
            }

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid feedback ID.");
            doGet(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            doGet(req, resp);
        }
    }
}
