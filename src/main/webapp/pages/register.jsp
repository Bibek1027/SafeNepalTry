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
    <title>Register Page</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>

<div class="main">
    <%
        String errorMessage = (String) request.getAttribute("error");
        if(errorMessage == null){
            errorMessage = "";
        }
    %>
    <%= errorMessage %>

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
            <h2>Register</h2>

            <form action="register" method="post">
                <input type="text" name="fullname" placeholder="Full Name"><br><br>
                <input type="text" name="email" placeholder="Email"><br><br>
                <input type="text" name="phone" placeholder="Phone"><br><br>
                <input type="password" name="password" placeholder="Password"><br><br>

                <button class="btn">Register</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
