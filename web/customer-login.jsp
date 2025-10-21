<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập Khách hàng</title>
    <style> /* ... style CSS ... */ </style>
</head>
<body>
    <div class="container">
        <h2>Đăng nhập Khách hàng</h2>
        
        <c:if test="${not empty error}">
            <p class="error">Lỗi: <c:out value="${error}" /></p>
        </c:if>
        
        <form action="customerLogin" method="post">
            <p>
                <label for="name">Tên khách hàng:</label><br>
                <input type="text" id="name" name="name" required>
            </p>
            <p>
                <label for="password">Mật khẩu:</label><br>
                <input type="password" id="password" name="password" required>
            </p>
            <p>
                <button type="submit">Đăng nhập</button>
            </p>
        </form>
        <p><a href="index.jsp">Về trang chủ</a></p>
    </div>
</body>
</html>