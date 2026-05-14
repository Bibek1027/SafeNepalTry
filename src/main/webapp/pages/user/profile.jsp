<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.safenepal.user.model.User" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    User profileUser = (User) request.getAttribute("profileUser");
    String fullName  = profileUser != null ? profileUser.getFullName() : "";
    String email     = profileUser != null ? profileUser.getEmail()    : "";
    String phone     = profileUser != null ? profileUser.getPhone()    : "";
    String createdAt = profileUser != null && profileUser.getCreatedAt() != null
                       ? profileUser.getCreatedAt().toString().substring(0, 10) : "—";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - SafeNepal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f0f4ff 0%, #fafbff 100%);
            min-height: 100vh;
            color: #1e293b;
        }

        /* ── Page Layout ── */
        .page-wrapper { max-width: 860px; margin: 0 auto; padding: 48px 24px 80px; }

        .page-header {
            display: flex;
            align-items: center;
            gap: 18px;
            margin-bottom: 40px;
        }
        .avatar-ring {
            width: 72px; height: 72px;
            border-radius: 50%;
            background: linear-gradient(135deg, #1a237e, #3949ab);
            display: flex; align-items: center; justify-content: center;
            font-size: 30px; font-weight: 800; color: #fff;
            box-shadow: 0 8px 24px rgba(26,35,126,0.3);
            flex-shrink: 0;
        }
        .page-header h1 { font-size: 28px; font-weight: 800; color: #1a237e; }
        .page-header p  { font-size: 14px; color: #64748b; margin-top: 4px; }

        /* ── Cards ── */
        .card {
            background: #fff;
            border-radius: 20px;
            padding: 36px 40px;
            box-shadow: 0 4px 32px rgba(0,0,0,0.07);
            margin-bottom: 28px;
            border: 1px solid rgba(99,102,241,0.08);
        }

        .card-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 28px;
            padding-bottom: 18px;
            border-bottom: 2px solid #f1f5f9;
        }
        .card-icon {
            width: 42px; height: 42px;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 20px;
        }
        .card-icon.blue  { background: #e8eaf6; }
        .card-icon.red   { background: #ffebee; }
        .card-header h2  { font-size: 17px; font-weight: 700; color: #1e293b; }

        /* ── Form Elements ── */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .form-group { display: flex; flex-direction: column; gap: 7px; }
        .form-group.full { grid-column: 1 / -1; }

        label {
            font-size: 13px;
            font-weight: 600;
            color: #475569;
            letter-spacing: 0.3px;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            padding: 11px 14px;
            border: 1.5px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            font-family: 'Inter', sans-serif;
            color: #1e293b;
            background: #f8fafc;
            transition: border-color 0.2s, box-shadow 0.2s;
            outline: none;
        }
        input:focus {
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99,102,241,0.12);
            background: #fff;
        }
        input[readonly] {
            background: #f1f5f9;
            color: #94a3b8;
            cursor: not-allowed;
        }

        /* ── Buttons ── */
        .btn-primary {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 28px;
            background: linear-gradient(135deg, #1a237e, #3949ab);
            color: #fff;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 700;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: transform 0.15s, box-shadow 0.15s;
            margin-top: 8px;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(26,35,126,0.35);
        }
        .btn-danger {
            background: linear-gradient(135deg, #c62828, #e53935);
        }
        .btn-danger:hover {
            box-shadow: 0 6px 20px rgba(198,40,40,0.35);
        }

        /* ── Alerts ── */
        .alert {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 22px;
            animation: fadeIn 0.3s ease;
        }
        .alert-success {
            background: #f0fdf4;
            color: #166534;
            border: 1px solid #bbf7d0;
        }
        .alert-error {
            background: #fef2f2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        /* ── Member-since badge ── */
        .meta-chip {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #f1f5f9;
            border-radius: 20px;
            padding: 5px 14px;
            font-size: 12px;
            font-weight: 600;
            color: #64748b;
            margin-bottom: 28px;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-6px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 600px) {
            .form-grid { grid-template-columns: 1fr; }
            .card { padding: 24px 20px; }
        }
    </style>
</head>
<body>

<div class="main-wrapper">
    <jsp:include page="../../components/app-header.jsp" />

    <div class="page-wrapper">

        <!-- Page Header -->
        <div class="page-header">
            <div class="avatar-ring"><%= fullName.isEmpty() ? "?" : String.valueOf(fullName.charAt(0)).toUpperCase() %></div>
            <div>
                <h1>My Profile</h1>
                <p>Manage your personal information and account security</p>
            </div>
        </div>

        <div class="meta-chip">Member since <%= createdAt %></div>

        <!-- ═══ Card 1: Personal Info ═══ -->
        <div class="card">
            <div class="card-header">
                <div class="card-icon blue">P</div>
                <h2>Personal Information</h2>
            </div>

            <% if (request.getAttribute("profileSuccess") != null) { %>
            <div class="alert alert-success">Success: <%= request.getAttribute("profileSuccess") %></div>
            <% } %>
            <% if (request.getAttribute("profileError") != null) { %>
            <div class="alert alert-error">Error: <%= request.getAttribute("profileError") %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/user/profile" method="post" id="profileForm">
                <input type="hidden" name="action" value="updateProfile">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" name="fullName" value="<%= fullName %>" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" value="<%= email %>" readonly title="Email cannot be changed">
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="text" id="phone" name="phone" value="<%= phone %>" required>
                    </div>
                </div>
                <button type="submit" class="btn-primary">Save Changes</button>
            </form>
        </div>

        <!-- ═══ Card 2: Change Password ═══ -->
        <div class="card">
            <div class="card-header">
                <div class="card-icon red">L</div>
                <h2>Change Password</h2>
            </div>

            <% if (request.getAttribute("passwordSuccess") != null) { %>
            <div class="alert alert-success">Success: <%= request.getAttribute("passwordSuccess") %></div>
            <% } %>
            <% if (request.getAttribute("passwordError") != null) { %>
            <div class="alert alert-error">Error: <%= request.getAttribute("passwordError") %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/user/profile" method="post" id="passwordForm">
                <input type="hidden" name="action" value="changePassword">
                <div class="form-grid">
                    <div class="form-group full">
                        <label for="currentPassword">Current Password</label>
                        <input type="password" id="currentPassword" name="currentPassword" placeholder="Enter your current password" required>
                    </div>
                    <div class="form-group">
                        <label for="newPassword">New Password</label>
                        <input type="password" id="newPassword" name="newPassword" placeholder="At least 6 characters" required>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm New Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter new password" required>
                    </div>
                </div>
                <button type="submit" class="btn-primary btn-danger">Update Password</button>
            </form>
        </div>

    </div>
</div>

<jsp:include page="../../components/footer.jsp" />

</body>
</html>
