<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Global Toast Notification System -->
<style>
    /* Toast container */
    #global-toasts {
        position: fixed;
        top: 20px;
        right: 20px;
        display: flex;
        flex-direction: column;
        gap: 12px;
        z-index: 10000;
        pointer-events: none;
    }
    .toast {
        pointer-events: auto;
        min-width: 320px;
        max-width: 480px;
        background: #fff;
        color: #0f172a;
        padding: 16px 20px;
        border-radius: 12px;
        box-shadow: 0 8px 24px rgba(2,6,23,0.25);
        display: flex;
        gap: 14px;
        align-items: flex-start;
        border-left: 6px solid transparent;
        transform: translateX(30px);
        opacity: 0;
        transition: transform 260ms ease, opacity 260ms ease;
    }
    .toast.show {
        transform: translateX(0);
        opacity: 1;
    }
    .toast.hide {
        transform: translateX(30px);
        opacity: 0;
    }
    .toast .toast-icon {
        font-size: 26px;
        line-height: 1;
        margin-top: 2px;
    }
    .toast .toast-body {
        flex: 1;
    }
    .toast .toast-title {
        font-weight: 700;
        margin-bottom: 6px;
        font-size: 16px;
        letter-spacing: -0.01em;
    }
    .toast .toast-message {
        font-size: 14px;
        color: #334155;
        line-height: 1.5;
    }
    .toast.success { border-left-color: #10b981; }
    .toast.warning { border-left-color: #f59e0b; }
    .toast.error   { border-left-color: #ef4444; }
    .toast.info    { border-left-color: #3b82f6; }
    @media (max-width: 480px) {
        #global-toasts { left: 12px; right: 12px; top: 12px; }
        .toast { max-width: none; }
    }
</style>

<script>
    (function(){
        if (window.showToast) return; // Already loaded
        
        function ensureContainer() {
            var c = document.getElementById('global-toasts');
            if (!c) {
                c = document.createElement('div');
                c.id = 'global-toasts';
                document.body.appendChild(c);
            }
            return c;
        }

        window.showToast = function(title, message, type) {
            type = type || 'info';
            
            if (!document.body) {
                console.warn('showToast called before body loaded');
                return;
            }
            
            var container = ensureContainer();
            var toast = document.createElement('div');
            toast.className = 'toast ' + type;

            var icon = document.createElement('div');
            icon.className = 'toast-icon';
            if (type === 'success') icon.textContent = '✅';
            else if (type === 'warning') icon.textContent = '⚠️';
            else if (type === 'error') icon.textContent = '⛔';
            else icon.textContent = 'ℹ️';

            var body = document.createElement('div');
            body.className = 'toast-body';
            var t = document.createElement('div');
            t.className = 'toast-title';
            t.textContent = title || 'Thông báo';
            var m = document.createElement('div');
            m.className = 'toast-message';
            m.textContent = message || '';

            body.appendChild(t);
            body.appendChild(m);
            toast.appendChild(icon);
            toast.appendChild(body);

            container.appendChild(toast);
            requestAnimationFrame(function(){ toast.classList.add('show'); });

            setTimeout(function(){
                toast.classList.remove('show');
                toast.classList.add('hide');
                setTimeout(function(){
                    if (toast.parentNode) toast.parentNode.removeChild(toast);
                }, 300);
            }, 3000);
        };
    })();
</script>
