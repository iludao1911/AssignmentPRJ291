<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang Chủ</title>
</head>
<body>
    
    <c:choose>
        <%-- TRƯỜNG HỢP 1: KHÁCH HÀNG ĐĂNG NHẬP (Chuyển hướng đến trang xem thuốc) --%>
        <c:when test="${not empty sessionScope.currentCustomer}">
            <c:redirect url="customers" /> 
        </c:when>

        <%-- TRƯỜNG HỢP 2: EMPLOYEE ĐĂNG NHẬP (Quản lý) --%>
        <c:when test="${not empty sessionScope.currentEmployee}">
            <h1>Chào mừng, <c:out value="${sessionScope.currentEmployee.fullName}" /> (Quản lý)</h1>
            <h2>Menu Chức năng Quản lý</h2>
            <ul>
                <li><a href="medicines?action=list">Quản lý Thuốc (CRUD)</a></li>
                <li><a href="suppliers?action=list">Quản lý Nhà cung cấp (CRUD)</a></li>
                <li><a href="orders?action=list">Quản lý Đơn hàng (CRUD)</a></li>
                <li><a href="login?action=logout">Đăng xuất</a></li>
            </ul>
        </c:when>
        
        <%-- TRƯỜNG HỢP 3: KHÔNG AI ĐĂNG NHẬP (Redirect về trang login) --%>
        <c:otherwise>
            <c:redirect url="login"/>
        </c:otherwise>
    </c:choose>
</body>
</html>