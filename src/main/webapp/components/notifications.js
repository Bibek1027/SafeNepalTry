// JavaScript for handling notification dropdown
function toggleNotifDropdown(e) {
    e.stopPropagation();
    const dropdown = document.getElementById('notifDropdown');
    const isOpen = dropdown.classList.contains('open');
    dropdown.classList.toggle('open');
    if (!isOpen) loadNotifications();
}

document.addEventListener('click', function(e) {
    const wrap = document.getElementById('notifWrap');
    if (wrap && !wrap.contains(e.target)) {
        document.getElementById('notifDropdown').classList.remove('open');
    }
});

function loadNotifications() {
    const list = document.getElementById('notifDropList');
    if (!list) return;
    
    // The context path will be set by a global variable in header.jsp
    const contextPath = window.snContextPath || '';
    
    list.innerHTML = '<div class="drop-empty">Loading...</div>';

    fetch(contextPath + '/user/notifications/data')
        .then(r => r.json())
        .then(data => {
            if (!data || data.length === 0) {
                list.innerHTML = '<div class="drop-empty">No new notifications</div>';
                return;
            }
            let html = '';
            data.forEach(n => {
                const icon  = n.type === 'Report Update' ? 'R'
                            : n.type === 'Alert'         ? 'A'
                            : n.type === 'System'        ? 'S' : 'N';
                const cls   = n.read ? '' : 'unread';
                const time  = n.createdAt ? n.createdAt.substring(0, 16).replace('T', ' ') : '';
                
                html += '<a href="' + contextPath + '/user/notifications?action=markRead&id=' + n.notificationId + '" class="notif-drop-item ' + cls + '">' +
                    '<div class="drop-icon">' + icon + '</div>' +
                    '<div class="drop-body">' +
                        '<div class="drop-title">' + snSafeText(n.title) + '</div>' +
                        '<div class="drop-msg">' + snSafeText(n.message) + '</div>' +
                        '<div class="drop-time">' + time + '</div>' +
                    '</div>' +
                '</a>';
            });
            list.innerHTML = html;
        })
        .catch(() => {
            list.innerHTML = '<div class="drop-empty">Could not load notifications.</div>';
        });
}

function snSafeText(str) {
    return str ? str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;') : '';
}
