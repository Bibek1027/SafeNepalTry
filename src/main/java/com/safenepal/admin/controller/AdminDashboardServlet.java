package com.safenepal.admin.controller;

import com.safenepal.user.model.User;
import com.safenepal.user.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/setup-admin")
public class AdminSetupServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("text/html; charset=UTF-8");
        PrintWriter out = resp.getWriter();

        String adminEmail    = "admin@gmail.com";
        String adminPassword = "Admin@123";
        String adminName     = "System Admin";
        String adminPhone    = "9764887532";

        try {
            UserDAO userDAO = new UserDAO();

            if (userDAO.getUserByEmail(adminEmail) != null) {
                out.println("<h3 style='color:orange;'>⚠️ Admin account already exists!</h3>");
                out.println("<p>Email: <strong>" + adminEmail + "</strong></p>");
                out.println("<p>Use the existing password to log in.</p>");
                out.println("<a href='" + req.getContextPath() + "/login'>Go to Login</a>");
                return;
            }

            String hashed = BCrypt.hashpw(adminPassword, BCrypt.gensalt());
            User admin = new User(adminName, adminEmail, adminPhone, hashed, "admin");

            boolean created = userDAO.insertUser(admin);

            if (created) {
                out.println("<h3 style='color:green;'>✅ Admin account created successfully!</h3>");
                out.println("<p><strong>Email:</strong> " + adminEmail + "</p>");
                out.println("<p><strong>Password:</strong> " + adminPassword + "</p>");
                out.println("<br><a href='" + req.getContextPath() + "/login'>Go to Login &rarr;</a>");
                out.println("<br><br><p style='color:red;'><strong>⚠️ Delete or disable AdminSetupServlet after use!</strong></p>");
            } else {
                out.println("<h3 style='color:red;'>❌ Failed to create admin account. Check DB connection.</h3>");
            }

        } catch (Exception e) {
            out.println("<h3 style='color:red;'>❌ Error: " + e.getMessage() + "</h3>");
        }
    }
}
