<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><c:if test="${action == 'insert'}">Thêm Thuốc Mới</c:if><c:if test="${action == 'update'}">Chỉnh Sửa Thuốc</c:if></title>
    <style> .error { color: red; font-weight: bold; } label { display: inline-block; width: 140px; } </style>
</head>
<body>
    <c:if test="${empty sessionScope.currentEmployee}">
        <c:redirect url="login.jsp" />
    </c:if>

    <h1><c:if test="${action == 'insert'}">Thêm Thuốc Mới</c:if><c:if test="${action == 'update'}">Chỉnh Sửa Thuốc ID: ${medicine.medicineId}</c:if></h1>
    <p><a href="medicines?action=list">Trở về Danh sách Thuốc</a></p>
    
    <c:if test="${not empty error}">
        <p class="error">Lỗi: <c:out value="${error}" /></p>
    </c:if>

    <form method="post" action="medicines">
        <input type="hidden" name="action" value="<c:out value="${action}" />" />
        <c:if test="${action == 'update'}">
            <input type="hidden" name="id" value="<c:out value="${medicine.medicineId}" />" />
        </c:if>

        <p><label>Tên Thuốc:</label> <input type="text" name="name" value="<c:out value="${medicine.name}" />" required size="40"/></p>
        <p><label>ID NCC:</label> <input type="number" name="supplierId" value="<c:out value="${medicine.supplierId}" />" required /></p>
        <p><label>Giá:</label> <input type="number" step="100" name="price" value="<c:out value="${medicine.price}" />" required /></p>
        <p><label>Số Lượng:</label> <input type="number" name="quantity" value="<c:out value="${medicine.quantity}" />" required /></p>
        <p><label>Hết Hạn (YYYY-MM-DD):</label> <input type="date" name="expiryDate" value="<c:out value="${medicine.expiryDate}" />" required /></p>
        <p><label>Mô tả:</label> <textarea name="description" rows="3" cols="40"><c:out value="${medicine.description}" /></textarea></p>
        <p><label>Đường dẫn ảnh:</label> <input type="text" name="imagePath" value="<c:out value="${medicine.imagePath}" />" size="40"/></p>
        
        <p><button type="submit">Lưu</button></p>
    </form>
</body>
</html>