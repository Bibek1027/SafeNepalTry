<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Submit Report - SafeNepal</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: Arial, sans-serif; background: #f0f4f8; }
    .container { max-width: 600px; margin: 50px auto; padding: 0 20px; }
    .form-card { background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    label { display: block; margin-bottom: 8px; font-weight: bold; color: #444; }
    input, select, textarea { width: 100%; padding: 12px; margin-bottom: 20px; border: 1px solid #ccc; border-radius: 4px; font-family: inherit; }
    .btn { width: 100%; padding: 14px; background: #d32f2f; color: #fff; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; font-weight: bold; }
    .alert { padding: 12px; background: #fdecea; color: #b71c1c; border-radius: 4px; margin-bottom: 20px; font-size: 14px; }
  </style>
</head>
<body>

<div class="main-wrapper">
  <jsp:include page="../../components/header.jsp" />

  <div class="container">
    <div class="form-card">
      <h2 style="margin-bottom:25px; text-align:center;">Report a Disaster</h2>
      <% if (request.getAttribute("error") != null) { %><div class="alert"><%= request.getAttribute("error") %></div><% } %>

      <form action="${pageContext.request.contextPath}/user/report" method="post">
        <label>Disaster Type</label>
        <select name="disasterType" required>
          <option value="">-- Select Type --</option>
          <option value="Flood">Flood</option>
          <option value="Earthquake">Earthquake</option>
          <option value="Landslide">Landslide</option>
          <option value="Fire">Fire</option>
          <option value="Other">Other</option>
        </select>

        <label>Location</label>
        <input type="text" name="location" placeholder="City, District, or Landmark" required>

        <label>Description</label>
        <textarea name="description" rows="4" placeholder="Briefly describe the situation..." required></textarea>

        <button type="submit" class="btn">Submit Report</button>
      </form>
    </div>
  </div>

</div>
<jsp:include page="../../components/footer.jsp" />

</body>
</html>
