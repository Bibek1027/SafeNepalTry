<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.safenepal.engagement.model.ReportComment" %>
<%@ page import="com.safenepal.engagement.model.dao.ReportCommentDAO" %>
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
    List<ReportComment> comments = java.util.Collections.emptyList();
    int commentCount = 0;
    SimpleDateFormat df = new SimpleDateFormat("MMM d, yyyy · HH:mm");

    try {
        ReportCommentDAO dao = new ReportCommentDAO();
        comments = dao.getByReportId(reportId);
        commentCount = comments.size();
    } catch (Exception e) {
        System.err.println("[report-comment.jsp] reportId=" + reportId + " " + e.getMessage());
    }
%>
<details class="report-comments" id="report-comments-<%= reportId %>">
    <summary class="report-comments-summary">
        <i class="fas fa-comment"></i> Comments (<%= commentCount %>)
    </summary>
    <div class="report-comments-body">
        <% if (comments.isEmpty()) { %>
            <p class="report-comments-empty">No comments yet.</p>
        <% } else {
            for (ReportComment c : comments) {
                String author = c.getUserName() != null ? c.getUserName() : "User";
                String text = c.getBody() != null ? c.getBody() : "";
                text = text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
        %>
            <div class="report-comment-item">
                <div class="report-comment-head">
                    <strong><%= author %></strong>
                    <% if (c.getCreatedAt() != null) { %>
                        <span class="report-comment-time"><%= df.format(c.getCreatedAt()) %></span>
                    <% } %>
                </div>
                <p class="report-comment-text"><%= text %></p>
            </div>
        <% } } %>

        <% if (loggedIn) { %>
        <form method="post" action="${pageContext.request.contextPath}/user/report/comment" class="report-comment-form">
            <input type="hidden" name="reportId" value="<%= reportId %>">
            <input type="hidden" name="redirect" value="<%= redirectPath %>">
            <textarea name="body" rows="2" maxlength="2000" placeholder="Write a comment…" required></textarea>
            <button type="submit" class="report-comment-submit">Post comment</button>
        </form>
        <% } else { %>
            <p class="report-comments-login">
                <a href="${pageContext.request.contextPath}/login">Log in</a> to comment.
            </p>
        <% } %>
    </div>
</details>
