<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.safenepal.feedback.model.Feedback" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Feedback> userFeedback = (List<Feedback>) request.getAttribute("userFeedback");
    Double avgRating = (Double) request.getAttribute("avgRating");
    Integer totalFeedback = (Integer) request.getAttribute("totalFeedback");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback — SafeNepal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
        .page-banner p  { font-size: 14px; color: rgba(255,255,255,0.55); margin-top: 8px; position: relative; z-index: 1; }

        .container {
            max-width: 720px;
            margin: -28px auto 48px;
            padding: 0 24px;
            position: relative;
            z-index: 10;
        }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 32px;
        }
        .stat-card {
            background: #fff;
            border-radius: 16px;
            padding: 24px;
            text-align: center;
            box-shadow: 0 4px 24px rgba(0,0,0,0.04);
            border: 1px solid rgba(0,0,0,0.04);
        }
        .stat-number {
            font-size: 32px;
            font-weight: 900;
            color: #1a237e;
            margin-bottom: 8px;
        }
        .stat-label {
            font-size: 13px;
            color: #64748b;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .feedback-card {
            background: #fff;
            border-radius: 20px;
            padding: 32px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.04);
            border: 1px solid rgba(0,0,0,0.04);
            margin-bottom: 32px;
        }
        .feedback-card h2 {
            font-size: 20px;
            font-weight: 800;
            color: #0d1440;
            margin-bottom: 24px;
        }

        .form-group { margin-bottom: 24px; }
        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: 700;
            color: #374151;
            margin-bottom: 8px;
        }
        .form-group textarea {
            width: 100%;
            min-height: 120px;
            padding: 12px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 14px;
            font-family: inherit;
            resize: vertical;
            transition: all 0.2s;
        }
        .form-group textarea:focus {
            outline: none;
            border-color: #1a237e;
            box-shadow: 0 0 0 3px rgba(26,35,126,0.1);
        }

        .rating-group {
            display: flex;
            gap: 12px;
            align-items: center;
        }
        .star-rating {
            display: flex;
            gap: 8px;
        }
        .star {
            font-size: 28px;
            color: #d1d5db;
            cursor: pointer;
            transition: all 0.2s;
        }
        #starRating .star:hover {
            color: #fbbf24;
        }
        #starRating .star.active {
            color: #fbbf24;
            transform: scale(1.1);
        }
        .feedback-rating .star {
            color: #d1d5db;
            cursor: default;
        }
        .feedback-rating .star.active {
            color: #fbbf24;
        }
        .rating-text {
            font-size: 14px;
            color: #64748b;
            font-weight: 500;
        }

        .btn-submit {
            background: linear-gradient(135deg, #1a237e 0%, #0d1440 100%);
            color: #fff;
            border: none;
            padding: 14px 32px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 4px 14px rgba(26,35,126,0.3);
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(26,35,126,0.4);
        }

        .history-section {
            background: #fff;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 4px 24px rgba(0,0,0,0.04);
            border: 1px solid rgba(0,0,0,0.04);
        }
        .history-header {
            padding: 24px 32px;
            border-bottom: 1px solid #f1f5f9;
            background: #f8fafc;
        }
        .history-header h3 {
            font-size: 18px;
            font-weight: 800;
            color: #0d1440;
        }
        .feedback-item {
            padding: 20px 32px;
            border-bottom: 1px solid #f1f5f9;
        }
        .feedback-item:last-child { border-bottom: none; }
        .feedback-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }
        .feedback-rating {
            display: flex;
            gap: 2px;
            color: #d1d5db;
        }
        .feedback-date {
            font-size: 12px;
            color: #94a3b8;
            font-weight: 500;
        }
        .feedback-message {
            font-size: 14px;
            color: #374151;
            line-height: 1.6;
        }
        .empty-state {
            text-align: center;
            padding: 48px 32px;
            color: #94a3b8;
        }
        .empty-state h4 {
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .alert {
            padding: 12px 16px;
            border-radius: 12px;
            margin-bottom: 24px;
            font-size: 13px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            animation: fadeIn 0.3s ease;
        }
        .alert-error { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
        .alert-success { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-4px); }
            to   { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
<div class="main-wrapper">
    <jsp:include page="../../components/app-header.jsp" />

    <div class="page-banner">
        <h1>Feedback</h1>
        <p>Share your experience and help us improve SafeNepal</p>
    </div>

    <div class="container">
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">Error: <%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success">Success: <%= request.getParameter("success") %></div>
        <% } %>

        <!-- Statistics -->
        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-number"><%= totalFeedback != null ? totalFeedback : 0 %></div>
                <div class="stat-label">Total Feedback</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= avgRating != null ? String.format("%.1f", avgRating) : "0.0" %></div>
                <div class="stat-label">Average Rating</div>
            </div>
        </div>

        <!-- Feedback Form -->
        <div class="feedback-card">
            <h2>Submit Your Feedback</h2>
            <form action="${pageContext.request.contextPath}/user/feedback" method="post" id="feedbackForm">
                <div class="form-group">
                    <label for="message">Your Feedback</label>
                    <textarea name="message" id="message" placeholder="Tell us about your experience with SafeNepal..." required></textarea>
                </div>
                
                <div class="form-group">
                    <label>Rating</label>
                    <div class="rating-group">
                        <div class="star-rating" id="starRating">
                            <i class="fas fa-star star" data-rating="1"></i>
                            <i class="fas fa-star star" data-rating="2"></i>
                            <i class="fas fa-star star" data-rating="3"></i>
                            <i class="fas fa-star star" data-rating="4"></i>
                            <i class="fas fa-star star" data-rating="5"></i>
                        </div>
                        <span class="rating-text" id="ratingText">Click to rate</span>
                    </div>
                    <input type="hidden" name="rating" id="ratingValue" value="0" required>
                </div>

                <button type="submit" class="btn-submit">Submit Feedback</button>
            </form>
        </div>

        <!-- Feedback History -->
        <div class="history-section">
            <div class="history-header">
                <h3>Your Feedback History</h3>
            </div>
            <% if (userFeedback == null || userFeedback.isEmpty()) { %>
                <div class="empty-state">
                    <h4>No feedback yet</h4>
                    <p>Be the first to share your thoughts!</p>
                </div>
            <% } else { 
                for (Feedback feedback : userFeedback) { %>
                <div class="feedback-item">
                    <div class="feedback-meta">
                        <div class="feedback-rating">
                            <% for (int i = 1; i <= 5; i++) { %>
                                <i class="fas fa-star star <%= i <= feedback.getRating() ? "active" : "empty" %>"></i>
                            <% } %>
                        </div>
                        <div class="feedback-date">
                            <%= feedback.getCreatedAt() != null ? feedback.getCreatedAt().toString().substring(0, 10) : "" %>
                        </div>
                    </div>
                    <div class="feedback-message">
                        <%= feedback.getMessage() %>
                    </div>
                </div>
            <% } } %>
        </div>
    </div>
</div>
<jsp:include page="../../components/footer.jsp" />

<script>
    // Star rating functionality
    const stars = document.querySelectorAll('#starRating .star');
    const ratingValue = document.getElementById('ratingValue');
    const ratingText = document.getElementById('ratingText');
    const ratingTexts = ['Click to rate', 'Poor', 'Fair', 'Good', 'Very Good', 'Excellent'];

    stars.forEach(star => {
        star.addEventListener('click', function() {
            const rating = parseInt(this.dataset.rating);
            ratingValue.value = rating;
            updateStars(rating);
            ratingText.textContent = ratingTexts[rating];
        });

        star.addEventListener('mouseenter', function() {
            const rating = parseInt(this.dataset.rating);
            updateStars(rating);
            ratingText.textContent = ratingTexts[rating];
        });
    });

    document.getElementById('starRating').addEventListener('mouseleave', function() {
        const currentRating = parseInt(ratingValue.value);
        updateStars(currentRating);
        ratingText.textContent = ratingTexts[currentRating] || ratingTexts[0];
    });

    function updateStars(rating) {
        stars.forEach((star, index) => {
            if (index < rating) {
                star.classList.add('active');
            } else {
                star.classList.remove('active');
            }
        });
    }
</script>
</body>
</html>
