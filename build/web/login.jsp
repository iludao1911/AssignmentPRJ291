<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập Hệ thống</title>
    <style> /* ... style CSS ... */ </style>
</head>
<body>
    <div class="container">
        <h2>Đăng nhập Hệ thống</h2>
        <p>Vui lòng nhập Mã/Tên đăng nhập và Mật khẩu.</p>
        
        <c:if test="${param.registration == 'success'}">
            <p class="success">Đăng ký tài khoản thành công! Vui lòng đăng nhập.</p>
        </c:if>

        <c:if test="${not empty error}">
            <p class="error">Lỗi: <c:out value="${error}" /></p>
        </c:if>
        
        <form action="login" method="post">
            <p>
                <label for="email">Email:</label><br>
                <input type="email" id="email" name="email" required>
            </p>
            <p>
                <label for="password">Mật khẩu:</label><br>
                <input type="password" id="password" name="password" required>
            </p>
            <p>
                <input type="checkbox" id="remember" name="remember" value="true">
                <label for="remember">Ghi nhớ đăng nhập</label>
            </p>
            <p>
                <button type="submit">Đăng nhập</button>
            </p>
        </form>
        <p>
            <a href="forgot-password">Quên mật khẩu?</a>
        </p>
        <p>Chưa có tài khoản? 
            <a href="register" style="text-decoration:none;">
                <button type="button">Đăng ký</button>
            </a>
        </p>
    </div>
</body>
</html>