<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>404 - Page Not Found | SafeNepal</title>
  <style>
    :root { --primary: #1a237e; --accent: #ff5252; --bg: #f4f7fe; }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Segoe UI', sans-serif;
      background: var(--bg);
      height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #2d3748;
    }
    .container {
      text-align: center;
      background: white;
      padding: 60px 40px;
      border-radius: 20px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.05);
      max-width: 500px;
      width: 90%;
    }
    .error-code {
      font-size: 120px;
      font-weight: 900;
      color: var(--primary);
      line-height: 1;
      margin-bottom: 20px;
      position: relative;
    }
    .error-code::after {
      content: "404";
      position: absolute;
      left: 50%;
      top: 50%;
      transform: translate(-50%, -50%) scale(1.1);
      opacity: 0.1;
    }
    h2 { font-size: 24px; margin-bottom: 16px; color: #1a202c; }
    p { color: #718096; margin-bottom: 32px; line-height: 1.6; }
    .btn-home {
      background: var(--primary);
      color: white;
      text-decoration: none;
      padding: 14px 32px;
      border-radius: 10px;
      font-weight: 700;
      display: inline-block;
      transition: transform 0.2s, opacity 0.2s;
    }
    .btn-home:hover { transform: translateY(-2px); opacity: 0.9; }
    .illustration { font-size: 64px; margin-bottom: 20px; }
  </style>
</head>
<body>
<div class="container">
  <div class="illustration">🧭</div>
  <div class="error-code">404</div>
  <h2>Oops! Page Not Found</h2>
  <p>The page you're looking for doesn't exist or has been moved. Don't worry, we'll help you get back on track.</p>
  <a href="${pageContext.request.contextPath}/user/dashboard" class="btn-home">Return to Dashboard</a>
</div>
</body>
</html>
