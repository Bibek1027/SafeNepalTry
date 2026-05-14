package com.safenepal.filter;

import com.safenepal.user.model.User;
import com.safenepal.user.model.dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

// Filter to restrict access based on login status and role
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("================================================");
        System.out.println("   SafeNepal AuthFilter is INITIALIZED!");
        System.out.println("================================================");
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws ServletException, IOException {

        HttpServletResponse httpResponse = (HttpServletResponse) resp;
        HttpServletRequest  httpRequest  = (HttpServletRequest)  req;

        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        System.out.println("[SafeNepal Debug] ContextPath: '" + contextPath + "' | URI: '" + uri + "'");

        // Get current session (don't create a new one)
        HttpSession session    = httpRequest.getSession(false);
        boolean     isLoggedIn = (session != null && session.getAttribute("userId") != null);
        String      role       = isLoggedIn ? (String) session.getAttribute("role") : null;

        // Always allow CSS, JS, images and error pages through
        boolean isStaticResource = uri.contains("/css/") || uri.contains("/js/")
                || uri.contains("/images/") || uri.contains("/errorpage/");

        // Public pages (no login required)
        boolean isPublicPage = uri.endsWith("/login")  || uri.endsWith("/register")
                || uri.endsWith("/")        || uri.endsWith("/index.jsp")
                || uri.endsWith("/test.txt");

        System.out.println("[SafeNepal AuthFilter] Filtering URI: " + uri);

        if (isStaticResource || isPublicPage) {
            chain.doFilter(req, resp);
            return;
        }

        // If logged in and trying to visit login/register → redirect to their dashboard
        if (isLoggedIn && isPublicPage) {
            if ("admin".equals(role)) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin/dashboard");
            } else {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/user/dashboard");
            }
            return;
        }

        // Admin-only area protection
        if (uri.contains("/admin/") && !"admin".equals(role)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/errorpage/error404.jsp");
            return;
        }

        // User-only area protection
        if (uri.contains("/user/") && !"user".equals(role)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/errorpage/error404.jsp");
            return;
        }

        // Check if user is suspended (only for logged-in users accessing protected areas)
        if (isLoggedIn && !isPublicPage) {
            try {
                UserDAO userDAO = new UserDAO();
                int userId = (Integer) session.getAttribute("userId");
                User user = userDAO.getUserById(userId);
                
                if (user != null && "suspended".equals(user.getStatus())) {
                    // Invalidate session and redirect to login with suspension message
                    session.invalidate();
                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?suspended=true");
                    return;
                }
            } catch (SQLException e) {
                System.err.println("[AuthFilter] Error checking user suspension: " + e.getMessage());
                // On error, allow access but log the issue
            }
        }

        // Public disaster search — no login required; must be before the login redirect
        if (uri.endsWith("/search")) {
            chain.doFilter(req, resp);
            return;
        }

        // Not logged in → redirect to login
        if (!isLoggedIn) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        chain.doFilter(req, resp);
    }
}