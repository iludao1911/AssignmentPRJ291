<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>
        <c:if test="${action == 'insert'}">Thêm Khách Hàng Mới</c:if>
        <c:if test="${action == 'update'}">Chỉnh Sửa Khách Hàng</c:if>
    </title>
    <style> 
        .error { color: red; font-weight: bold; } 
        label { display: inline-block; width: 120px; margin-bottom: 5px; } 
        input[type="text"], input[type="number"] { width: 250px; padding: 5px; margin-bottom: 10px; }
    </style>
</head>
<body>
    <%-- Bảo vệ trang: Chuyển hướng nếu chưa đăng nhập --%>
    <c:if test="${empty sessionScope.currentEmployee}">
        <c:redirect url="login.jsp" />
    </c:if>

    <h1>
        <c:if test="${action == 'insert'}">Thêm Khách Hàng Mới</c:if>
        <c:if test="${action == 'update'}">Chỉnh Sửa Khách Hàng ID: <c:out value="${customer.customerId}" /></c:if>
    </h1>
    <p><a href="customers?action=list">Trở về Danh sách Khách hàng</a></p>
    
    <%-- Hiển thị lỗi nếu có --%>
    <c:if test="${not empty error}">
        <p class="error">Lỗi: <c:out value="${error}" /></p>
    </c:if>

    <form method="post" action="customers">
        <input type="hidden" name="action" value="<c:out value="${action}" />" />
        
        <c:if test="${action == 'update'}">
            <input type="hidden" name="id" value="<c:out value="${customer.customerId}" />" />
        </c:if>

        <p>
            <label>Tên Khách Hàng:</label> 
            <input type="text" name="name" value="<c:out value="${customer.name}" />" required />
        </p>
        <p>
            <label>Email:</label> 
            <input type="text" name="email" value="<c:out value="${customer.email}" />" />
        </p>
        <p>
            <label>Điện thoại:</label> 
            <input type="text" name="phone" value="<c:out value="${customer.phone}" />" required />
        </p>
        
        <p><button type="submit">Lưu</button></p>
    </form>
</body>
</html>