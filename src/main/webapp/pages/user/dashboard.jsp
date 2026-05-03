<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.safenepal.report.model.Report" %>
<%
  if (session == null || session.getAttribute("userId") == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }
  List<Report> myReports = (List<Report>) request.getAttribute("myReports");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Reports - SafeNepal</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: Arial, sans-serif; background: #f0f4f8; }
    .container { max-width: 900px; margin: 40px auto; padding: 0 20px; }
    .report-card { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 1px 6px rgba(0,0,0,0.1); margin-bottom: 20px; }
    .status { padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; }
    .status-Pending { background: #fff3e0; color: #ff9800; }
    .status-Approved { background: #e8f5e9; color: #4caf50; }
    .btn { padding: 10px 20px; background: #d32f2f; color: #fff; text-decoration: none; border-radius: 4px; display: inline-block; }
  </style>
</head>
<body>

<div class="main-wrapper">
  <jsp:include page="../../components/header.jsp" />

  <div class="container">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:30px;">
      <h2>My Submitted Reports</h2>
      <a href="${pageContext.request.contextPath}/user/report" class="btn">+ New Report</a>
    </div>

    <% if (myReports == null || myReports.isEmpty()) { %>
    <div class="report-card" style="text-align:center; padding:50px;">
      <p>You haven't submitted any reports yet.</p>
    </div>
    <% } else { for (Report r : myReports) { %>
    <div class="report-card">
      <div style="display:flex; justify-content:space-between;">
        <strong><%= r.getDisasterType() %></strong>
        <span class="status status-<%= r.getStatus() %>"><%= r.getStatus() %></span>
      </div>
      <p style="color:#666; margin: 10px 0;"><%= r.getLocation() %></p>
      <p style="font-size:14px;"><%= r.getDescription() %></p>
    </div>
    <% } } %>
  </div>

</div>
<jsp:include page="../../components/footer.jsp" />

</body>
</html>
