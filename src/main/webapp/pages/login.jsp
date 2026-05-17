<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Log in to SafeNepal to report disasters and receive emergency alerts.">
    <title>Login — SafeNepal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f5f7fb; min-height: 100vh; display: flex; flex-direction: column; }
        .main-wrapper { flex: 1 0 auto; }

        .auth-page {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: calc(100vh - 68px - 200px);
            padding: 48px 24px;
        }
        .auth-container {
            display: flex;
            max-width: 880px;
            width: 100%;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 16px 64px rgba(0,0,0,0.08);
            background: #fff;
        }

        /* Left — Illustration Panel */
        .auth-left {
            flex: 1;
            background: linear-gradient(135deg, #0d1440 0%, #1a237e 100%);
            padding: 60px 48px;
            display: flex;
            flex-direction: column;
            color: #fff;
            position: relative;
            overflow: hidden;
        }
        .auth-left::before {
            content: '';
            position: absolute;
            top: -30%;
            right: -30%;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(229,57,53,0.15) 0%, transparent 70%);
            border-radius: 50%;
        }
        .auth-left .icon-big { font-size: 64px; margin-bottom: 24px; }
        .auth-left .logo-img {
            height: 80px;
            width: auto;
            object-fit: contain;
            margin-bottom: 24px;
        }
        .auth-left h2 { font-size: 28px; font-weight: 900; margin-bottom: 14px; line-height: 1.2; }
        .auth-left p { font-size: 14px; color: rgba(255,255,255,0.6); line-height: 1.7; max-width: 280px; }
        .auth-left .feature-list { margin-top: 32px; list-style: none; }
        .auth-left .feature-list li {
            font-size: 13px;
            color: rgba(255,255,255,0.7);
            padding: 8px 0;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
        }
        .auth-left .feature-list li span { font-size: 16px; }

        /* Right — Form Panel */
        .auth-right {
            flex: 1;
            padding: 56px 48px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .auth-right h2 {
            font-size: 24px;
            font-weight: 800;
            color: #1e293b;
            margin-bottom: 6px;
        }
        .auth-right .subtitle {
            font-size: 14px;
            color: #94a3b8;
            margin-bottom: 32px;
        }

        .alert {
            padding: 12px 16px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
            animation: fadeIn 0.3s ease;
        }
        .alert-error { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
        .alert-success { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }

        .form-group { margin-bottom: 20px; }
        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #475569;
            margin-bottom: 7px;
            letter-spacing: 0.2px;
        }
        .form-group input {
            width: 100%;
            padding: 12px 16px;
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            font-size: 14px;
            font-family: 'Inter', sans-serif;
            color: #1e293b;
            background: #f8fafc;
            transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
            outline: none;
        }
        .form-group input:focus {
            border-color: #1a237e;
            box-shadow: 0 0 0 3px rgba(26,35,126,0.08);
            background: #fff;
        }

        .btn-submit {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #1a237e, #283593);
            color: #fff;
            border: none;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 700;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.25s ease;
            margin-top: 8px;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(26,35,126,0.3);
        }

        .footer-link {
            text-align: center;
            margin-top: 24px;
            font-size: 14px;
            color: #64748b;
        }
        .footer-link a {
            color: #1a237e;
            font-weight: 700;
            text-decoration: none;
            transition: color 0.2s;
        }
        .footer-link a:hover { color: #e53935; }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-4px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @media (max-width: 700px) {
            .auth-left { display: none; }
            .auth-right { padding: 40px 28px; }
        }
    </style>
</head>
<body>
<div class="main-wrapper">
    <jsp:include page="../components/app-header.jsp" />

    <div class="auth-page">
        <div class="auth-container">
            <div class="auth-left">
                <div class="icon-big">
                    <img src="${pageContext.request.contextPath}/assets/images/logo3.png" alt="SafeNepal Logo" style="height: 64px; width: auto; object-fit: contain;">
                </div>
                <h2>Welcome Back to SafeNepal</h2>
                <p>Sign in to your account to manage reports, view alerts, and help keep your community safe.</p>
                <ul class="feature-list">
                    <li>Track your submitted reports</li>
                    <li>Receive real-time alerts</li>
                    <li>Manage your profile</li>
                    <li>Help build a safer Nepal</li>
                </ul>
            </div>
            <div class="auth-right">
                <h2>Sign In</h2>
                <p class="subtitle">Enter your credentials to continue</p>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-error">Error: <%= request.getAttribute("error") %></div>
                <% } %>
                <% if (request.getParameter("suspended") != null) { %>
                    <div class="alert alert-error">Your account has been suspended. Please contact the administrator for assistance.</div>
                <% } %>
                <% if (request.getParameter("success") != null) { %>
                    <div class="alert alert-success">Success: <%= request.getParameter("success") %></div>
                <% } %>

                <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" placeholder="you@example.com"
                               value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" placeholder="Enter your password" required>
                    </div>
                    <button type="submit" class="btn-submit">Sign In</button>
                </form>
                <p class="footer-link">Don't have an account? <a href="register">Create one</a></p>
            </div>
        </div>
    </div>
</div>
<jsp:include page="../components/footer.jsp" />
</body>
</html>
