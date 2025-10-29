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