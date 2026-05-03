<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<style>
    html, body { height: 100%; margin: 0; }
    body { display: flex; flex-direction: column; }
    .main-wrapper { flex: 1 0 auto; }
    footer { flex-shrink: 0; background: #1a1a1a; color: #fff; padding: 40px 20px; text-align: center; font-family: 'Segoe UI', sans-serif; border-top: 4px solid #1a237e; }
</style>
<footer>
    <div style="margin-bottom: 15px;">
        <span style="color: #fff; font-weight: 800; font-size: 20px; letter-spacing: 1px;">🛡️ SAFENEPAL</span>
    </div>
    <p style="font-size: 13px; color: #888;">&copy; <%= java.time.Year.now().getValue() %> SafeNepal Community. Built for safety and resilience.</p>
</footer>
