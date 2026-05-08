<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.safenepal.notification.model.Notification" %>
<%@ page import="com.safenepal.notification.model.dao.NotificationDAO" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
    int unreadCount = request.getAttribute("unreadCount") != null ? (int) request.getAttribute("unreadCount") : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Notifications — SafeNepal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f5f7fb; min-height: 100vh; display: flex; flex-direction: column; color: #1e293b; }
        .main-wrapper { flex: 1 0 auto; }

        .page-banner {
            background: linear-gradient(135deg, #0d1440 0%, #1a237e 100%);
            padding: 48px 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .page-banner::before {
            content: '';
            position: absolute;
            top: -40%;
            right: -15%;
            width: 350px;
            height: 350px;
            background: radial-gradient(circle, rgba(229,57,53,0.1) 0%, transparent 70%);
            border-radius: 50%;
        }
        .page-banner h1 { font-size: 28px; font-weight: 900; color: #fff; position: relative; z-index: 1; }
        .page-banner p  { font-size: 14px; color: rgba(255,255,255,0.55); margin-top: 8px; position: relative; z-index: 1; }

        .container {
            max-width: 720px;
            margin: -28px auto 48px;
            padding: 0 24px;
            position: relative;
            z-index: 10;
        }

        .actions-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }
        .actions-bar span { font-size: 13px; color: #64748b; font-weight: 500; }
        .btn-mark-all {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 18px;
            background: #1a237e;
            color: #fff;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-mark-all:hover { background: #0d1440; transform: translateY(-1px); }

        .notif-card {
            background: #fff;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 4px 24px rgba(0,0,0,0.04);
            border: 1px solid rgba(0,0,0,0.04);
        }

        .notif-item {
            display: flex;
            align-items: flex-start;
            gap: 16px;
            padding: 20px 24px;
            border-bottom: 1px solid #f1f5f9;
            transition: background 0.2s;
            position: relative;
        }
        .notif-item:last-child { border-bottom: none; }
        .notif-item:hover { background: #fafbff; }
        .notif-item.unread { background: #f0f4ff; }
        .notif-item.unread:hover { background: #e8eeff; }

        .notif-icon {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            flex-shrink: 0;
        }
        .icon-approved  { background: #e8f5e9; }
        .icon-rejected  { background: #ffebee; }
        .icon-alert     { background: #fff3e0; }
        .icon-default   { background: #f1f5f9; }

        .notif-body { flex: 1; }
        .notif-title {
            font-size: 14px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 4px;
        }
        .notif-msg {
            font-size: 13px;
            color: #64748b;
            line-height: 1.5;
        }
        .notif-time {
            font-size: 11px;
            color: #94a3b8;
            margin-top: 6px;
            font-weight: 500;
        }

        .notif-actions { display: flex; align-items: center; gap: 8px; flex-shrink: 0; }
        .btn-read {
            padding: 5px 12px;
            border-radius: 8px;
            font-size: 11px;
            font-weight: 700;
            color: #1a237e;
            background: #e8eaf6;
            text-decoration: none;
            transition: all 0.2s;
            white-space: nowrap;
        }
        .btn-read:hover { background: #c5cae9; }

        .unread-dot {
            width: 8px;
            height: 8px;
            background: #e53935;
            border-radius: 50%;
            flex-shrink: 0;
            margin-top: 6px;
        }

        .empty-state {
            text-align: center;
            padding: 64px 20px;
        }
        .empty-state .icon { font-size: 56px; margin-bottom: 16px; }
        .empty-state h3 { font-size: 18px; font-weight: 700; color: #475569; margin-bottom: 8px; }
        .empty-state p  { font-size: 14px; color: #94a3b8; }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-4px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .notif-item { animation: fadeIn 0.25s ease both; }
    </style>
</head>
<body>
<div class="main-wrapper">
    <jsp:include page="../../components/app-header.jsp" />

    <div class="page-banner">
        <h1>My Notifications</h1>
        <p>Stay updated on your reports and emergency alerts</p>
    </div>

    <div class="container">

        <div class="actions-bar">
            <span>
                <% if (unreadCount > 0) { %>
                    <strong><%= unreadCount %></strong> unread notification<%= unreadCount == 1 ? "" : "s" %>
                <% } else { %>
                    All caught up!
                <% } %>
            </span>
            <% if (unreadCount > 0) { %>
            <a href="${pageContext.request.contextPath}/user/notifications?action=markAllRead" class="btn-mark-all">
                ✓ Mark all as read
            </a>
            <% } %>
        </div>

        <div class="notif-card">
            <% if (notifications == null || notifications.isEmpty()) { %>
            <div class="empty-state">
                <div class="icon">N</div>
                <h3>No Notifications Yet</h3>
                <p>You'll see updates here when admins review your reports or publish new alerts.</p>
            </div>
            <% } else {
                for (Notification n : notifications) {
                    String iconClass = "icon-default";
                    String iconEmoji = "N";
                    if ("Report Update".equals(n.getType())) { iconClass = "icon-approved"; iconEmoji = "R"; }
                    else if ("Alert".equals(n.getType())) { iconClass = "icon-alert"; iconEmoji = "A"; }
                    else if ("System".equals(n.getType())) { iconClass = "icon-default"; iconEmoji = "S"; }
            %>
            <div class="notif-item <%= n.isRead() ? "" : "unread" %>">
                <div class="notif-icon <%= iconClass %>"><%= iconEmoji %></div>
                <div class="notif-body">
                    <div class="notif-title"><%= n.getTitle() %></div>
                    <div class="notif-msg"><%= n.getMessage() %></div>
                    <div class="notif-time">
                        <%= n.getCreatedAt() != null ? n.getCreatedAt().toString().substring(0, 16).replace("T", " ") : "" %>
                    </div>
                </div>
                <div class="notif-actions">
                    <% if (!n.isRead()) { %>
                        <div class="unread-dot"></div>
                        <a href="${pageContext.request.contextPath}/user/notifications?action=markRead&id=<%= n.getNotificationId() %>"
                           class="btn-read">Mark read</a>
                    <% } %>
                </div>
            </div>
            <% } } %>
        </div>

    </div>
</div>
<jsp:include page="../../components/footer.jsp" />
</body>
</html>
