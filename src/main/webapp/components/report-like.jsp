<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.safenepal.engagement.model.dao.ReportLikeDAO" %>
<%
    String reportIdParam = request.getParameter("reportId");
    String redirectPath = request.getParameter("redirectPath");
    if (redirectPath == null) redirectPath = "/";

    int reportId = 0;
    try {
        reportId = Integer.parseInt(reportIdParam);
    } catch (Exception e) {
        return;
    }

    boolean loggedIn = (session != null && session.getAttribute("userId") != null);
    int likeCount = 0;
    boolean userLiked = false;

    try {
        ReportLikeDAO dao = new ReportLikeDAO();
        likeCount = dao.countByReportId(reportId);
        if (loggedIn) {
            userLiked = dao.hasUserLiked(reportId, (Integer) session.getAttribute("userId"));
        }
    } catch (Exception e) {
        System.err.println("[report-like.jsp] reportId=" + reportId + " " + e.getMessage());
    }
%>
<div class="report-like-bar" id="report-<%= reportId %>">
    <% if (loggedIn) { %>
    <form method="post" action="${pageContext.request.contextPath}/user/report/like" class="report-like-form">
        <input type="hidden" name="reportId" value="<%= reportId %>">
        <input type="hidden" name="redirect" value="<%= redirectPath %>">
        <button type="submit" class="report-like-btn<%= userLiked ? " liked" : "" %>" title="<%= userLiked ? "Unlike" : "Like" %>">
            <i class="fas fa-heart"></i> <span><%= likeCount %></span>
        </button>
    </form>
    <% } else { %>
    <button type="button" class="report-like-btn" onclick="showLoginToLikeModal()" title="Log in to like">
        <i class="fas fa-heart"></i> <span><%= likeCount %></span>
    </button>
    <% } %>
</div>
