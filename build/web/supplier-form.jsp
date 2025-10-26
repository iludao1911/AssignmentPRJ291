<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>
        <c:if test="${action == 'insert'}">Thêm Nhà Cung Cấp Mới</c:if>
        <c:if test="${action == 'update'}">Chỉnh Sửa Nhà Cung Cấp ID: ${supplier.supplierId}</c:if>
    </title>
    <style> 
        .error { color: red; font-weight: bold; } 
        label { display: inline-block; width: 120px; margin-bottom: 5px; } 
        input[type="text"] { width: 250px; padding: 5px; margin-bottom: 10px; }
    </style>
</head>
<body>
    <%-- Bảo vệ trang: Chuyển hướng nếu chưa đăng nhập --%>
    <c:if test="${empty sessionScope.currentEmployee}">
        <c:redirect url="login.jsp" />
    </c:if>

    <h1>
        <c:if test="${action == 'insert'}">Thêm Nhà Cung Cấp Mới</c:if>
        <c:if test="${action == 'update'}">Chỉnh Sửa NCC ID: <c:out value="${supplier.supplierId}" /></c:if>
    </h1>
    <p><a href="suppliers?action=list">Trở về Danh sách NCC</a></p>
    
    <%-- Hiển thị lỗi nếu có (từ Service/Servlet) --%>
    <c:if test="${not empty error}">
        <p class="error">Lỗi: <c:out value="${error}" /></p>
    </c:if>

    <form method="post" action="suppliers">
        <input type="hidden" name="action" value="<c:out value="${action}" />" />
        
        <c:if test="${action == 'update'}">
            <input type="hidden" name="id" value="<c:out value="${supplier.supplierId}" />" />
        </c:if>

        <p>
            <label>Tên NCC:</label> 
            <input type="text" name="name" value="<c:out value="${supplier.name}" />" required />
        </p>
        <p>
            <label>Địa chỉ:</label> 
            <input type="text" name="address" value="<c:out value="${supplier.address}" />" required />
        </p>
        <p>
            <label>Điện thoại:</label> 
            <input type="text" name="phone" value="<c:out value="${supplier.phone}" />" required />
        </p>
        <p>
            <label>Email:</label> 
            <input type="text" name="email" value="<c:out value="${supplier.email}" />" />
        </p>
        
        <p><button type="submit">Lưu</button></p>
    </form>
</body>
</html>