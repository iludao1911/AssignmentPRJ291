<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập Hệ thống</title>
    <style>
        .container { width: 300px; margin: 100px auto; padding: 20px; border: 1px solid #ccc; }
        .error { color: red; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Đăng nhập Nhân viên</h2>
        
        <c:if test="${not empty error}">
            <p class="error">Lỗi: <c:out value="${error}" /></p>
        </c:if>
        
        <form action="login" method="post">
            <p>
                <label for="username">Tên đăng nhập:</label><br>
                <input type="text" id="username" name="username" required>
            </p>
            <p>
                <label for="password">Mật khẩu:</label><br>
                <input type="password" id="password" name="password" required>
            </p>
            <p>
                <button type="submit">Đăng nhập</button>
            </p>
        </form>
    </div>
</body>
</html>