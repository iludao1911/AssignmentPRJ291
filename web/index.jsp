<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang Chủ - Hệ thống Dược Phẩm</title>
</head>
<body>
    <c:if test="${empty sessionScope.currentEmployee}">
        <c:redirect url="login.jsp" />
    </c:if>
    
    <h1>Chào mừng, <c:out value="${sessionScope.currentEmployee.fullName}" /> (${sessionScope.currentEmployee.role})</h1>
    <p>Bạn đã đăng nhập thành công. Đây là các chức năng quản lý:</p>
    
    <h2>Menu Chức năng</h2>
    <ul>
        <li><a href="medicines?action=list">Quản lý Thuốc (Medicine)</a></li>
        <li><a href="suppliers?action=list">Quản lý Nhà cung cấp (Supplier)</a></li>
        <li><a href="customers?action=list">Quản lý Khách hàng (Customer)</a></li>
        <li><a href="orders?action=list">Quản lý Đơn hàng (Order)</a></li>
        <%-- Các đường dẫn JSP gốc --%>
        <li><a href="login?action=logout">Đăng xuất</a></li>
    </ul>
</body>
</html>