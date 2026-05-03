<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - SafeNepal</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; }
        .reg-container { display: flex; justify-content: center; align-items: center; min-height: 80vh; padding: 40px 20px; }
        .card { background: #fff; padding: 36px 32px; border-radius: 8px; box-shadow: 0 2px 12px rgba(0,0,0,0.12); width: 100%; max-width: 500px; }
        h2 { text-align: center; color: #333; margin-bottom: 24px; font-size: 24px; }
        .alert { padding: 12px; border-radius: 4px; margin-bottom: 20px; font-size: 14px; background: #fdecea; color: #b71c1c; border: 1px solid #f5c6cb; }
        label { display: block; font-size: 14px; color: #444; margin-bottom: 6px; font-weight: bold; }
        input { width: 100%; padding: 11px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; margin-bottom: 16px; }
        .btn { width: 100%; padding: 13px; background: #d32f2f; color: #fff; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; font-weight: bold; }
        .footer-link { text-align: center; margin-top: 20px; font-size: 14px; color: #555; }
        .footer-link a { color: #d32f2f; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>

<div class="main-wrapper">
    <jsp:include page="../components/header.jsp" />

    <div class="reg-container">
        <div class="card">
            <h2>Create Account</h2>
            <% if (request.getAttribute("error") != null) { %><div class="alert"><%= request.getAttribute("error") %></div><% } %>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <label>Full Name</label>
                <input type="text" name="fullName" value="<%= request.getAttribute("fullName")!=null?request.getAttribute("fullName"):"" %>" required>
                <label>Email Address</label>
                <input type="email" name="email" value="<%= request.getAttribute("email")!=null?request.getAttribute("email"):"" %>" required>
                <label>Phone Number</label>
                <input type="text" name="phone" value="<%= request.getAttribute("phone")!=null?request.getAttribute("phone"):"" %>" required>
                <label>Password</label>
                <input type="password" name="password" required>
                <label>Confirm Password</label>
                <input type="password" name="confirmPassword" required>
                <button type="submit" class="btn">Register</button>
            </form>
            <p class="footer-link">Already have an account? <a href="login">Login here</a></p>
        </div>
    </div>

</div>
<jsp:include page="../components/footer.jsp" />

</body>
</html>
