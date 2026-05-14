package com.safenepal.admin.controller;

import com.safenepal.user.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

// Admin user management — approve, suspend, delete users
@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String idStr  = req.getParameter("id");

        try {
            UserDAO userDAO = new UserDAO();

            // Handle action buttons (approve / suspend / delete)
            if (action != null && idStr != null) {
                int userId = Integer.parseInt(idStr);

                switch (action) {
                    case "suspend":
                        userDAO.updateStatus(userId, "suspended");
                        resp.sendRedirect(req.getContextPath() + "/admin/users?msg=User suspended.");
                        return;
                    case "unsuspend":
                        userDAO.updateStatus(userId, "active");
                        resp.sendRedirect(req.getContextPath() + "/admin/users?msg=User unsuspended.");
                        return;
                    case "delete":
                        userDAO.deleteUser(userId);
                        resp.sendRedirect(req.getContextPath() + "/admin/users?msg=User deleted.");
                        return;

                    default:
                        break;
                }
            }

            // Default: list all users
            req.setAttribute("users", userDAO.getAllUsers());
            req.getRequestDispatcher("/pages/admin/manageUsers.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/pages/admin/manageUsers.jsp").forward(req, resp);
        }
    }
}