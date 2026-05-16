<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.safenepal.report.model.Report" %>
<%
    // Session guard — admin only
    if (session == null || session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String adminName = (String) session.getAttribute("userName");

    Integer pendingReports  = (Integer) request.getAttribute("pendingReports");
    Integer approvedReports = (Integer) request.getAttribute("approvedReports");
    Integer totalUsers      = (Integer) request.getAttribute("totalUsers");
    Integer totalAlerts     = (Integer) request.getAttribute("totalAlerts");

    pendingReports  = (pendingReports != null) ? pendingReports : 0;
    approvedReports = (approvedReports != null) ? approvedReports : 0;
    totalUsers      = (totalUsers != null) ? totalUsers : 0;
    totalAlerts     = (totalAlerts != null) ? totalAlerts : 0;

    List<Report> recentReports = (List<Report>) request.getAttribute("recentReports");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — SafeNepal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f5f7fb; color: #1e293b; display: flex; min-height: 100vh; }

        /* ── Sidebar ── */
        .sidebar {
            width: 270px;
            background: linear-gradient(180deg, #0d1440 0%, #1a237e 100%);
            color: #fff;
            display: flex;
            flex-direction: column;
            padding: 28px 0;
            position: fixed;
            height: 100vh;
            box-shadow: 4px 0 24px rgba(13,20,64,0.2);
        }
        .sidebar .brand {
            padding: 0 28px 36px;
            font-size: 20px;
            font-weight: 900;
            display: flex;
            align-items: center;
            gap: 10px;
            letter-spacing: 1px;
        }
        .sidebar .brand span { font-size: 24px; }
        .sidebar nav { flex: 1; }
        .sidebar .nav-link {
            padding: 14px 28px;
            color: rgba(255,255,255,0.55);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 14px;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s;
            border-left: 3px solid transparent;
        }
        .sidebar .nav-link:hover {
            color: #fff;
            background: rgba(255,255,255,0.06);
        }
        .sidebar .nav-link.active {
            color: #fff;
            background: rgba(255,255,255,0.08);
            border-left-color: #e53935;
        }
        .sidebar .nav-link .icon { font-size: 18px; width: 24px; text-align: center; }
        .sidebar .logout {
            margin-top: auto;
            border-top: 1px solid rgba(255,255,255,0.08);
            padding-top: 12px;
        }

        /* ── Main Content ── */
        .main-content { margin-left: 270px; flex: 1; padding: 40px; }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 36px;
        }
        .top-bar h1 { font-size: 26px; font-weight: 900; color: #0d1440; }
        .top-bar .admin-badge {
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 600;
            font-size: 14px;
            color: #64748b;
        }
        .avatar {
            width: 42px; height: 42px;
            background: linear-gradient(135deg, #e53935, #c62828);
            color: #fff;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 16px;
        }

        /* ── Stats ── */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 36px;
        }
        .stat-card {
            background: #fff;
            padding: 28px 24px;
            border-radius: 18px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
            border: 1px solid rgba(0,0,0,0.04);
            transition: transform 0.25s;
        }
        .stat-card:hover { transform: translateY(-4px); }
        .stat-card .icon-box {
            width: 44px; height: 44px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            margin-bottom: 16px;
        }
        .stat-card .value { font-size: 32px; font-weight: 900; color: #0d1440; }
        .stat-card .label { font-size: 13px; font-weight: 600; color: #94a3b8; margin-top: 4px; }
        .bg-orange { background: #fff3e0; }
        .bg-green  { background: #e8f5e9; }
        .bg-blue   { background: #e3f2fd; }
        .bg-purple { background: #f3e5f5; }

        /* ── Section Card ── */
        .section-card {
            background: #fff;
            border-radius: 20px;
            padding: 32px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.04);
            border: 1px solid rgba(0,0,0,0.04);
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 2px solid #f1f5f9;
        }
        .section-header h2 { font-size: 17px; font-weight: 800; }
        .view-all {
            font-size: 13px;
            color: #e53935;
            text-decoration: none;
            font-weight: 700;
            transition: color 0.2s;
        }
        .view-all:hover { color: #1a237e; }

        /* ── Table ── */
        table { width: 100%; border-collapse: collapse; }
        th {
            text-align: left;
            padding: 14px 16px;
            border-bottom: 2px solid #f1f5f9;
            color: #94a3b8;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.8px;
        }
        td { padding: 14px 16px; border-bottom: 1px solid #f8fafc; font-size: 14px; }
        tr:hover td { background: #fafbff; }
        tr:last-child td { border-bottom: none; }

        .status {
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.3px;
        }
        .status-Pending  { background: #fff3e0; color: #ef6c00; }
        .status-Approved { background: #e8f5e9; color: #2e7d32; }
        .status-Rejected { background: #ffebee; color: #c62828; }

        .empty-state { text-align: center; padding: 48px; color: #94a3b8; font-size: 14px; }

        @media (max-width: 1000px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .sidebar { width: 80px; }
            .sidebar .brand span:last-child, .sidebar .nav-link span:last-child { display: none; }
            .main-content { margin-left: 80px; }
        }
    </style>
</head>
<body>
<aside class="sidebar">
    <div class="brand">SAFENEPAL</div>
    <nav>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link active">
            <i class="fas fa-tachometer-alt"></i> <span>Dashboard</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/reports" class="nav-link">
            <i class="fas fa-file-alt"></i> <span>Reports</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="nav-link">
            <i class="fas fa-users"></i> <span>Users</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/alerts" class="nav-link">
            <i class="fas fa-exclamation-triangle"></i> <span>Alerts</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/feedback" class="nav-link">
            <i class="fas fa-comments"></i> <span>Feedback</span>
        </a>
    </nav>
    <div class="logout">
        <a href="${pageContext.request.contextPath}/logout" class="nav-link">
            <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
        </a>
    </div>
</aside>

<main class="main-content">
    <div class="top-bar">
        <h1>Dashboard Overview</h1>
        <div class="admin-badge">
            <span><%= adminName %></span>
            <div class="avatar"><%= adminName.substring(0, 1).toUpperCase() %></div>
        </div>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="icon-box bg-orange">P</div>
            <div class="value"><%= pendingReports %></div>
            <div class="label">Pending Reports</div>
        </div>
        <div class="stat-card">
            <div class="icon-box bg-green">V</div>
            <div class="value"><%= approvedReports %></div>
            <div class="label">Approved Reports</div>
        </div>
        <div class="stat-card">
            <div class="icon-box bg-blue">A</div>
            <div class="value"><%= totalAlerts %></div>
            <div class="label">Active Alerts</div>
        </div>
        <div class="stat-card">
            <div class="icon-box bg-purple">U</div>
            <div class="value"><%= totalUsers %></div>
            <div class="label">Registered Users</div>
        </div>
    </div>

    <div class="section-card">
        <div class="section-header">
            <h2>Recent Disaster Reports</h2>
            <a href="${pageContext.request.contextPath}/admin/reports" class="view-all">View All →</a>
        </div>
        <% if (recentReports == null || recentReports.isEmpty()) { %>
            <div class="empty-state">No reports found in the database.</div>
        <% } else { %>
        <table>
            <thead>
            <tr><th>Reporter</th><th>Type</th><th>Location</th><th>Status</th><th>Date</th></tr>
            </thead>
            <tbody>
            <% int count = 0; for (Report r : recentReports) { if (count++ >= 8) break; %>
            <tr>
                <td><strong><%= r.getReporterName() != null ? r.getReporterName() : "N/A" %></strong></td>
                <td><%= r.getDisasterType() %></td>
                <td style="color:#64748b"><%= r.getLocationName() %></td>
                <td><span class="status status-<%= r.getStatus() %>"><%= r.getStatus() %></span></td>
                <td style="color:#94a3b8; font-size:13px"><%= r.getReportedAt() != null ? r.getReportedAt().toString().substring(0, 10) : "Recently" %></td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
</main>
</body>
</html>

