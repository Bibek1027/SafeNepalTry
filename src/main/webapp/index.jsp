<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.safenepal.report.model.Report" %>
<%@ page import="com.safenepal.alert.model.Alert" %>
<%@ page import="com.safenepal.report.model.dao.ReportDAO" %>
<%@ page import="com.safenepal.alert.model.dao.AlertDAO" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
    <meta name="description" content="SafeNepal — Nepal's community-driven disaster reporting and emergency alert platform. Report emergencies, stay informed, stay safe.">
    <title>SafeNepal — Disaster Reporting & Emergency Alerts</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f5f7fb; min-height: 100vh; display: flex; flex-direction: column; color: #1e293b; }
        .main-wrapper { flex: 1 0 auto; }

        /* ── Hero Section ── */
        .hero {
            background: linear-gradient(135deg, #0d1440 0%, #1a237e 50%, #283593 100%);
            padding: 80px 40px 60px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .hero::before {
            content: '';
            position: absolute;
            top: -60%;
            right: -20%;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(229,57,53,0.12) 0%, transparent 70%);
            border-radius: 50%;
        }
        .hero::after {
            content: '';
            position: absolute;
            bottom: -40%;
            left: -10%;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(66,165,245,0.1) 0%, transparent 70%);
            border-radius: 50%;
        }
        .hero-content { position: relative; z-index: 1; max-width: 720px; margin: 0 auto; }
        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.12);
            padding: 6px 16px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 600;
            color: #ff8a80;
            margin-bottom: 24px;
            backdrop-filter: blur(4px);
        }
        .hero h1 {
            font-size: 42px;
            font-weight: 900;
            color: #fff;
            line-height: 1.2;
            margin-bottom: 16px;
            letter-spacing: -0.5px;
        }
        .hero h1 .accent { color: #ff8a80; }
        .hero p {
            font-size: 16px;
            color: rgba(255,255,255,0.6);
            line-height: 1.7;
            margin-bottom: 36px;
            max-width: 540px;
            margin-left: auto;
            margin-right: auto;
        }
        .hero-actions { display: flex; gap: 14px; justify-content: center; flex-wrap: wrap; }
        .hero-btn {
            padding: 14px 32px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.25s ease;
            cursor: pointer;
            border: none;
            font-family: 'Inter', sans-serif;
        }
        .hero-btn-primary {
            background: #e53935;
            color: #fff;
            box-shadow: 0 4px 20px rgba(229,57,53,0.35);
        }
        .hero-btn-primary:hover {
            background: #c62828;
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(229,57,53,0.4);
        }
        .hero-btn-outline {
            background: transparent;
            color: #fff;
            border: 1.5px solid rgba(255,255,255,0.25);
        }
        .hero-btn-outline:hover {
            border-color: #fff;
            background: rgba(255,255,255,0.06);
        }

        /* ── Stats Strip ── */
        .stats-strip {
            max-width: 1060px;
            margin: -36px auto 0;
            padding: 0 24px;
            position: relative;
            z-index: 10;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        .stat-card {
            background: #fff;
            border-radius: 16px;
            padding: 28px 24px;
            text-align: center;
            box-shadow: 0 8px 32px rgba(0,0,0,0.06);
            border: 1px solid rgba(0,0,0,0.04);
            transition: transform 0.25s ease;
        }
        .stat-card:hover { transform: translateY(-4px); }
        .stat-icon { font-size: 28px; margin-bottom: 10px; }
        .stat-num { font-size: 36px; font-weight: 900; color: #1a237e; }
        .stat-label { font-size: 13px; font-weight: 600; color: #94a3b8; margin-top: 4px; letter-spacing: 0.3px; }

        /* ── Container ── */
        .content-area {
            max-width: 1060px;
            margin: 40px auto;
            padding: 0 24px;
        }

        /* ── Section Cards ── */
        .section-card {
            background: #fff;
            border-radius: 20px;
            padding: 32px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.04);
            border: 1px solid rgba(0,0,0,0.04);
            margin-bottom: 28px;
        }
        .section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 18px;
            font-weight: 800;
            color: #1e293b;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 2px solid #f1f5f9;
        }
        .section-title .badge {
            background: #e53935;
            color: #fff;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 50px;
        }

        /* ── Alert Items ── */
        .alert-item {
            display: flex;
            align-items: flex-start;
            gap: 16px;
            padding: 18px 20px;
            border-radius: 14px;
            margin-bottom: 12px;
            transition: background 0.2s;
        }
        .alert-item:hover { background: #fafbff; }
        .alert-severity {
            padding: 4px 12px;
            border-radius: 8px;
            font-size: 11px;
            font-weight: 800;
            color: #fff;
            white-space: nowrap;
            flex-shrink: 0;
            letter-spacing: 0.5px;
        }
        .sev-Critical { background: linear-gradient(135deg, #d32f2f, #c62828); }
        .sev-High { background: linear-gradient(135deg, #ef6c00, #e65100); }
        .sev-Medium { background: linear-gradient(135deg, #f9a825, #f57f17); }
        .sev-Low { background: linear-gradient(135deg, #2e7d32, #1b5e20); }
        .alert-body { flex: 1; }
        .alert-msg { font-size: 14px; font-weight: 500; color: #334155; line-height: 1.5; }
        .alert-loc { font-size: 12px; font-weight: 600; color: #94a3b8; margin-top: 4px; }
        .no-data { text-align: center; padding: 48px 20px; color: #94a3b8; font-size: 15px; font-weight: 500; }
        .no-data span { font-size: 40px; display: block; margin-bottom: 12px; }

        /* ── Report List ── */
        .report-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 20px;
            border-radius: 12px;
            transition: background 0.2s;
        }
        .report-row:hover { background: #f8fafc; }
        .report-row + .report-row { border-top: 1px solid #f1f5f9; }
        .report-type { font-weight: 700; color: #1e293b; font-size: 14px; }
        .report-loc { color: #94a3b8; font-size: 13px; margin-left: 12px; }
        .report-status {
            padding: 4px 14px;
            border-radius: 50px;
            font-size: 11px;
            font-weight: 700;
        }
        .st-PENDING { background: #fff3e0; color: #ef6c00; }
        .st-APPROVED { background: #e8f5e9; color: #2e7d32; }
        .st-REJECTED { background: #ffebee; color: #c62828; }

        /* ── Modal ── */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(13,20,64,0.65);
            z-index: 9999;
            justify-content: center;
            align-items: center;
            backdrop-filter: blur(6px);
        }
        .modal-overlay.active { display: flex; }
        .modal {
            background: #fff;
            border-radius: 24px;
            padding: 48px 40px;
            max-width: 400px;
            text-align: center;
            box-shadow: 0 24px 60px rgba(0,0,0,0.2);
            animation: modalIn 0.3s ease;
        }
        .modal h3 { font-size: 22px; font-weight: 800; margin-bottom: 8px; }
        .modal p { color: #64748b; font-size: 14px; line-height: 1.6; margin-bottom: 28px; }
        @keyframes modalIn {
            from { opacity: 0; transform: scale(0.92) translateY(10px); }
            to { opacity: 1; transform: scale(1) translateY(0); }
        }
        @media (max-width: 700px) {
            .hero { padding: 48px 20px 40px; }
            .hero h1 { font-size: 28px; }
            .stats-strip { margin-top: -20px; }
        }
    </style>
</head>
<body>
<div class="modal-overlay" id="registerModal">
    <div class="modal">
        <div style="font-size: 52px; margin-bottom: 16px;">W</div>
        <h3>Join SafeNepal</h3>
        <p>You need an account to submit disaster reports. Redirecting you to registration...</p>
        <a href="register" class="hero-btn hero-btn-primary" style="display:inline-block;">Register Now</a>
    </div>
</div>
<div class="main-wrapper">
    <jsp:include page="/components/app-header.jsp" />

    <!-- ═══ Hero ═══ -->
    <section class="hero">
        <div class="hero-content">
            <div class="hero-badge">Real-time disaster alerts for Nepal</div>
            <h1>
                <% if (isLoggedIn) { %>
                    Welcome Back, <span class="accent"><%= userName %></span>
                <% } else { %>
                    Stay Safe. <span class="accent">Stay Informed.</span>
                <% } %>
            </h1>
            <p>Nepal's community-driven platform for disaster reporting and emergency alerts. Report incidents, receive real-time warnings, and help build a more resilient community.</p>
            <form class="hero-search" method="get" action="${pageContext.request.contextPath}/search" style="max-width:520px;margin:0 auto 20px;display:flex;gap:10px;flex-wrap:wrap;">
                <input type="search" name="q" placeholder="Search alerts &amp; verified reports…" maxlength="200" style="flex:1;min-width:200px;padding:12px 16px;border-radius:10px;border:1px solid rgba(255,255,255,0.25);background:rgba(255,255,255,0.12);color:#fff;font-size:14px;font-family:inherit;">
                <button type="submit" class="hero-btn hero-btn-primary" style="padding:12px 22px;">Search</button>
            </form>
            <div class="hero-actions">
                <% if (isLoggedIn) { %>
                    <a href="user/report" class="hero-btn hero-btn-primary">+ Submit Emergency Report</a>
                    <a href="user/profile" class="hero-btn hero-btn-outline">My Profile</a>
                <% } else { %>
                    <button class="hero-btn hero-btn-primary" onclick="showModal()">Report an Emergency</button>
                    <a href="register" class="hero-btn hero-btn-outline">Create Account</a>
                <% } %>
            </div>
        </div>
    </section>

    <!-- ═══ Stats ═══ -->
    <div class="stats-strip">
        <div class="stat-card">
            <div class="stat-icon">A</div>
            <div class="stat-num"><%= alerts != null ? alerts.size() : 0 %></div>
            <div class="stat-label">Active Alerts</div>
        </div>
        <% if (isLoggedIn) { %>
        <div class="stat-card">
            <div class="stat-icon">R</div>
            <div class="stat-num"><%= totalReports %></div>
            <div class="stat-label">My Submissions</div>
        </div>
        <% } %>
        <div class="stat-card">
            <div class="stat-icon">S</div>
            <div class="stat-num">24/7</div>
            <div class="stat-label">Monitoring Active</div>
        </div>
    </div>

    <div class="content-area">
        <!-- ═══ Emergency Alerts ═══ -->
        <div class="section-card">
            <div class="section-title">
                Emergency Alerts
                <% if (alerts != null && !alerts.isEmpty()) { %><span class="badge"><%= alerts.size() %> active</span><% } %>
            </div>
            <% if (alerts == null || alerts.isEmpty()) { %>
                <div class="no-data"><span>V</span>No active emergency alerts at this time.<br>The community is safe.</div>
            <% } else { for (Alert a : alerts) { %>
                <div class="alert-item">
                    <span class="alert-severity sev-<%= a.getSeverity() %>"><%= a.getSeverity().toUpperCase() %></span>
                    <div class="alert-body">
                        <div class="alert-msg"><%= a.getMessage() %></div>
                        <div class="alert-loc">Location: <%= a.getLocationName() %></div>
                    </div>
                </div>
            <% } } %>
        </div>

        <!-- ═══ My Reports (logged-in only) ═══ -->
        <% if (isLoggedIn) { %>
        <div class="section-card">
            <div class="section-title">My Recent Reports</div>
            <% if (myReports == null || myReports.isEmpty()) { %>
                <div class="no-data"><span>M</span>You haven't submitted any reports yet.<br>Use the button above to report an emergency.</div>
            <% } else { for (Report r : myReports) { %>
                <div class="report-row">
                    <div>
                        <span class="report-type"><%= r.getDisasterType() %></span>
                        <span class="report-loc">Location: <%= r.getLocationName() %></span>
                    </div>
                    <span class="report-status st-<%= r.getStatus().toUpperCase() %>"><%= r.getStatus() %></span>
                </div>
            <% } } %>
        </div>
        <% } %>
    </div>
</div>
<jsp:include page="/components/footer.jsp" />
<script>
    function showModal() {
        document.getElementById('registerModal').classList.add('active');
        setTimeout(() => { window.location.href = 'register'; }, 3500);
    }
    document.getElementById('registerModal').addEventListener('click', function(e) {
        if (e.target === this) this.classList.remove('active');
    });
</script>
</body>
</html>