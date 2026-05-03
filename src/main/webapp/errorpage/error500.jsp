<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Server Error | SafeNepal</title>
  <style>
    :root { --primary: #1a237e; --accent: #ff5252; --bg: #f4f7fe; }
    body { font-family: 'Segoe UI', sans-serif; background: var(--bg); height: 100vh; display: flex; align-items: center; justify-content: center; color: #2d3748; }
    .container { text-align: center; background: white; padding: 60px 40px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); max-width: 500px; }
    h2 { font-size: 24px; margin-bottom: 16px; color: #1a202c; }
    p { color: #718096; margin-bottom: 32px; line-height: 1.6; }
    .btn-home { background: var(--primary); color: white; text-decoration: none; padding: 14px 32px; border-radius: 10px; font-weight: 700; display: inline-block; }
  </style>
</head>
<body>
<div class="container">
  <div style="font-size: 64px; margin-bottom: 20px;">🛠️</div>
  <h2 style="color:var(--accent)">Something Went Wrong</h2>
  <p>Our servers are having a bit of trouble. We've been notified and are working to fix it. Please try again in a few minutes.</p>
  <a href="${pageContext.request.contextPath}/user/dashboard" class="btn-home">Back to Safety</a>
</div>
</body>
</html>
