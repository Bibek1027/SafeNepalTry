package com.safenepal.utils;

import com.safenepal.user.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * Utility class for managing HTTP session operations.
 * Centralizes all session-related logic for consistency and reuse.
 */
public class SessionUtils {

    // Session attribute keys
    public static final String KEY_USER_ID   = "userId";
    public static final String KEY_USER_NAME = "userName";
    public static final String KEY_EMAIL     = "email";
    public static final String KEY_ROLE      = "role";

    // Prevent instantiation
    private SessionUtils() {}

    /**
     * Creates a new session and stores user details after successful login.
     */
    public static void createLoginSession(HttpServletRequest request, User user) {
        HttpSession session = request.getSession();
        session.setAttribute(KEY_USER_ID, user.getId());
        session.setAttribute(KEY_USER_NAME, user.getFullName());
        session.setAttribute(KEY_EMAIL, user.getEmail());
        session.setAttribute(KEY_ROLE, user.getRole());
    }

    /**
     * Invalidates the current session (logout).
     */
    public static void invalidateSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }

    /**
     * Checks if the user is currently logged in.
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute(KEY_USER_ID) != null;
    }

    /**
     * Checks if the logged-in user is an admin.
     */
    public static boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null
                && session.getAttribute(KEY_USER_ID) != null
                && "admin".equals(session.getAttribute(KEY_ROLE));
    }

    /**
     * Returns the logged-in user's ID, or -1 if not logged in.
     */
    public static int getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute(KEY_USER_ID) != null) {
            return (int) session.getAttribute(KEY_USER_ID);
        }
        return -1;
    }

    /**
     * Returns the logged-in user's display name, or null if not logged in.
     */
    public static String getUserName(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (String) session.getAttribute(KEY_USER_NAME);
        }
        return null;
    }

    /**
     * Returns the logged-in user's email, or null if not logged in.
     */
    public static String getEmail(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (String) session.getAttribute(KEY_EMAIL);
        }
        return null;
    }

    /**
     * Returns the logged-in user's role, or null if not logged in.
     */
    public static String getRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (String) session.getAttribute(KEY_ROLE);
        }
        return null;
    }

    /**
     * Updates a single session attribute (e.g., after profile update).
     */
    public static void setAttribute(HttpServletRequest request, String key, Object value) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.setAttribute(key, value);
        }
    }
}
