<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.safenepal.report.model.Report" %>
<%@ page import="com.safenepal.alert.model.Alert" %>
<%@ page import="com.safenepal.report.model.dao.ReportDAO" %>
<%@ page import="com.safenepal.alert.model.dao.AlertDAO" %>
<%
    boolean isLoggedIn = (session != null && session.getAttribute("userId") != null);
    String userName = isLoggedIn ? (String) session.getAttribute("userName") : null;
    List<Report> myReports = null;
    List<Alert>  alerts    = null;
    int totalReports = 0;
    try {
        AlertDAO alertDAO = new AlertDAO();
        alerts = alertDAO.getAllAlerts();
        if (isLoggedIn) {
            int userId = (int) session.getAttribute("userId");
            ReportDAO reportDAO = new ReportDAO();
            myReports = reportDAO.getReportsByUser(userId);
            totalReports = reportDAO.countByUser(userId);
        }
    } catch (Exception e) {}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SafeNepal - Dashboard</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f0f4f8; min-height: 100vh; display: flex; flex-direction: column; }
        .main-wrapper { flex: 1 0 auto; }
        .container { max-width: 1000px; margin: 30px auto; padding: 0 16px; }
        .stat-card { background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); flex: 1; text-align: center; }
        .num { font-size: 36px; font-weight: 800; color: #d32f2f; }
        .alert-item { background: #fff; border-left: 5px solid #d32f2f; padding: 15px; margin-bottom: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); border-radius: 0 8px 8px 0; }
        .btn { display: inline-block; padding: 12px 24px; background: #d32f2f; color: #fff; border-radius: 6px; text-decoration: none; border:none; cursor:pointer; font-weight: 600; transition: background 0.2s; }
        .btn:hover { background: #b71c1c; }
        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 999; justify-content: center; align-items: center; backdrop-filter: blur(4px); }
        .modal-overlay.active { display: flex; }
        .modal { background: #fff; border-radius: 15px; padding: 40px; max-width: 420px; text-align: center; box-shadow: 0 20px 40px rgba(0,0,0,0.2); }
    </style>
</head>
<body>
<div class="modal-overlay" id="registerModal">
    <div class="modal">
        <div style="font-size: 50px; margin-bottom: 15px;">👋</div>
        <h3>Join SafeNepal</h3>
        <p style="color: #666; margin: 15px 0;">You need an account to submit reports. We're taking you to the registration page now.</p>
        <a href="register" class="btn">Register Now</a>
    </div>
</div>
<div class="main-wrapper">
    <jsp:include page="/components/header.jsp" />
    <div class="container">
        <h2 style="margin-bottom: 25px; color: #2c3e50;"><%= isLoggedIn ? "Welcome Back, " + userName : "Public Emergency Alerts" %></h2>
        <div style="display:flex; gap:20px; flex-wrap: wrap; margin-bottom: 30px;">
            <div class="stat-card">
                <div class="num"><%= alerts != null ? alerts.size() : 0 %></div>
                <div style="color: #7f8c8d; font-weight: 600;">Active Alerts</div>
            </div>
            <% if (isLoggedIn) { %>
            <div class="stat-card">
                <div class="num"><%= totalReports %></div>
                <div style="color: #7f8c8d; font-weight: 600;">My Submissions</div>
            </div>
            <% } %>
        </div>
        <div style="background:#fff; padding:25px; border-radius:12px; margin-bottom:30px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
            <h3 style="margin-bottom:20px; border-bottom: 3px solid #d32f2f; padding-bottom: 8px; display: inline-block;">🚨 Recent Alerts</h3>
            <% if (alerts == null || alerts.isEmpty()) { %>
            <p style="color: #95a5a6; font-style: italic;">No active alerts at this time.</p>
            <% } else { for (Alert a : alerts) { %>
            <div class="alert-item">
                <span style="font-weight: 800; color: #d32f2f;"><%= a.getSeverity().toUpperCase() %></span>: <%= a.getMessage() %>
                <br><small style="color: #7f8c8d; font-weight: 600;">📍 <%= a.getLocation() %></small>
            </div>
            <% } } %>
        </div>
        <div style="text-align: center;">
            <% if (isLoggedIn) { %>
            <a href="user/report" class="btn" style="padding: 15px 40px; font-size: 18px;">+ Submit Emergency Report</a>
            <div style="margin-top: 40px; background:#fff; padding:30px; border-radius:12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); text-align: left;">
                <h3 style="margin-bottom:20px; border-bottom: 2px solid #2c3e50; padding-bottom: 8px;">📄 My Recent Reports</h3>
                <% if (myReports == null || myReports.isEmpty()) { %>
                <p style="color: #bdc3c7;">You haven't submitted any reports yet.</p>
                <% } else { for (Report r : myReports) { %>
                <div style="padding: 15px; border-bottom: 1px solid #ecf0f1; display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <strong style="color: #2c3e50;"><%= r.getDisasterType() %></strong> <span style="color: #95a5a6; margin-left: 10px;">📍 <%= r.getLocation() %></span>
                    </div>
                    <span style="font-size: 11px; padding: 4px 12px; border-radius: 20px; background: #f0f4f8; font-weight: 700; color: #34495e;"><%= r.getStatus().toUpperCase() %></span>
                </div>
                <% } } %>
            </div>
            <% } else { %>
            <button class="btn" onclick="showModal()" style="padding: 15px 40px; font-size: 18px;">+ Submit a Report</button>
            <% } %>
        </div>
    </div>
</div>
<jsp:include page="/components/footer.jsp" />
<script>
    function showModal() {
        document.getElementById('registerModal').classList.add('active');
        setTimeout(() => { window.location.href = 'register'; }, 4000);
    }
</script>
</body>
</html>