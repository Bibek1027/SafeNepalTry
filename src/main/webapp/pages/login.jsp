<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - SafeNepal</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; }
        .login-container { display: flex; justify-content: center; align-items: center; min-height: 80vh; padding: 20px; }
        .card { background: #fff; padding: 36px 32px; border-radius: 8px; box-shadow: 0 2px 12px rgba(0,0,0,0.12); width: 100%; max-width: 420px; }
        .logo { text-align: center; margin-bottom: 24px; }
        .logo h1 { color: #d32f2f; font-size: 28px; }
        h2 { text-align: center; color: #333; margin-bottom: 20px; font-size: 20px; }
        .alert { padding: 10px 14px; border-radius: 4px; margin-bottom: 16px; font-size: 14px; }
        .alert-error { background: #fdecea; color: #b71c1c; border: 1px solid #f5c6cb; }
        .alert-success { background: #e8f5e9; color: #1b5e20; border: 1px solid #c3e6cb; }
        label { display: block; font-size: 14px; color: #444; margin-bottom: 4px; font-weight: bold; }
        input[type="email"], input[type="password"] { width: 100%; padding: 10px 12px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; margin-bottom: 14px; }
        .btn { width: 100%; padding: 12px; background: #d32f2f; color: #fff; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; }
        .footer-link { text-align: center; margin-top: 18px; font-size: 14px; color: #555; }
        .footer-link a { color: #d32f2f; text-decoration: none; }
    </style>
</head>
<body>

<div class="main-wrapper">
    <jsp:include page="../components/header.jsp" />

    <div class="login-container">
        <div class="card">
            <h2>Sign In</h2>
            <% if (request.getAttribute("error") != null) { %><div class="alert alert-error"><%= request.getAttribute("error") %></div><% } %>
            <% if (request.getParameter("success") != null) { %><div class="alert alert-success"><%= request.getParameter("success") %></div><% } %>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required>
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
                <button type="submit" class="btn">Login</button>
            </form>
            <p class="footer-link">Don't have an account? <a href="register">Register here</a></p>
        </div>
    </div>

</div>
<jsp:include page="../components/footer.jsp" />

</body>
</html>
