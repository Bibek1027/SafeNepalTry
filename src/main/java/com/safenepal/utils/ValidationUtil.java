package com.safenepal.utils;

// Utility class for common validation methods used across the system
public class ValidationUtil {

    // Returns true if the string is null or blank
    public static boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    // Validates a basic email format
    public static boolean isValidEmail(String email) {
        if (isEmpty(email)) return false;
        return email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    // Validates phone: exactly 10 digits
    public static boolean isValidPhone(String phone) {
        if (isEmpty(phone)) return false;
        return phone.matches("^[0-9]{10}$");
    }

    // Validates full name: letters and spaces only (no numbers)
    public static boolean isValidFullName(String name) {
        if (isEmpty(name)) return false;
        return name.matches("^[A-Za-z ]+$");
    }

    // Validates password: minimum 8 characters
    public static boolean isValidPassword(String password) {
        return !isEmpty(password) && password.length() >= 8;
    }
}