<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  boolean isLoggedInHeader = (session != null && session.getAttribute("userId") != null);
  String userNameHeader = isLoggedInHeader ? (String) session.getAttribute("userName") : null;
  String userRoleHeader = isLoggedInHeader ? (String) session.getAttribute("role") : null;
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
  @media (max-width: 600px) {
    .sn-nav { padding: 0 16px; }
    .sn-nav-links a { padding: 6px 10px; font-size: 12px; }
  }
</style>
<nav class="sn-nav">
  <a href="${pageContext.request.contextPath}/index.jsp" class="brand">
    <span>🛡️</span> SAFENEPAL
  </a>
  <div class="sn-nav-links">
    <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
    <% if (isLoggedInHeader) { %>
      <% if ("admin".equals(userRoleHeader)) { %>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-accent">Admin Panel</a>
      <% } else { %>
        <a href="${pageContext.request.contextPath}/user/report">Report</a>
        <a href="${pageContext.request.contextPath}/user/profile">My Profile</a>
      <% } %>
      <span class="nav-greeting">Hi, <%= userNameHeader %></span>
      <a href="${pageContext.request.contextPath}/logout" class="btn-nav">Logout</a>
    <% } else { %>
      <a href="${pageContext.request.contextPath}/login" class="btn-nav-outline">Login</a>
      <a href="${pageContext.request.contextPath}/register" class="btn-nav">Join Now</a>
    <% } %>
  </div>
</nav>
