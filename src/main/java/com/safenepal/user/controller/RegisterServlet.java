package com.safenepal.user.controller;

import com.safenepal.user.model.User;
import com.safenepal.user.model.dao.UserDAO;
import com.safenepal.utils.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/pages/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        req.setAttribute("fullName", fullName);
        req.setAttribute("email", email);
        req.setAttribute("phone", phone);

        if (!ValidationUtil.isValidFullName(fullName)) {
            req.setAttribute("error", "Invalid full name.");
            req.getRequestDispatcher("/pages/register.jsp").forward(req, resp);
            return;
        }
        if (!ValidationUtil.isValidEmail(email)) {
            req.setAttribute("error", "Invalid email address.");
            req.getRequestDispatcher("/pages/register.jsp").forward(req, resp);
            return;
        }
        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("/pages/register.jsp").forward(req, resp);
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            if (userDAO.getUserByEmail(email) != null) {
                req.setAttribute("error", "Email already exists.");
                req.getRequestDispatcher("/pages/register.jsp").forward(req, resp);
                return;
            }
            // Check for duplicate phone number (phone is UNI in the table)
            if (userDAO.getUserByPhone(phone) != null) {
                req.setAttribute("error", "Phone number already registered.");
                req.getRequestDispatcher("/pages/register.jsp").forward(req, resp);
                return;
            }
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
            User newUser = new User(fullName, email, phone, hashedPassword, "user");
            if (userDAO.insertUser(newUser)) {
                resp.sendRedirect("login?success=Registration successful!");
            } else {
                req.setAttribute("error", "Database error.");
                req.getRequestDispatcher("/pages/register.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/pages/register.jsp").forward(req, resp);
        }
    }
}