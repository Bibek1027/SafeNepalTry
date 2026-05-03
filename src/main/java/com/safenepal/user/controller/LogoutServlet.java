package com.safenepal.user.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

// Handles logout — invalidates session and clears cookie
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Invalidate the current session
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Clear the remember-me cookie
        Cookie cookie = new Cookie("rememberedEmail", "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        resp.addCookie(cookie);

        // Redirect to dashboard (publicly accessible)
        resp.sendRedirect(req.getContextPath() + "/index.jsp?success=You have been logged out successfully.");
    }
}