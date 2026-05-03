<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<body>
<h2>SafeNepal Debug Info</h2>
<p><strong>Context Path:</strong> <%= request.getContextPath() %></p>
<p><strong>Server Info:</strong> <%= application.getServerInfo() %></p>
<p><strong>Try these links:</strong></p>
<ul>
  <li><a href="user/dashboard">Relative: user/dashboard</a></li>
  <li><a href="<%= request.getContextPath() %>/user/dashboard">Absolute: <%= request.getContextPath() %>/user/dashboard</a></li>
</ul>
</body>
</html>
