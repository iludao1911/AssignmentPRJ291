<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<header>
    <nav>
        <div class="logo">
            <a href="${pageContext.request.contextPath}/">Pharmacy Store</a>
        </div>
        
        <div class="menu">
            <a href="${pageContext.request.contextPath}/products">Sản phẩm</a>
            
            <c:choose>
                <c:when test="${sessionScope.role == 'Admin'}">
                    <a href="${pageContext.request.contextPath}/admin/action/dashboard">Quản trị</a>
                    <a href="${pageContext.request.contextPath}/admin/action/products">Quản lý SP</a>
                    <a href="${pageContext.request.contextPath}/admin/action/users">Quản lý Users</a>
                    <a href="${pageContext.request.contextPath}/admin/action/suppliers">Quản lý Nhà cung cấp</a>
                    <a href="${pageContext.request.contextPath}/admin/action/orders">Đơn hàng</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a>
                    <a href="${pageContext.request.contextPath}/orders">Đơn hàng của tôi</a>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="user-menu">
            <c:choose>
                <c:when test="${not empty sessionScope.currentCustomer}">
                    <span>Xin chào, ${sessionScope.currentCustomer.name}</span>
                    <a href="${pageContext.request.contextPath}/profile">Tài khoản</a>
                    <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>
</header>
<!-- Global toast CSS & JS -->
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
        pointer-events: none; /* allow clicks through gaps */
    }
    .toast {
        pointer-events: auto;
        min-width: 260px;
        max-width: 420px;
        background: #fff;
        color: #0f172a;
        padding: 12px 16px;
        border-radius: 10px;
        box-shadow: 0 6px 18px rgba(2,6,23,0.2);
        display: flex;
        gap: 12px;
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
        font-size: 20px;
        line-height: 1;
        margin-top: 2px;
    }
    .toast .toast-body {
        flex: 1;
    }
    .toast .toast-title {
        font-weight: 600;
        margin-bottom: 4px;
        font-size: 14px;
    }
    .toast .toast-message {
        font-size: 13px;
        color: #334155;
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
            var container = ensureContainer();
            var toast = document.createElement('div');
            toast.className = 'toast ' + type;

            var icon = document.createElement('div');
            icon.className = 'toast-icon';
            // simple icons using emoji for reliability
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
            // show with animation
            requestAnimationFrame(function(){ toast.classList.add('show'); });

            // auto hide after 3s
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