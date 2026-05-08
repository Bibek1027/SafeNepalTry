-- ============================================================
-- SafeNepal — SQL setup for Notification + Image Upload features
-- Run this in your MySQL database: safenepal
-- ============================================================

USE safenepal;

-- ── notifications table ──────────────────────────────────────
-- Already exists per the project spec. Run only if it doesn't exist yet.
CREATE TABLE IF NOT EXISTS notifications (
    notification_id INT          AUTO_INCREMENT PRIMARY KEY,
    user_id         INT          NOT NULL,
    title           VARCHAR(200) NOT NULL,
    message         TEXT         NOT NULL,
    type            VARCHAR(50)  NOT NULL,   -- report_approved | report_rejected | new_alert
    is_read         TINYINT(1)   NOT NULL DEFAULT 0,
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ── report_images table ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS report_images (
    image_id    INT          AUTO_INCREMENT PRIMARY KEY,
    report_id   INT          NOT NULL,
    image_path  VARCHAR(500) NOT NULL,
    uploaded_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (report_id) REFERENCES reports(id) ON DELETE CASCADE
);

-- Verify tables were created:
SHOW TABLES;
