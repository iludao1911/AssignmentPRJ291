<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng ký tài khoản</title>
    <style>
        /* Giữ style đơn giản */
        .container { max-width: 480px; margin: 40px auto; padding: 20px; border: 1px solid #ddd; }
        label { display:block; margin-top:8px; }
        input { width:100%; padding:8px; }
        .error { color: red; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Đăng ký tài khoản</h2>

        <c:if test="${not empty error}">
            <p class="error">Lỗi: <c:out value="${error}"/></p>
        </c:if>

        <form action="register" method="post">
            <label for="name">Tên:</label>
            <input type="text" id="name" name="name" required>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email">

            <label for="phone">Số điện thoại:</label>
            <input type="text" id="phone" name="phone">

            <label for="password">Mật khẩu:</label>
            <input type="password" id="password" name="password" required>

            <label for="confirmPassword">Xác nhận mật khẩu:</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required>

            <p><button type="submit">Đăng ký</button></p>
        </form>

        <p>Đã có tài khoản? <a href="login">Đăng nhập</a></p>
    </div>
</body>
</html>
