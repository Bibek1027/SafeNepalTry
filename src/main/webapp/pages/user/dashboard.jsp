<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.safenepal.report.model.Report" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String userName = (String) session.getAttribute("userName");
    List<Report> myReports = (List<Report>) request.getAttribute("myReports");
    int reportCount = (myReports != null) ? myReports.size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reports — SafeNepal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f5f7fb; min-height: 100vh; display: flex; flex-direction: column; color: #1e293b; }
        .main-wrapper { flex: 1 0 auto; }

        .page-banner {
            background: linear-gradient(135deg, #0d1440 0%, #1a237e 100%);
            padding: 48px 40px 56px;
            position: relative;
            overflow: hidden;
        }
        .page-banner::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(229,57,53,0.1) 0%, transparent 70%);
            border-radius: 50%;
        }
        .banner-content {
            max-width: 960px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .banner-content h1 { font-size: 28px; font-weight: 900; color: #fff; }
        .banner-content p { font-size: 14px; color: rgba(255,255,255,0.55); margin-top: 6px; }
        .btn-new-report {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 14px 28px;
            background: #e53935;
            color: #fff;
            border-radius: 12px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            transition: all 0.25s;
            box-shadow: 0 4px 16px rgba(229,57,53,0.3);
        }
        .btn-new-report:hover {
            background: #c62828;
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(229,57,53,0.4);
        }

        .container { max-width: 960px; margin: -28px auto 48px; padding: 0 24px; position: relative; z-index: 10; }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 28px;
        }
        .mini-stat {
            background: #fff;
            border-radius: 16px;
            padding: 24px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
            border: 1px solid rgba(0,0,0,0.04);
        }
        .mini-stat .num { font-size: 32px; font-weight: 900; color: #1a237e; }
        .mini-stat .lbl { font-size: 12px; font-weight: 600; color: #94a3b8; margin-top: 4px; letter-spacing: 0.3px; }

        .section-card {
            background: #fff;
            border-radius: 20px;
            padding: 32px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.04);
            border: 1px solid rgba(0,0,0,0.04);
        }
        .section-title {
            font-size: 17px;
            font-weight: 800;
            color: #1e293b;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 2px solid #f1f5f9;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .report-card {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            padding: 20px 24px;
            border-radius: 14px;
            transition: background 0.2s;
            margin-bottom: 4px;
        }
        .report-card:hover { background: #f8fafc; }
        .report-card + .report-card { border-top: 1px solid #f1f5f9; }
        .report-info h4 { font-size: 15px; font-weight: 700; color: #1e293b; margin-bottom: 6px; }
        .report-info .meta { font-size: 13px; color: #94a3b8; display: flex; align-items: center; gap: 8px; }
        .report-info .desc { font-size: 13px; color: #64748b; margin-top: 8px; line-height: 1.5; }
        .report-right { text-align: right; flex-shrink: 0; margin-left: 20px; }
        .status-pill {
            display: inline-block;
            padding: 5px 14px;
            border-radius: 50px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.3px;
        }
        .st-Pending { background: #fff3e0; color: #ef6c00; }
        .st-Approved { background: #e8f5e9; color: #2e7d32; }
        .st-Rejected { background: #ffebee; color: #c62828; }

        .empty-state {
            text-align: center;
            padding: 56px 20px;
        }
        .empty-state .icon { font-size: 48px; margin-bottom: 16px; }
        .empty-state h3 { font-size: 18px; font-weight: 700; color: #475569; margin-bottom: 8px; }
        .empty-state p { font-size: 14px; color: #94a3b8; }

        @media (max-width: 700px) {
            .banner-content { flex-direction: column; gap: 16px; text-align: center; }
            .stats-row { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="main-wrapper">
    <jsp:include page="../../components/app-header.jsp" />

    <div class="page-banner">
        <div class="banner-content">
            <div>
                <h1>📋 My Reports</h1>
                <p>Track the status of all your submitted disaster reports</p>
            </div>
            <a href="${pageContext.request.contextPath}/user/report" class="btn-new-report">+ New Report</a>
        </div>
    </div>

    <div class="container">
        <div class="stats-row">
            <div class="mini-stat">
                <div class="num"><%= reportCount %></div>
                <div class="lbl">Total Reports</div>
            </div>
            <div class="mini-stat">
                <div class="num">
                    <% int pending = 0; if (myReports != null) for (Report r : myReports) if ("Pending".equals(r.getStatus())) pending++; %><%= pending %>
                </div>
                <div class="lbl">Pending Review</div>
            </div>
            <div class="mini-stat">
                <div class="num">
                    <% int approved = 0; if (myReports != null) for (Report r : myReports) if ("Approved".equals(r.getStatus())) approved++; %><%= approved %>
                </div>
                <div class="lbl">Approved</div>
            </div>
        </div>

        <div class="section-card">
            <div class="section-title">📄 Submitted Reports</div>

            <% if (myReports == null || myReports.isEmpty()) { %>
                <div class="empty-state">
                    <div class="icon"><i class="fas fa-file-alt"></i></div>
                    <h3>No Reports Yet</h3>
                    <p>You haven't submitted any disaster reports. Click "New Report" to get started.</p>
                </div>
            <% } else { for (Report r : myReports) { %>
                <div class="report-card">
                    <div class="report-info">
                        <h4><%= r.getDisasterType() %></h4>
                        <div class="meta">
                            <span>📍 <%= r.getLocationName() %></span>
                        </div>
                        <div class="desc"><%= r.getDescription() %></div>
                    </div>
                    <div class="report-right">
                        <span class="status-pill st-<%= r.getStatus() %>"><%= r.getStatus() %></span>
                    </div>
                </div>
            <% } } %>
        </div>
    </div>
</div>
<jsp:include page="../../components/footer.jsp" />
</body>
</html>
