<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.safenepal.engagement.model.AlertComment" %>
<%@ page import="com.safenepal.engagement.model.dao.AlertCommentDAO" %>
<%
    String alertIdParam = request.getParameter("alertId");
    String redirectPath = request.getParameter("redirectPath");
    if (redirectPath == null) redirectPath = "/";

    int alertId = 0;
    try {
        alertId = Integer.parseInt(alertIdParam);
    } catch (Exception e) {
        return;
    }

    boolean loggedIn = (session != null && session.getAttribute("userId") != null);
    List<AlertComment> comments = java.util.Collections.emptyList();
    int commentCount = 0;
    SimpleDateFormat df = new SimpleDateFormat("MMM d, yyyy · HH:mm");

    try {
        AlertCommentDAO dao = new AlertCommentDAO();
        comments = dao.getByAlertId(alertId);
        commentCount = comments.size();
    } catch (Exception e) {
        System.err.println("[alert-comment.jsp] alertId=" + alertId + " " + e.getMessage());
    }
%>
<details class="alert-comments" id="alert-comments-<%= alertId %>">
    <summary class="alert-comments-summary">
        <i class="fas fa-comment"></i> Comments (<%= commentCount %>)
    </summary>
    <div class="alert-comments-body">
        <% if (comments.isEmpty()) { %>
            <p class="alert-comments-empty">No comments yet.</p>
        <% } else {
            for (AlertComment c : comments) {
                String author = c.getUserName() != null ? c.getUserName() : "User";
                String text = c.getBody() != null ? c.getBody() : "";
                text = text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
        %>
            <div class="alert-comment-item">
                <div class="alert-comment-head">
                    <strong><%= author %></strong>
                    <% if (c.getCreatedAt() != null) { %>
                        <span class="alert-comment-time"><%= df.format(c.getCreatedAt()) %></span>
                    <% } %>
                </div>
                <p class="alert-comment-text"><%= text %></p>
            </div>
        <% } } %>

        <% if (loggedIn) { %>
        <form method="post" action="${pageContext.request.contextPath}/user/alert/comment" class="alert-comment-form">
            <input type="hidden" name="alertId" value="<%= alertId %>">
            <input type="hidden" name="redirect" value="<%= redirectPath %>">
            <textarea name="body" rows="2" maxlength="2000" placeholder="Write a comment…" required></textarea>
            <button type="submit" class="alert-comment-submit">Post comment</button>
        </form>
        <% } else { %>
            <p class="alert-comments-login">
                <a href="${pageContext.request.contextPath}/login">Log in</a> to comment.
            </p>
        <% } %>
    </div>
</details>
