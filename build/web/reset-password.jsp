<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt lại mật khẩu</title>
    <style>
        .container { max-width: 480px; margin: 40px auto; padding: 20px; }
        .error { color: red; }
        input { width: 100%; padding: 8px; margin: 8px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Đặt lại mật khẩu</h2>
        
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>
        
        <form action="forgot-password" method="post">
            <input type="hidden" name="action" value="reset">
            <input type="hidden" name="customerId" value="${customerId}">
            
            <div>
                <label for="newPassword">Mật khẩu mới:</label>
                <input type="password" id="newPassword" name="newPassword" required>
            </div>
            <div>
                <label for="confirmPassword">Xác nhận mật khẩu:</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
            </div>
            <div>
                <button type="submit">Đặt lại mật khẩu</button>
            </div>
        </form>
    </div>
</body>
</html>