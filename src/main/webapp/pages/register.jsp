<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Create a SafeNepal account to report disasters and receive emergency alerts.">
    <title>Register — SafeNepal</title>
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
            max-width: 920px;
            width: 100%;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 16px 64px rgba(0,0,0,0.08);
            background: #fff;
        }
        .auth-left {
            width: 360px;
            flex-shrink: 0;
            background: linear-gradient(135deg, #0d1440 0%, #1a237e 100%);
            padding: 60px 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            color: #fff;
            position: relative;
            overflow: hidden;
        }
        .auth-left::before {
            content: '';
            position: absolute;
            bottom: -20%;
            left: -30%;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(229,57,53,0.12) 0%, transparent 70%);
            border-radius: 50%;
        }
        .auth-left .icon-big { font-size: 64px; margin-bottom: 24px; }
        .auth-left h2 { font-size: 26px; font-weight: 900; margin-bottom: 14px; line-height: 1.2; }
        .auth-left p { font-size: 14px; color: rgba(255,255,255,0.6); line-height: 1.7; }
        .auth-left .steps { margin-top: 36px; list-style: none; counter-reset: step; }
        .auth-left .steps li {
            font-size: 13px;
            color: rgba(255,255,255,0.7);
            padding: 10px 0;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 500;
        }
        .step-num {
            width: 28px;
            height: 28px;
            background: rgba(255,255,255,0.1);
            border: 1.5px solid rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 800;
            flex-shrink: 0;
        }

        .auth-right {
            flex: 1;
            padding: 48px 48px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .auth-right h2 { font-size: 24px; font-weight: 800; color: #1e293b; margin-bottom: 6px; }
        .auth-right .subtitle { font-size: 14px; color: #94a3b8; margin-bottom: 28px; }

        .alert {
            padding: 12px 16px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 20px;
            animation: fadeIn 0.3s ease;
            background: #fef2f2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-group { margin-bottom: 18px; }
        .form-group.full { grid-column: 1 / -1; }
        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #475569;
            margin-bottom: 7px;
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
            background: linear-gradient(135deg, #e53935, #c62828);
            color: #fff;
            border: none;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 700;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.25s ease;
            margin-top: 4px;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(229,57,53,0.3);
        }

        .footer-link {
            text-align: center;
            margin-top: 22px;
            font-size: 14px;
            color: #64748b;
        }
        .footer-link a { color: #1a237e; font-weight: 700; text-decoration: none; }
        .footer-link a:hover { color: #e53935; }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-4px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @media (max-width: 700px) {
            .auth-left { display: none; }
            .auth-right { padding: 36px 24px; }
            .form-row { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="main-wrapper">
    <jsp:include page="../components/header.jsp" />

    <div class="auth-page">
        <div class="auth-container">
            <div class="auth-left">
                <div class="icon-big">🤝</div>
                <h2>Join the SafeNepal Community</h2>
                <p>Help us build a more resilient Nepal by reporting disasters and sharing emergency information.</p>
                <ol class="steps">
                    <li><span class="step-num">1</span> Create your free account</li>
                    <li><span class="step-num">2</span> Report disasters in your area</li>
                    <li><span class="step-num">3</span> Receive real-time alerts</li>
                    <li><span class="step-num">4</span> Help your community stay safe</li>
                </ol>
            </div>
            <div class="auth-right">
                <h2>Create Account</h2>
                <p class="subtitle">Fill in your details to get started</p>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert">⚠️ <%= request.getAttribute("error") %></div>
                <% } %>

                <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" name="fullName" placeholder="Your full name"
                               value="<%= request.getAttribute("fullName")!=null?request.getAttribute("fullName"):"" %>" required>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" placeholder="you@example.com"
                                   value="<%= request.getAttribute("email")!=null?request.getAttribute("email"):"" %>" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="text" id="phone" name="phone" placeholder="98XXXXXXXX"
                                   value="<%= request.getAttribute("phone")!=null?request.getAttribute("phone"):"" %>" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" id="password" name="password" placeholder="Min. 6 characters" required>
                        </div>
                        <div class="form-group">
                            <label for="confirmPassword">Confirm Password</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter password" required>
                        </div>
                    </div>
                    <button type="submit" class="btn-submit">Create Account</button>
                </form>
                <p class="footer-link">Already have an account? <a href="login">Sign in</a></p>
            </div>
        </div>
    </div>
</div>
<jsp:include page="../components/footer.jsp" />
</body>
</html>
