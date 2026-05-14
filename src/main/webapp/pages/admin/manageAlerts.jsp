<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.safenepal.alert.model.Alert" %>
<%@ page import="com.safenepal.location.model.Location" %>
<%
    if (session == null || session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Alert> alerts = (List<Alert>) request.getAttribute("alerts");
    List<Location> locationsList = (List<Location>) request.getAttribute("locations");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Public Disaster Alerts — SafeNepal Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f5f7fb; color: #1e293b; display: flex; min-height: 100vh; }
        .sidebar { width: 270px; background: linear-gradient(180deg, #0d1440 0%, #1a237e 100%); color: #fff; display: flex; flex-direction: column; padding: 28px 0; position: fixed; height: 100vh; box-shadow: 4px 0 24px rgba(13,20,64,0.2); }
        .sidebar .brand { padding: 0 28px 36px; font-size: 20px; font-weight: 900; display: flex; align-items: center; gap: 10px; letter-spacing: 1px; }
        .sidebar .brand span { font-size: 24px; }
        .sidebar nav { flex: 1; }
        .sidebar .nav-link { padding: 14px 28px; color: rgba(255,255,255,0.55); text-decoration: none; display: flex; align-items: center; gap: 14px; font-size: 14px; font-weight: 600; transition: all 0.2s; border-left: 3px solid transparent; }
        .sidebar .nav-link:hover { color: #fff; background: rgba(255,255,255,0.06); }
        .sidebar .nav-link.active { color: #fff; background: rgba(255,255,255,0.08); border-left-color: #e53935; }
        .sidebar .nav-link .icon { font-size: 18px; width: 24px; text-align: center; }
        .sidebar .logout { margin-top: auto; border-top: 1px solid rgba(255,255,255,0.08); padding-top: 12px; }

        .main-content { margin-left: 270px; flex: 1; padding: 40px; }
        .page-title { font-size: 26px; font-weight: 900; color: #0d1440; margin-bottom: 32px; }

        /* ── Form Card ── */
        .section-card {
            background: #fff;
            border-radius: 20px;
            padding: 32px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.04);
            border: 1px solid rgba(0,0,0,0.04);
            margin-bottom: 28px;
        }
        .card-title {
            font-size: 17px;
            font-weight: 800;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 2px solid #f1f5f9;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-msg { padding: 12px 16px; border-radius: 12px; margin-bottom: 24px; font-size: 13px; font-weight: 600; background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; animation: fadeIn 0.3s ease; }

        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group { margin-bottom: 20px; }
        .form-group.full { grid-column: 1 / -1; }
        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #475569;
            margin-bottom: 8px;
        }
        .form-group input,
        .form-group select,
        .form-group textarea {
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
        .form-group select {
            -webkit-appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%2394a3b8' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 16px center;
            padding-right: 40px;
        }
        .form-group textarea { resize: none; min-height: 90px; line-height: 1.5; }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: #1a237e;
            box-shadow: 0 0 0 3px rgba(26,35,126,0.08);
            background: #fff;
        }

        .btn-broadcast {
            padding: 13px 28px;
            background: linear-gradient(135deg, #e53935, #c62828);
            color: #fff;
            border: none;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 700;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.25s;
            box-shadow: 0 4px 16px rgba(229,57,53,0.25);
        }
        .btn-broadcast:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(229,57,53,0.35);
        }

        /* ── Table ── */
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 14px 16px; border-bottom: 2px solid #f1f5f9; color: #94a3b8; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.8px; }
        td { padding: 14px 16px; border-bottom: 1px solid #f8fafc; font-size: 14px; }
        tr:hover td { background: #fafbff; }
        tr:last-child td { border-bottom: none; }

        .severity {
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 11px;
            font-weight: 800;
            color: #fff;
            letter-spacing: 0.4px;
        }
        .severity-Critical { background: linear-gradient(135deg, #d32f2f, #c62828); }
        .severity-High     { background: linear-gradient(135deg, #ef6c00, #e65100); }
        .severity-Medium   { background: linear-gradient(135deg, #f9a825, #f57f17); color: #333; }
        .severity-Low      { background: linear-gradient(135deg, #2e7d32, #1b5e20); }

        .msg-text { max-width: 300px; color: #64748b; line-height: 1.5; font-size: 13px; }
        .btn-stop {
            padding: 6px 14px;
            background: #ef4444;
            color: #fff;
            border-radius: 8px;
            text-decoration: none;
            font-size: 12px;
            font-weight: 700;
            transition: all 0.2s;
            display: inline-block;
        }
        .btn-stop:hover { background: #dc2626; transform: translateY(-1px); }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(-4px); } to { opacity: 1; transform: translateY(0); } }
        @media (max-width: 1000px) {
            .sidebar { width: 80px; }
            .sidebar .brand span:last-child, .sidebar .nav-link span:last-child { display: none; }
            .main-content { margin-left: 80px; }
            .form-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<aside class="sidebar">
    <div class="brand">SAFENEPAL</div>
    <nav>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a>
        <a href="${pageContext.request.contextPath}/admin/reports" class="nav-link"><i class="fas fa-file-alt"></i> <span>Reports</span></a>
        <a href="${pageContext.request.contextPath}/admin/users" class="nav-link"><i class="fas fa-users"></i> <span>Users</span></a>
        <a href="${pageContext.request.contextPath}/admin/alerts" class="nav-link active"><i class="fas fa-exclamation-triangle"></i> <span>Alerts</span></a>
        <a href="${pageContext.request.contextPath}/admin/feedback" class="nav-link"><i class="fas fa-comments"></i> <span>Feedback</span></a>
    </nav>
    <div class="logout"><a href="${pageContext.request.contextPath}/logout" class="nav-link"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a></div>
</aside>

<main class="main-content">
    <h1 class="page-title">Public Disaster Alerts</h1>

    <% if (request.getParameter("msg") != null) { %><div class="alert-msg">Success: <%= request.getParameter("msg") %></div><% } %>

    <!-- Issue New Alert -->
    <div class="section-card">
        <div class="card-title">Issue New Alert</div>
        <form action="${pageContext.request.contextPath}/admin/alerts" method="POST">
            <div class="form-grid">
                <div class="form-group">
                    <label>Location</label>
                    <select name="locationId" required>
                        <option value="">-- Select Location --</option>
                        <% if (locationsList != null) { for (Location l : locationsList) { %>
                            <option value="<%= l.getLocationId() %>"><%= l.getLocationName() %> (<%= l.getDistrict() %>)</option>
                        <% } } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Severity Level</label>
                    <select name="severity">
                        <option value="Low">Low</option>
                        <option value="Medium">Medium</option>
                        <option value="High">High</option>
                        <option value="Critical">Critical</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label>Alert Message</label>
                <textarea name="message" placeholder="Detailed instructions for the public..." required></textarea>
            </div>
            <button type="submit" class="btn-broadcast">Broadcast Alert Now</button>
        </form>
    </div>

    <!-- Active Broadcasts -->
    <div class="section-card">
        <div class="card-title">Active Broadcasts</div>
        <table>
            <thead>
            <tr><th>Location</th><th>Message</th><th>Severity</th><th>Action</th></tr>
            </thead>
            <tbody>
            <% if (alerts != null) { for (Alert a : alerts) { %>
            <tr>
                <td><strong><%= a.getLocationName() %></strong></td>
                <td><div class="msg-text"><%= a.getMessage() %></div></td>
                <td><span class="severity severity-<%= a.getSeverity() %>"><%= a.getSeverity().toUpperCase() %></span></td>
                <td><a href="${pageContext.request.contextPath}/admin/alerts?action=delete&id=<%= a.getAlertId() %>" class="btn-stop" onclick="return confirm('Stop this alert broadcast?')">Stop</a></td>
            </tr>
            <% } } %>
            </tbody>
        </table>
    </div>
</main>
</body>
</html>
