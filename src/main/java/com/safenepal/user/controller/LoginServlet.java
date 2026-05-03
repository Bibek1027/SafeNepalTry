package com.safenepal.user.controller;

import com.safenepal.user.model.User;
import com.safenepal.user.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            String role = (String) session.getAttribute("role");
            resp.sendRedirect("admin".equals(role) ? "admin/dashboard" : "index.jsp");
            return;
        }
        req.getRequestDispatcher("/pages/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        try {
            UserDAO userDAO = new UserDAO();
            User userObj = userDAO.getUserByEmail(email);
            if (userObj == null || !BCrypt.checkpw(password, userObj.getPassword())) {
                req.setAttribute("error", "Invalid email or password.");
                req.setAttribute("email", email);
                req.getRequestDispatcher("/pages/login.jsp").forward(req, resp);
                return;
            }
            HttpSession session = req.getSession();
            session.setAttribute("userId", userObj.getId());
            session.setAttribute("userName", userObj.getFullName());
            session.setAttribute("email", userObj.getEmail());
            session.setAttribute("role", userObj.getRole());
            resp.sendRedirect("admin".equals(userObj.getRole()) ? "admin/dashboard" : "index.jsp");
        } catch (Exception e) {
            req.setAttribute("error", "Login failed: " + e.getMessage());
            req.getRequestDispatcher("/pages/login.jsp").forward(req, resp);
        }
    }
}