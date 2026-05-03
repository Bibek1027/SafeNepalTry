<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.safenepal.report.model.Report" %>
<%
  if (session == null || session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }
  List<Report> reports = (List<Report>) request.getAttribute("reports");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Reports — SafeNepal Admin</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
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

    .section-card { background: #fff; border-radius: 20px; padding: 32px; box-shadow: 0 4px 24px rgba(0,0,0,0.04); border: 1px solid rgba(0,0,0,0.04); }
    .alert-msg { padding: 12px 16px; border-radius: 12px; margin-bottom: 24px; font-size: 13px; font-weight: 600; background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; animation: fadeIn 0.3s ease; }

    table { width: 100%; border-collapse: collapse; }
    th { text-align: left; padding: 14px 16px; border-bottom: 2px solid #f1f5f9; color: #94a3b8; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.8px; }
    td { padding: 14px 16px; border-bottom: 1px solid #f8fafc; font-size: 14px; vertical-align: top; }
    tr:hover td { background: #fafbff; }
    tr:last-child td { border-bottom: none; }

    .desc-text { max-width: 260px; color: #64748b; line-height: 1.5; font-size: 13px; }
    .reporter-name { font-weight: 700; }
    .reporter-loc { font-size: 12px; color: #94a3b8; margin-top: 2px; }

    .status { padding: 4px 12px; border-radius: 50px; font-size: 11px; font-weight: 700; letter-spacing: 0.3px; }
    .status-Pending  { background: #fff3e0; color: #ef6c00; }
    .status-Approved { background: #e8f5e9; color: #2e7d32; }
    .status-Rejected { background: #ffebee; color: #c62828; }

    .actions { display: flex; gap: 6px; flex-wrap: wrap; }
    .btn-action { padding: 6px 14px; border-radius: 8px; text-decoration: none; font-size: 12px; font-weight: 700; color: #fff; transition: all 0.2s; display: inline-block; }
    .btn-approve { background: #22c55e; }
    .btn-approve:hover { background: #16a34a; }
    .btn-reject  { background: #f59e0b; }
    .btn-reject:hover  { background: #d97706; }
    .btn-delete  { background: #ef4444; }
    .btn-delete:hover  { background: #dc2626; }
    .btn-action:hover { transform: translateY(-1px); }

    .empty-state { text-align: center; padding: 48px; color: #94a3b8; font-size: 14px; }

    @keyframes fadeIn { from { opacity: 0; transform: translateY(-4px); } to { opacity: 1; transform: translateY(0); } }
    @media (max-width: 1000px) {
      .sidebar { width: 80px; }
      .sidebar .brand span:last-child, .sidebar .nav-link span:last-child { display: none; }
      .main-content { margin-left: 80px; }
    }
  </style>
</head>
<body>
<aside class="sidebar">
  <div class="brand"><span>🛡️</span> <span>SAFENEPAL</span></div>
  <nav>
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link"><span class="icon">📊</span> <span>Dashboard</span></a>
    <a href="${pageContext.request.contextPath}/admin/reports" class="nav-link active"><span class="icon">📋</span> <span>Reports</span></a>
    <a href="${pageContext.request.contextPath}/admin/users" class="nav-link"><span class="icon">👥</span> <span>Users</span></a>
    <a href="${pageContext.request.contextPath}/admin/alerts" class="nav-link"><span class="icon">🔔</span> <span>Alerts</span></a>
  </nav>
  <div class="logout"><a href="${pageContext.request.contextPath}/logout" class="nav-link"><span class="icon">🚪</span> <span>Logout</span></a></div>
</aside>

<main class="main-content">
  <h1 class="page-title">📋 Manage Reports</h1>
  <div class="section-card">
    <% if (request.getParameter("msg") != null) { %><div class="alert-msg">✅ <%= request.getParameter("msg") %></div><% } %>
    <% if (reports == null || reports.isEmpty()) { %>
      <div class="empty-state">No reports currently pending review.</div>
    <% } else { %>
    <table>
      <thead>
      <tr><th>Reporter</th><th>Type</th><th>Description</th><th>Status</th><th>Actions</th></tr>
      </thead>
      <tbody>
      <% for (Report r : reports) { %>
      <tr>
        <td>
          <div class="reporter-name"><%= r.getReporterName() %></div>
          <div class="reporter-loc">📍 <%= r.getLocation() %></div>
        </td>
        <td><%= r.getDisasterType() %></td>
        <td><div class="desc-text"><%= r.getDescription() %></div></td>
        <td><span class="status status-<%= r.getStatus() %>"><%= r.getStatus() %></span></td>
        <td class="actions">
          <% if (!"Approved".equals(r.getStatus())) { %><a href="${pageContext.request.contextPath}/admin/reports?action=approve&id=<%= r.getId() %>" class="btn-action btn-approve">Approve</a><% } %>
          <% if (!"Rejected".equals(r.getStatus())) { %><a href="${pageContext.request.contextPath}/admin/reports?action=reject&id=<%= r.getId() %>" class="btn-action btn-reject">Reject</a><% } %>
          <a href="${pageContext.request.contextPath}/admin/reports?action=delete&id=<%= r.getId() %>" class="btn-action btn-delete" onclick="return confirm('Delete this report permanently?')">Delete</a>
        </td>
      </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>
</main>
</body>
</html>
