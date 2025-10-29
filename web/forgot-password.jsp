<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu</title>
    <style>
        .container { max-width: 480px; margin: 40px auto; padding: 20px; }
        .error { color: red; }
        .success { color: green; }
        input { width: 100%; padding: 8px; margin: 8px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Quên mật khẩu</h2>
        <p>Vui lòng nhập tên đăng nhập và email để lấy lại mật khẩu.</p>
        
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>
        <c:if test="${not empty success}">
            <p class="success">${success}</p>
        </c:if>
        
        <form action="forgot-password" method="post">
            <div>
                <label for="name">Tên đăng nhập:</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div>
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div>
                <button type="submit">Tiếp tục</button>
            </div>
        </form>
        
        <p><a href="customerLogin">Quay lại đăng nhập</a></p>
    </div>
</body>
</html>