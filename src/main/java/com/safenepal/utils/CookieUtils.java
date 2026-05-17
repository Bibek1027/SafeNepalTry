package com.safenepal.utils;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Utility class for managing HTTP cookie operations.
 * Centralizes all cookie-related logic for consistency and reuse.
 */
public class CookieUtils {

    // Cookie name constants
    public static final String REMEMBERED_EMAIL = "rememberedEmail";

    // Default cookie expiry: 30 days (in seconds)
    private static final int DEFAULT_MAX_AGE = 30 * 24 * 60 * 60;

    // Prevent instantiation
    private CookieUtils() {}


    /**
     * description: Sets a cookie with the given name, value, and max age.
     * @param response
     * @param name
     * @param value
     * @param maxAge
     */
    public static void setCookie(HttpServletResponse response, String name, String value, int maxAge) {
        Cookie cookie = new Cookie(name, value);
        cookie.setMaxAge(maxAge);
        cookie.setPath("/");
        response.addCookie(cookie);
    }

    /**
     * description: Sets a cookie with default expiry (30 days).
     * @param response
     * @param name
     * @param value
     */
    public static void setCookie(HttpServletResponse response, String name, String value) {
        setCookie(response, name, value, DEFAULT_MAX_AGE);
    }

    /**
     * description: Retrieves a cookie value by name, or null if not found.
     * @param request
     * @param name
     * @return
     */
    public static String getCookieValue(HttpServletRequest request, String name) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (name.equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    /**
     * description: Deletes a cookie by setting its max age to 0.
     * @param response
     * @param name
     */
    public static void deleteCookie(HttpServletResponse response, String name) {
        Cookie cookie = new Cookie(name, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
    }

    /**
     * description: Saves the user's email in a "Remember Me" cookie.
     * @param response
     * @param email
     */
    public static void setRememberedEmail(HttpServletResponse response, String email) {
        setCookie(response, REMEMBERED_EMAIL, email);
    }

    /**
     * description: Retrieves the remembered email from cookie, or null.
     * @param request
     * @return
     */
    public static String getRememberedEmail(HttpServletRequest request) {
        return getCookieValue(request, REMEMBERED_EMAIL);
    }

    /**
     * description:  Clears the remembered email cookie.
     * @param response
     */
    public static void clearRememberedEmail(HttpServletResponse response) {
        deleteCookie(response, REMEMBERED_EMAIL);
    }
}
