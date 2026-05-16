<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.safenepal.engagement.model.dao.AlertLikeDAO" %>
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
    int likeCount = 0;
    boolean userLiked = false;

    try {
        AlertLikeDAO dao = new AlertLikeDAO();
        likeCount = dao.countByAlertId(alertId);
        if (loggedIn) {
            userLiked = dao.hasUserLiked(alertId, (Integer) session.getAttribute("userId"));
        }
    } catch (Exception e) {
        System.err.println("[alert-like.jsp] alertId=" + alertId + " " + e.getMessage());
    }
%>
<div class="alert-like-bar" id="alert-<%= alertId %>">
    <% if (loggedIn) { %>
    <form method="post" action="${pageContext.request.contextPath}/user/alert/like" class="alert-like-form">
        <input type="hidden" name="alertId" value="<%= alertId %>">
        <input type="hidden" name="redirect" value="<%= redirectPath %>">
        <button type="submit" class="alert-like-btn<%= userLiked ? " liked" : "" %>" title="<%= userLiked ? "Unlike" : "Like" %>">
            <i class="fas fa-heart"></i> <span><%= likeCount %></span>
        </button>
    </form>
    <% } else { %>
    <button type="button" class="alert-like-btn" onclick="showLoginToLikeModal()" title="Log in to like">
        <i class="fas fa-heart"></i> <span><%= likeCount %></span>
    </button>
    <% } %>
</div>
