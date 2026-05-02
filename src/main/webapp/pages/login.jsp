<%--
  Created by IntelliJ IDEA.
  User: ig_beebek
  Date: 4/19/2026
  Time: 9:12 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login Page</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>

<div class="navbar">
    <div>SafeNepal</div>
    <div>
        <a href="dashboard">Dashboard</a>
        <a href="reportForm.jsp">Report</a>
        <a href="alerts.jsp">Alerts</a>
        <a href="logout">Logout</a>
    </div>
</div>

<div class="container">
    <div class="card">
        <h2>Login</h2>

        <form action="login" method="post">
            <input type="text" name="email" placeholder="Email"><br><br>
            <input type="password" name="password" placeholder="Password"><br><br>
            <button class="btn">Login</button>
        </form>

        <p>Don't have account? <a href="register.jsp">Register</a></p>
    </div>
</div>

</body>
</html>
