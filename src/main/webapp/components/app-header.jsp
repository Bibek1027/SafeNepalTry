<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Version 1.1 - Force Recompile --%>
<%@ page import="com.safenepal.notification.model.dao.NotificationDAO" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<%
  boolean isLoggedInHeader = (session != null && session.getAttribute("userId") != null);
  String userNameHeader = isLoggedInHeader ? (String) session.getAttribute("userName") : null;
  String userRoleHeader = isLoggedInHeader ? (String) session.getAttribute("role") : null;

  // Fetch unread notification count for the bell badge (users only)
  int headerUnreadCount = 0;
  if (isLoggedInHeader && "user".equals(userRoleHeader)) {
      try {
          int headerUserId = (int) session.getAttribute("userId");
          headerUnreadCount = new NotificationDAO().countUnread(headerUserId);
      } catch (Exception ignored) {}
  }
%>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
  .sn-nav {
    background: linear-gradient(135deg, #0d1440 0%, #1a237e 100%);
    padding: 0 40px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: 68px;
    font-family: 'Inter', sans-serif;
    position: sticky;
    top: 0;
    z-index: 1000;
    box-shadow: 0 4px 20px rgba(13,20,64,0.3);
  }
  .sn-nav .brand {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 20px;
    font-weight: 900;
    color: #fff;
    text-decoration: none;
    letter-spacing: 1.2px;
  }
  .sn-nav .brand span { font-size: 24px; }
  .sn-nav-links {
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .sn-nav-links a {
    color: rgba(255,255,255,0.8);
    text-decoration: none;
    font-size: 13px;
    font-weight: 600;
    padding: 8px 16px;
    border-radius: 8px;
    transition: all 0.2s ease;
    letter-spacing: 0.4px;
  }
  .sn-nav-links a:hover {
    color: #fff;
    background: rgba(255,255,255,0.1);
  }
  .sn-nav-links .nav-accent {
    color: #ff8a80;
    font-weight: 700;
  }
  .sn-nav-links .nav-accent:hover {
    color: #fff;
    background: rgba(255,138,128,0.15);
  }
  .sn-nav-links .nav-greeting {
    color: rgba(255,255,255,0.6);
    font-size: 13px;
    font-weight: 500;
    padding: 8px 4px;
  }
  .sn-nav-links .btn-nav {
    background: #e53935;
    color: #fff !important;
    padding: 8px 20px;
    border-radius: 8px;
    font-weight: 700;
    font-size: 12px;
    letter-spacing: 0.5px;
    transition: all 0.2s ease;
    box-shadow: 0 2px 8px rgba(229,57,53,0.3);
  }
  .sn-nav-links .btn-nav:hover {
    background: #c62828;
    transform: translateY(-1px);
    box-shadow: 0 4px 14px rgba(229,57,53,0.4);
  }
  .sn-nav-links .btn-nav-outline {
    background: transparent;
    border: 1.5px solid rgba(255,255,255,0.35);
    color: #fff !important;
    padding: 7px 20px;
    font-weight: 700;
    font-size: 12px;
  }
  .sn-nav-links .btn-nav-outline:hover {
    border-color: #fff;
    background: rgba(255,255,255,0.08);
  }

  /* ── Notification Bell ── */
  .notif-bell-wrap {
    position: relative;
    display: inline-flex;
    align-items: center;
  }
  .notif-bell {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 38px;
    height: 38px;
    border-radius: 10px;
    cursor: pointer;
    color: rgba(255,255,255,0.85);
    font-size: 18px;
    transition: all 0.2s;
    background: rgba(255,255,255,0.06);
    border: 1px solid rgba(255,255,255,0.1);
    position: relative;
    text-decoration: none;
  }
  .notif-bell:hover {
    background: rgba(255,255,255,0.14);
    color: #fff;
  }
  .notif-badge {
    position: absolute;
    top: -5px;
    right: -5px;
    background: #e53935;
    color: #fff;
    font-size: 9px;
    font-weight: 800;
    min-width: 17px;
    height: 17px;
    border-radius: 50px;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0 4px;
    border: 2px solid #1a237e;
    line-height: 1;
    animation: bellPop 0.3s ease;
  }
  @keyframes bellPop {
    from { transform: scale(0.4); opacity: 0; }
    to   { transform: scale(1);   opacity: 1; }
  }

  /* ── Dropdown ── */
  .notif-dropdown {
    display: none;
    position: absolute;
    top: calc(100% + 10px);
    right: 0;
    width: 320px;
    background: #fff;
    border-radius: 16px;
    box-shadow: 0 12px 40px rgba(13,20,64,0.2);
    border: 1px solid rgba(0,0,0,0.06);
    z-index: 5000;
    overflow: hidden;
    animation: dropIn 0.2s ease;
  }
  .notif-dropdown.open { display: block; }
  @keyframes dropIn {
    from { opacity: 0; transform: translateY(-8px); }
    to   { opacity: 1; transform: translateY(0); }
  }
  .notif-drop-header {
    padding: 14px 18px 10px;
    border-bottom: 1px solid #f1f5f9;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .notif-drop-header strong {
    font-size: 13px;
    font-weight: 800;
    color: #0d1440;
  }
  .notif-drop-header a {
    font-size: 11px;
    font-weight: 700;
    color: #1a237e;
    text-decoration: none;
  }
  .notif-drop-header a:hover { color: #e53935; }
  .notif-drop-list { max-height: 280px; overflow-y: auto; }
  .notif-drop-item {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    padding: 13px 18px;
    border-bottom: 1px solid #f8fafc;
    transition: background 0.15s;
    text-decoration: none;
    color: inherit;
  }
  .notif-drop-item:last-child { border-bottom: none; }
  .notif-drop-item:hover { background: #f5f7ff; }
  .notif-drop-item.unread { background: #f0f4ff; }
  .notif-drop-item.unread:hover { background: #e8eeff; }
  .drop-icon {
    font-size: 18px;
    width: 32px;
    height: 32px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    background: #f1f5f9;
  }
  .drop-body { flex: 1; min-width: 0; }
  .drop-title { font-size: 12px; font-weight: 700; color: #1e293b; margin-bottom: 2px; }
  .drop-msg   { font-size: 11px; color: #64748b; line-height: 1.4; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
  .drop-time  { font-size: 10px; color: #94a3b8; margin-top: 2px; }
  .notif-drop-footer {
    padding: 10px 18px;
    border-top: 1px solid #f1f5f9;
    text-align: center;
  }
  .notif-drop-footer a {
    font-size: 12px;
    font-weight: 700;
    color: #1a237e;
    text-decoration: none;
  }
  .notif-drop-footer a:hover { color: #e53935; }
  .drop-empty {
    text-align: center;
    padding: 28px 16px;
    font-size: 13px;
    color: #94a3b8;
  }

  @media (max-width: 600px) {
    .sn-nav { padding: 0 16px; }
    .sn-nav-links a { padding: 6px 10px; font-size: 12px; }
    .notif-dropdown { width: 280px; right: -40px; }
  }
</style>

<nav class="sn-nav">
  <a href="${pageContext.request.contextPath}/index.jsp" class="brand">
    SAFENEPAL
  </a>
  <div class="sn-nav-links">
    <a href="${pageContext.request.contextPath}/index.jsp"><i class="fas fa-home"></i></a>
    <a href="${pageContext.request.contextPath}/search"><i class="fas fa-search"></i> Search</a>
    <% if (isLoggedInHeader) { %>
      <% if ("admin".equals(userRoleHeader)) { %>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-accent"><i class="fas fa-shield-alt"></i> Admin Panel</a>
      <% } else { %>
        <a href="${pageContext.request.contextPath}/user/report"><i class="fas fa-file-alt"></i> Report</a>
        <a href="${pageContext.request.contextPath}/user/feedback"><i class="fas fa-comments"></i> Feedback</a>
        <a href="${pageContext.request.contextPath}/user/profile"><i class="fas fa-user-circle"></i> Profile</a>

        <!-- Notification Bell -->
        <div class="notif-bell-wrap" id="notifWrap">
          <a href="javascript:void(0)" class="notif-bell" id="notifBell" onclick="toggleNotifDropdown(event)" title="Notifications">
            <i class="fas fa-bell"></i>
            <% if (headerUnreadCount > 0) { %>
              <span class="notif-badge" id="notifBadge"><%= headerUnreadCount > 9 ? "9+" : headerUnreadCount %></span>
            <% } %>
          </a>
          <div class="notif-dropdown" id="notifDropdown">
            <div class="notif-drop-header">
              <strong>Notifications</strong>
              <% if (headerUnreadCount > 0) { %>
                <a href="${pageContext.request.contextPath}/user/notifications?action=markAllRead">Mark all read</a>
              <% } %>
            </div>
            <div class="notif-drop-list" id="notifDropList">
              <div class="drop-empty">Loading...</div>
            </div>
            <div class="notif-drop-footer">
              <a href="${pageContext.request.contextPath}/user/notifications">View all notifications →</a>
            </div>
          </div>
        </div>

      <% } %>
      <span class="nav-greeting">Hi, <%= userNameHeader %></span>
      <a href="${pageContext.request.contextPath}/logout" class="btn-nav">Logout</a>
    <% } else { %>
      <a href="${pageContext.request.contextPath}/login" class="btn-nav-outline">Login</a>
      <a href="${pageContext.request.contextPath}/register" class="btn-nav">Join Now</a>
    <% } %>
  </div>
</nav>

<script>
  window.snContextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/components/notifications.js"></script>
