<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.safenepal.user.model.User" %>
<%
  if (session == null || session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }
  List<User> users = (List<User>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Users — SafeNepal Admin</title>
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

    .section-card { background: #fff; border-radius: 20px; padding: 32px; box-shadow: 0 4px 24px rgba(0,0,0,0.04); border: 1px solid rgba(0,0,0,0.04); }
    .alert-msg { padding: 12px 16px; border-radius: 12px; margin-bottom: 24px; font-size: 13px; font-weight: 600; background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; animation: fadeIn 0.3s ease; }

    table { width: 100%; border-collapse: collapse; }
    th { text-align: left; padding: 14px 16px; border-bottom: 2px solid #f1f5f9; color: #94a3b8; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.8px; }
    td { padding: 14px 16px; border-bottom: 1px solid #f8fafc; font-size: 14px; }
    tr:hover td { background: #fafbff; }
    tr:last-child td { border-bottom: none; }

    .user-name { font-weight: 700; color: #1e293b; }
    .user-contact { font-size: 13px; color: #64748b; margin-top: 2px; }
    .badge { padding: 4px 12px; border-radius: 50px; font-size: 11px; font-weight: 700; letter-spacing: 0.3px; }
    .badge-admin { background: #e8eaf6; color: #3949ab; }
    .badge-user { background: #f3e5f5; color: #7b1fa2; }
    .badge-active { background: #dcfce7; color: #166534; }
    .badge-suspended { background: #fef2f2; color: #dc2626; }
    .joined { font-size: 12px; color: #94a3b8; }

    .btn-action { padding: 6px 14px; border-radius: 8px; text-decoration: none; font-size: 12px; font-weight: 700; color: #fff; transition: all 0.2s; display: inline-block; }
    .btn-suspend { background: #f59e0b; }
    .btn-suspend:hover { background: #d97706; transform: translateY(-1px); }
    .btn-unsuspend { background: #10b981; }
    .btn-unsuspend:hover { background: #059669; transform: translateY(-1px); }
    .btn-delete { background: #ef4444; }
    .btn-delete:hover { background: #dc2626; transform: translateY(-1px); }
    .protected { font-size: 12px; color: #94a3b8; font-weight: 500; font-style: italic; }

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
  <div class="brand">SAFENEPAL</div>
  <nav>
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a>
    <a href="${pageContext.request.contextPath}/admin/reports" class="nav-link"><i class="fas fa-file-alt"></i> <span>Reports</span></a>
    <a href="${pageContext.request.contextPath}/admin/users" class="nav-link active"><i class="fas fa-users"></i> <span>Users</span></a>
    <a href="${pageContext.request.contextPath}/admin/alerts" class="nav-link"><i class="fas fa-exclamation-triangle"></i> <span>Alerts</span></a>
    <a href="${pageContext.request.contextPath}/admin/feedback" class="nav-link"><i class="fas fa-comments"></i> <span>Feedback</span></a>
  </nav>
  <div class="logout"><a href="${pageContext.request.contextPath}/logout" class="nav-link"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a></div>
</aside>

<main class="main-content">
  <h1 class="page-title">User Management</h1>
  <div class="section-card">
    <% if (request.getParameter("msg") != null) { %><div class="alert-msg">Success: <%= request.getParameter("msg") %></div><% } %>
    <table>
      <thead>
      <tr><th>User</th><th>Contact</th><th>Role</th><th>Status</th><th>Joined</th><th>Actions</th></tr>
      </thead>
      <tbody>
      <% if (users != null) { for (User u : users) { %>
      <tr>
        <td><div class="user-name"><%= u.getFullName() %></div></td>
        <td>
          <div style="font-size:13px"><%= u.getEmail() %></div>
          <div class="user-contact"><%= u.getPhone() %></div>
        </td>
        <td><span class="badge badge-<%= u.getRole() %>"><%= u.getRole().toUpperCase() %></span></td>
        <td><span class="badge badge-<%= "suspended".equals(u.getStatus()) ? "suspended" : "active" %>"><%= u.getStatus() != null ? u.getStatus().toUpperCase() : "ACTIVE" %></span></td>
        <td><span class="joined"><%= u.getCreatedAt() != null ? u.getCreatedAt().toString().substring(0, 10) : "—" %></span></td>
        <td>
          <% if (!"admin".equals(u.getRole())) { %>
            <% if ("suspended".equals(u.getStatus())) { %>
              <a href="${pageContext.request.contextPath}/admin/users?action=unsuspend&id=<%= u.getId() %>" class="btn-action btn-unsuspend">Unsuspend</a>
            <% } else { %>
              <a href="${pageContext.request.contextPath}/admin/users?action=suspend&id=<%= u.getId() %>" class="btn-action btn-suspend" onclick="return confirm('Suspend this user? They will not be able to access the system.')">Suspend</a>
            <% } %>
            <a href="${pageContext.request.contextPath}/admin/users?action=delete&id=<%= u.getId() %>" class="btn-action btn-delete" onclick="return confirm('Permanently delete this user?')">Delete</a>
          <% } else { %>
            <span class="protected">Protected</span>
          <% } %>
        </td>
      </tr>
      <% } } %>
      </tbody>
    </table>
  </div>
</main>
</body>
</html>
