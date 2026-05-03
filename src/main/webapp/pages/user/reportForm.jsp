<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Report — SafeNepal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f5f7fb; min-height: 100vh; display: flex; flex-direction: column; color: #1e293b; }
        .main-wrapper { flex: 1 0 auto; }

        .page-banner {
            background: linear-gradient(135deg, #0d1440 0%, #1a237e 100%);
            padding: 48px 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .page-banner::before {
            content: '';
            position: absolute;
            top: -40%;
            right: -15%;
            width: 350px;
            height: 350px;
            background: radial-gradient(circle, rgba(229,57,53,0.1) 0%, transparent 70%);
            border-radius: 50%;
        }
        .page-banner h1 { font-size: 28px; font-weight: 900; color: #fff; position: relative; z-index: 1; }
        .page-banner p { font-size: 14px; color: rgba(255,255,255,0.55); margin-top: 8px; position: relative; z-index: 1; }

        .form-container {
            max-width: 640px;
            margin: -28px auto 48px;
            padding: 0 24px;
            position: relative;
            z-index: 10;
        }
        .form-card {
            background: #fff;
            border-radius: 24px;
            padding: 40px;
            box-shadow: 0 8px 40px rgba(0,0,0,0.06);
            border: 1px solid rgba(0,0,0,0.04);
        }

        .alert {
            padding: 12px 16px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 24px;
            background: #fef2f2;
            color: #991b1b;
            border: 1px solid #fecaca;
            animation: fadeIn 0.3s ease;
        }
        .alert-success {
            background: #f0fdf4;
            color: #166534;
            border: 1px solid #bbf7d0;
        }

        .form-group { margin-bottom: 22px; }
        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #475569;
            margin-bottom: 8px;
            letter-spacing: 0.2px;
        }
        .form-group label .required { color: #e53935; }

        .form-group select,
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 13px 16px;
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            font-size: 14px;
            font-family: 'Inter', sans-serif;
            color: #1e293b;
            background: #f8fafc;
            transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
            outline: none;
            -webkit-appearance: none;
        }
        .form-group select {
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%2394a3b8' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 16px center;
            padding-right: 40px;
        }
        .form-group textarea { resize: vertical; min-height: 110px; line-height: 1.6; }
        .form-group select:focus,
        .form-group input:focus,
        .form-group textarea:focus {
            border-color: #1a237e;
            box-shadow: 0 0 0 3px rgba(26,35,126,0.08);
            background: #fff;
        }

        .disaster-types {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
            gap: 10px;
        }
        .disaster-type-option {
            position: relative;
        }
        .disaster-type-option input { display: none; }
        .disaster-type-option label {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
            padding: 16px 8px;
            border: 1.5px solid #e2e8f0;
            border-radius: 14px;
            cursor: pointer;
            transition: all 0.2s;
            background: #f8fafc;
            font-size: 12px;
            font-weight: 600;
            color: #64748b;
            text-align: center;
        }
        .disaster-type-option label .icon { font-size: 24px; }
        .disaster-type-option input:checked + label {
            border-color: #1a237e;
            background: #e8eaf6;
            color: #1a237e;
            box-shadow: 0 2px 8px rgba(26,35,126,0.12);
        }

        .btn-submit {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #e53935, #c62828);
            color: #fff;
            border: none;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 700;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.25s ease;
            margin-top: 8px;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(229,57,53,0.3);
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #64748b;
        }
        .back-link a {
            color: #1a237e;
            font-weight: 700;
            text-decoration: none;
        }
        .back-link a:hover { color: #e53935; }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-4px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
<div class="main-wrapper">
    <jsp:include page="../../components/header.jsp" />

    <div class="page-banner">
        <h1>🚨 Report a Disaster</h1>
        <p>Help your community by providing accurate information about emergencies</p>
    </div>

    <div class="form-container">
        <div class="form-card">
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert">⚠️ <%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success">✅ <%= request.getAttribute("success") %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/user/report" method="post">
                <div class="form-group">
                    <label>Disaster Type <span class="required">*</span></label>
                    <div class="disaster-types">
                        <div class="disaster-type-option">
                            <input type="radio" id="flood" name="disasterType" value="Flood" required>
                            <label for="flood"><span class="icon">🌊</span>Flood</label>
                        </div>
                        <div class="disaster-type-option">
                            <input type="radio" id="earthquake" name="disasterType" value="Earthquake">
                            <label for="earthquake"><span class="icon">🌍</span>Earthquake</label>
                        </div>
                        <div class="disaster-type-option">
                            <input type="radio" id="landslide" name="disasterType" value="Landslide">
                            <label for="landslide"><span class="icon">⛰️</span>Landslide</label>
                        </div>
                        <div class="disaster-type-option">
                            <input type="radio" id="fire" name="disasterType" value="Fire">
                            <label for="fire"><span class="icon">🔥</span>Fire</label>
                        </div>
                        <div class="disaster-type-option">
                            <input type="radio" id="other" name="disasterType" value="Other">
                            <label for="other"><span class="icon">⚠️</span>Other</label>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="location">Location <span class="required">*</span></label>
                    <input type="text" id="location" name="location" placeholder="City, District, or Landmark (e.g. Kathmandu, Ward 10)" required>
                </div>

                <div class="form-group">
                    <label for="description">Description <span class="required">*</span></label>
                    <textarea id="description" name="description" placeholder="Describe the situation — what's happening, how severe, any immediate dangers or needs..." required></textarea>
                </div>

                <button type="submit" class="btn-submit">📤 Submit Report</button>
            </form>

            <p class="back-link"><a href="${pageContext.request.contextPath}/user/dashboard">← Back to My Reports</a></p>
        </div>
    </div>
</div>
<jsp:include page="../../components/footer.jsp" />
</body>
</html>
