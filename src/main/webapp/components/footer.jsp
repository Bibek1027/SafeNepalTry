<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<style>
    html, body { height: 100%; margin: 0; }
    body { display: flex; flex-direction: column; }
    .main-wrapper { flex: 1 0 auto; }
    .sn-footer {
        flex-shrink: 0;
        background: linear-gradient(135deg, #0d1440 0%, #1a237e 100%);
        color: #fff;
        padding: 48px 40px 28px;
        font-family: 'Inter', sans-serif;
    }
    .sn-footer-inner {
        max-width: 1100px;
        margin: 0 auto;
        display: grid;
        grid-template-columns: 2fr 1fr 1fr;
        gap: 40px;
    }
    .sn-footer-brand h3 {
        font-size: 20px;
        font-weight: 900;
        letter-spacing: 1px;
        margin-bottom: 12px;
    }
    .sn-footer-brand p {
        font-size: 13px;
        color: rgba(255,255,255,0.55);
        line-height: 1.7;
        max-width: 320px;
    }
    .sn-footer-col h4 {
        font-size: 13px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
        color: rgba(255,255,255,0.4);
        margin-bottom: 16px;
    }
    .sn-footer-col a {
        display: block;
        color: rgba(255,255,255,0.7);
        text-decoration: none;
        font-size: 14px;
        font-weight: 500;
        padding: 5px 0;
        transition: color 0.2s, padding-left 0.2s;
    }
    .sn-footer-col a:hover {
        color: #ff8a80;
        padding-left: 6px;
    }
    .sn-footer-bottom {
        max-width: 1100px;
        margin: 36px auto 0;
        padding-top: 20px;
        border-top: 1px solid rgba(255,255,255,0.08);
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 12px;
        color: rgba(255,255,255,0.35);
    }
    @media (max-width: 700px) {
        .sn-footer-inner { grid-template-columns: 1fr; gap: 24px; }
        .sn-footer { padding: 32px 20px 20px; }
    }
</style>
<footer class="sn-footer">
    <div class="sn-footer-inner">
        <div class="sn-footer-brand">
            <h3>SAFENEPAL</h3>
            <p>Empowering communities across Nepal with real-time disaster reporting and emergency alerts. Together we build a safer, more resilient nation.</p>
        </div>
        <div class="sn-footer-col">
            <h4>Quick Links</h4>
            <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
            <a href="${pageContext.request.contextPath}/login">Login</a>
            <a href="${pageContext.request.contextPath}/register">Register</a>
        </div>
        <div class="sn-footer-col">
            <h4>Emergency</h4>
            <a href="#">Nepal Police: 100</a>
            <a href="#">Ambulance: 102</a>
            <a href="#">Fire Brigade: 101</a>
        </div>
    </div>
    <div class="sn-footer-bottom">
        <span>&copy; <%= java.time.Year.now().getValue() %> SafeNepal Community</span>
        <span>Built for safety and resilience</span>
    </div>
</footer>
