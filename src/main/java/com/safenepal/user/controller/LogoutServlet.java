package com.safenepal.user.controller;

import com.safenepal.utils.CookieUtils;
import com.safenepal.utils.SessionUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

// Handles logout — invalidates session and clears cookie
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Invalidate the current session
        SessionUtils.invalidateSession(req);

        // Clear the remember-me cookie
        CookieUtils.clearRememberedEmail(resp);

        // Redirect to dashboard (publicly accessible)
        resp.sendRedirect(req.getContextPath() + "/index.jsp?success=You have been logged out successfully.");
    }
}