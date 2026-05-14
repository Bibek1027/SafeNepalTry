<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List" %>
<%@ page import="com.safenepal.report.model.Report" %>
<%@ page import="com.safenepal.alert.model.Alert" %>
<%@ page import="java.text.SimpleDateFormat" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<%
    Boolean searched = request.getAttribute("searched") != null ? (Boolean) request.getAttribute("searched") : false;
    @SuppressWarnings("unchecked")
    List<Report> reports = (List<Report>) request.getAttribute("reports");
    @SuppressWarnings("unchecked")
    List<Alert> alerts = (List<Alert>) request.getAttribute("alerts");
    if (reports == null) reports = java.util.Collections.emptyList();
    if (alerts == null) alerts = java.util.Collections.emptyList();
    SimpleDateFormat df = new SimpleDateFormat("MMM d, yyyy · HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search disasters — SafeNepal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f5f7fb; min-height: 100vh; display: flex; flex-direction: column; color: #1e293b; }
        .main-wrapper { flex: 1 0 auto; }

        .search-hero {
            background: linear-gradient(135deg, #0d1440 0%, #1a237e 100%);
            padding: 40px 24px 48px;
            position: relative;
            overflow: hidden;
        }
        .search-hero::before {
            content: '';
            position: absolute;
            top: -40%;
            right: -10%;
            width: 360px;
            height: 360px;
            background: radial-gradient(circle, rgba(229,57,53,0.12) 0%, transparent 70%);
            border-radius: 50%;
        }
        .search-inner { max-width: 720px; margin: 0 auto; position: relative; z-index: 1; }
        .search-hero h1 { font-size: 26px; font-weight: 900; color: #fff; margin-bottom: 8px; }
        .search-hero p { font-size: 14px; color: rgba(255,255,255,0.55); margin-bottom: 24px; line-height: 1.5; }

        .search-form {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .search-form input[type="search"] {
            flex: 1;
            min-width: 200px;
            padding: 14px 18px;
            border-radius: 12px;
            border: 1px solid rgba(255,255,255,0.2);
            background: rgba(255,255,255,0.1);
            color: #fff;
            font-size: 15px;
            font-family: inherit;
        }
        .search-form input::placeholder { color: rgba(255,255,255,0.45); }
        .search-form button {
            padding: 14px 24px;
            border-radius: 12px;
            border: none;
            background: #e53935;
            color: #fff;
            font-weight: 800;
            font-size: 14px;
            cursor: pointer;
            font-family: inherit;
            box-shadow: 0 4px 16px rgba(229,57,53,0.35);
        }
        .search-form button:hover { background: #c62828; }

        .hint { margin-top: 14px; font-size: 12px; color: rgba(255,255,255,0.45); }
        .hint strong { color: rgba(255,255,255,0.7); }

        .container { max-width: 960px; margin: -24px auto 48px; padding: 0 24px; position: relative; z-index: 2; }

        .section-card {
            background: #fff;
            border-radius: 20px;
            padding: 28px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.04);
            border: 1px solid rgba(0,0,0,0.04);
            margin-bottom: 22px;
        }
        .section-title {
            font-size: 16px;
            font-weight: 800;
            color: #1e293b;
            margin-bottom: 18px;
            padding-bottom: 14px;
            border-bottom: 2px solid #f1f5f9;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .badge-count {
            background: #1a237e;
            color: #fff;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 50px;
        }

        .alert-item {
            display: flex;
            align-items: flex-start;
            gap: 14px;
            padding: 16px 18px;
            border-radius: 14px;
            margin-bottom: 8px;
            transition: background 0.2s;
        }
        .alert-item:hover { background: #fafbff; }
        .alert-severity {
            padding: 4px 10px;
            border-radius: 8px;
            font-size: 10px;
            font-weight: 800;
            color: #fff;
            white-space: nowrap;
            flex-shrink: 0;
        }
        .sev-Critical { background: linear-gradient(135deg, #d32f2f, #c62828); }
        .sev-High { background: linear-gradient(135deg, #ef6c00, #e65100); }
        .sev-Medium { background: linear-gradient(135deg, #f9a825, #f57f17); }
        .sev-Low { background: linear-gradient(135deg, #2e7d32, #1b5e20); }
        .alert-body { flex: 1; min-width: 0; }
        .alert-type { font-size: 12px; font-weight: 700; color: #1a237e; margin-bottom: 4px; }
        .alert-msg { font-size: 14px; color: #334155; line-height: 1.5; }
        .alert-meta { font-size: 12px; color: #94a3b8; margin-top: 6px; }

        .report-card {
            padding: 18px 20px;
            border-radius: 14px;
            border: 1px solid #f1f5f9;
            margin-bottom: 12px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .report-card:hover { border-color: #e2e8f0; box-shadow: 0 4px 14px rgba(0,0,0,0.04); }
        .report-card h4 { font-size: 15px; font-weight: 800; color: #1e293b; margin-bottom: 6px; }
        .report-card .meta { font-size: 13px; color: #94a3b8; }
        .report-card .desc { font-size: 13px; color: #64748b; margin-top: 10px; line-height: 1.55; }

        .empty-state, .error-box {
            text-align: center;
            padding: 36px 20px;
            color: #94a3b8;
            font-size: 14px;
        }
        .error-box { color: #c62828; font-weight: 600; }
        .empty-state .icon { font-size: 40px; margin-bottom: 12px; display: block; }

        .results-summary {
            font-size: 13px;
            color: #64748b;
            margin-bottom: 16px;
        }
        .results-summary strong { color: #1e293b; }
    </style>
</head>
<body>
<div class="main-wrapper">
    <jsp:include page="../components/app-header.jsp" />

    <div class="search-hero">
        <div class="search-inner">
            <h1><i class="fas fa-search"></i> Search disasters</h1>
            <p>Find official alerts and verified community reports by disaster type, place name, district, or province.</p>
            <form class="search-form" method="get" action="${pageContext.request.contextPath}/search">
                <input type="search" name="q" value="<c:out value='${query}'/>" placeholder="e.g. Flood, Pokhara, Bagmati…" autocomplete="off" maxlength="200">
                <button type="submit">Search</button>
            </form>
            <p class="hint"><strong>Community reports</strong> shown here are admin-approved only.</p>
        </div>
    </div>

    <div class="container">
        <c:if test="${not empty error}">
            <div class="section-card"><div class="error-box"><c:out value="${error}"/></div></div>
        </c:if>

        <% if (Boolean.TRUE.equals(searched)) { %>
            <p class="results-summary">Results for <strong><c:out value="${query}"/></strong> — <%= alerts.size() %> alert(s), <%= reports.size() %> report(s)</p>

            <div class="section-card">
                <div class="section-title">
                    <i class="fas fa-bolt" style="color:#e53935;"></i> Emergency alerts
                    <% if (!alerts.isEmpty()) { %><span class="badge-count"><%= alerts.size() %></span><% } %>
                </div>
                <% if (alerts.isEmpty()) { %>
                    <div class="empty-state"><span class="icon"><i class="fas fa-check-circle"></i></span>No matching alerts.</div>
                <% } else { for (Alert a : alerts) {
                    String sev = a.getSeverity() != null ? a.getSeverity() : "Medium";
                %>
                    <div class="alert-item">
                        <span class="alert-severity sev-<%= sev %>"><%= sev.toUpperCase() %></span>
                        <div class="alert-body">
                            <% if (a.getAlertType() != null && !a.getAlertType().isEmpty()) { %>
                                <div class="alert-type"><%= a.getAlertType() %></div>
                            <% } %>
                            <div class="alert-msg"><%= a.getMessage() %></div>
                            <div class="alert-meta">
                                <i class="fas fa-map-marker-alt"></i> <%= a.getLocationName() != null ? a.getLocationName() : "—" %>
                                <% if (a.getCreatedAt() != null) { %> · <%= df.format(a.getCreatedAt()) %><% } %>
                            </div>
                        </div>
                    </div>
                <% } } %>
            </div>

            <div class="section-card">
                <div class="section-title">
                    <i class="fas fa-file-alt" style="color:#1a237e;"></i> Verified community reports
                    <% if (!reports.isEmpty()) { %><span class="badge-count"><%= reports.size() %></span><% } %>
                </div>
                <% if (reports.isEmpty()) { %>
                    <div class="empty-state"><span class="icon"><i class="fas fa-folder-open"></i></span>No matching approved reports.</div>
                <% } else { for (Report r : reports) { %>
                    <div class="report-card">
                        <h4><%= r.getDisasterType() %></h4>
                        <div class="meta">
                            <i class="fas fa-map-marker-alt"></i> <%= r.getLocationName() != null ? r.getLocationName() : "—" %>
                            <% if (r.getReportedAt() != null) { %> · <%= df.format(r.getReportedAt()) %><% } %>
                        </div>
                        <div class="desc"><%= r.getDescription() %></div>
                    </div>
                <% } } %>
            </div>
        <% } else { %>
            <div class="section-card">
                <div class="empty-state">
                    <span class="icon" style="color:#1a237e;"><i class="fas fa-compass"></i></span>
                    Enter a keyword above to search alerts and approved reports.
                </div>
            </div>
        <% } %>
    </div>
</div>
<jsp:include page="../components/footer.jsp" />
</body>
</html>
