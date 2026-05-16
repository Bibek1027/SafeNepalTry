package com.safenepal.feedback.controller;

import com.safenepal.feedback.model.Feedback;
import com.safenepal.feedback.model.dao.FeedbackDAO;
import com.safenepal.utils.SessionUtils;
import com.safenepal.utils.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/user/feedback")
public class FeedbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Session check — must be a logged-in user
        if (!SessionUtils.isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            int userId = SessionUtils.getUserId(req);
            
            // Load user's feedback history
            List<Feedback> userFeedback = feedbackDAO.getFeedbackByUserId(userId);
            req.setAttribute("userFeedback", userFeedback);
            
            // Load overall statistics
            double avgRating = feedbackDAO.getAverageRating();
            int totalFeedback = feedbackDAO.getFeedbackCount();
            req.setAttribute("avgRating", avgRating);
            req.setAttribute("totalFeedback", totalFeedback);

            req.getRequestDispatcher("/pages/user/feedback.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error", "Could not load feedback: " + e.getMessage());
            req.getRequestDispatcher("/pages/user/feedback.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Session check — must be a logged-in user
        if (!SessionUtils.isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String message = req.getParameter("message");
        String ratingStr = req.getParameter("rating");

        // Validation
        if (ValidationUtil.isEmpty(message)) {
            req.setAttribute("error", "Feedback message is required.");
            doGet(req, resp);
            return;
        }

        if (ValidationUtil.isEmpty(ratingStr)) {
            req.setAttribute("error", "Please select a rating.");
            doGet(req, resp);
            return;
        }

        try {
            int rating = Integer.parseInt(ratingStr);
            if (rating < 1 || rating > 5) {
                req.setAttribute("error", "Rating must be between 1 and 5.");
                doGet(req, resp);
                return;
            }

            int userId = SessionUtils.getUserId(req);
            Feedback feedback = new Feedback(userId, message.trim(), rating);
            
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            boolean success = feedbackDAO.insertFeedback(feedback);

            if (success) {
                resp.sendRedirect(req.getContextPath() + "/user/feedback?success=Feedback submitted successfully!");
            } else {
                req.setAttribute("error", "Failed to submit feedback. Please try again.");
                doGet(req, resp);
            }

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid rating value.");
            doGet(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Error submitting feedback: " + e.getMessage());
            doGet(req, resp);
        }
    }
}
