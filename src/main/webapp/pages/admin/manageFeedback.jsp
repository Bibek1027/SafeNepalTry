<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.safenepal.feedback.model.Feedback" %>
<%
  if (session == null || session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }
  List<Feedback> allFeedback = (List<Feedback>) request.getAttribute("allFeedback");
  Double avgRating = (Double) request.getAttribute("avgRating");
  Integer totalFeedback = (Integer) request.getAttribute("totalFeedback");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Feedback — SafeNepal Admin</title>
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

    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 20px;
      margin-bottom: 32px;
    }
    .stat-card {
      background: #fff;
      border-radius: 16px;
      padding: 24px;
      text-align: center;
      box-shadow: 0 4px 24px rgba(0,0,0,0.04);
      border: 1px solid rgba(0,0,0,0.04);
    }
    .stat-number {
      font-size: 36px;
      font-weight: 900;
      color: #1a237e;
      margin-bottom: 8px;
    }
    .stat-label {
      font-size: 13px;
      color: #64748b;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .section-card { background: #fff; border-radius: 20px; padding: 32px; box-shadow: 0 4px 24px rgba(0,0,0,0.04); border: 1px solid rgba(0,0,0,0.04); }
    .alert-msg { padding: 12px 16px; border-radius: 12px; margin-bottom: 24px; font-size: 13px; font-weight: 600; background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; animation: fadeIn 0.3s ease; }
    .alert-error { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }

    table { width: 100%; border-collapse: collapse; }
    th { text-align: left; padding: 14px 16px; border-bottom: 2px solid #f1f5f9; color: #94a3b8; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.8px; }
    td { padding: 14px 16px; border-bottom: 1px solid #f8fafc; font-size: 14px; }
    tr:hover td { background: #fafbff; }
    tr:last-child td { border-bottom: none; }

    .user-info { font-weight: 700; color: #1e293b; }
    .user-email { font-size: 13px; color: #64748b; margin-top: 2px; }
    .feedback-message { 
      max-width: 300px; 
      line-height: 1.5;
      color: #374151;
    }
    .rating-stars { 
      display: flex; 
      gap: 2px; 
      color: #d1d5db; 
      font-size: 14px;
    }
    .rating-stars .empty { color: #d1d5db; }
    .rating-stars .active { color: #fbbf24; }
    .date { font-size: 12px; color: #94a3b8; font-weight: 500; }

    .btn-action { padding: 6px 14px; border-radius: 8px; text-decoration: none; font-size: 12px; font-weight: 700; color: #fff; transition: all 0.2s; display: inline-block; }
    .btn-delete { background: #ef4444; }
    .btn-delete:hover { background: #dc2626; transform: translateY(-1px); }

    .empty-state {
      text-align: center;
      padding: 48px 32px;
      color: #94a3b8;
    }
    .empty-state h4 {
      font-size: 18px;
      font-weight: 700;
      margin-bottom: 8px;
    }

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
    <a href="${pageContext.request.contextPath}/admin/users" class="nav-link"><i class="fas fa-users"></i> <span>Users</span></a>
    <a href="${pageContext.request.contextPath}/admin/alerts" class="nav-link"><i class="fas fa-exclamation-triangle"></i> <span>Alerts</span></a>
    <a href="${pageContext.request.contextPath}/admin/feedback" class="nav-link active"><i class="fas fa-comments"></i> <span>Feedback</span></a>
  </nav>
  <div class="logout"><a href="${pageContext.request.contextPath}/logout" class="nav-link"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a></div>
</aside>

<main class="main-content">
  <h1 class="page-title">Feedback Management</h1>
  
  <!-- Statistics -->
  <div class="stats-grid">
    <div class="stat-card">
      <div class="stat-number"><%= totalFeedback != null ? totalFeedback : 0 %></div>
      <div class="stat-label">Total Feedback</div>
    </div>
    <div class="stat-card">
      <div class="stat-number"><%= avgRating != null ? String.format("%.1f", avgRating) : "0.0" %></div>
      <div class="stat-label">Average Rating</div>
    </div>
  </div>

  <div class="section-card">
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert-msg alert-error">Error: <%= request.getAttribute("error") %></div>
    <% } %>
    <% if (request.getParameter("msg") != null) { %>
      <div class="alert-msg">Success: <%= request.getParameter("msg") %></div>
    <% } %>

    <% if (allFeedback == null || allFeedback.isEmpty()) { %>
      <div class="empty-state">
        <h4>No Feedback Yet</h4>
        <p>Users haven't submitted any feedback yet.</p>
      </div>
    <% } else { %>
      <table>
        <thead>
          <tr>
            <th>User</th>
            <th>Feedback</th>
            <th>Rating</th>
            <th>Date</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <% for (Feedback feedback : allFeedback) { %>
          <tr>
            <td>
              <div class="user-info">User #<%= feedback.getUserId() %></div>
              <div class="user-email">ID: <%= feedback.getUserId() %></div>
            </td>
            <td>
              <div class="feedback-message">
                <%= feedback.getMessage() %>
              </div>
            </td>
            <td>
              <div class="rating-stars">
                <% for (int i = 1; i <= 5; i++) { %>
                  <i class="fas fa-star <%= i <= feedback.getRating() ? "active" : "empty" %>"></i>
                <% } %>
                <span style="margin-left: 8px; color: #64748b; font-size: 12px;">(<%= feedback.getRating() %>/5)</span>
              </div>
            </td>
            <td>
              <div class="date">
                <%= feedback.getCreatedAt() != null ? feedback.getCreatedAt().toString().substring(0, 10) : "" %>
              </div>
            </td>
            <td>
              <form action="${pageContext.request.contextPath}/admin/feedback" method="post" style="display:inline;" 
                    onsubmit="return confirm('Delete this feedback?')">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="<%= feedback.getFeedbackId() %>">
                <button type="submit" class="btn-action btn-delete">Delete</button>
              </form>
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
