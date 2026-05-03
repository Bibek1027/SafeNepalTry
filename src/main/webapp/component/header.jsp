<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    boolean isLoggedInHeader = (session != null && session.getAttribute("userId") != null);
    String userNameHeader = isLoggedInHeader ? (String) session.getAttribute("userName") : null;
    String userRoleHeader = isLoggedInHeader ? (String) session.getAttribute("role") : null;
%>
<nav style="background: #1a237e; color: #fff; display: flex; justify-content: space-between; align-items: center; padding: 15px 30px; font-family: 'Segoe UI', sans-serif; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
    <div class="brand" style="font-size: 22px; font-weight: 800; cursor: pointer; letter-spacing: 1px;" onclick="window.location.href='${pageContext.request.contextPath}/index.jsp'">
        🛡️ SAFENEPAL
    </div>
    <div style="display: flex; align-items: center; gap: 20px;">
        <a href="${pageContext.request.contextPath}/index.jsp" style="color: #fff; text-decoration: none; font-size: 14px; font-weight: 600;">HOME</a>
        <% if (isLoggedInHeader) { %>
        <% if ("admin".equals(userRoleHeader)) { %>
        <a href="${pageContext.request.contextPath}/admin/dashboard" style="color: #ff5252; text-decoration: none; font-size: 14px; font-weight: 800;">ADMIN PANEL</a>
        <% } %>
        <span style="font-size: 14px; color: #e0e0e0;">Hi, <%= userNameHeader %></span>
        <a href="${pageContext.request.contextPath}/logout" style="background: #ff5252; color: #fff; padding: 6px 15px; border-radius: 4px; text-decoration: none; font-size: 13px; font-weight: 700;">LOGOUT</a>
        <% } else { %>
        <a href="${pageContext.request.contextPath}/login" style="color: #fff; text-decoration: none; font-size: 14px; font-weight: 600;">LOGIN</a>
        <a href="${pageContext.request.contextPath}/register" style="background: #fff; color: #1a237e; padding: 6px 15px; border-radius: 4px; text-decoration: none; font-size: 13px; font-weight: 700;">JOIN NOW</a>
        <% } %>
    </div>
</nav>
