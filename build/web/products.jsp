<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Danh mục Thuốc</title>
    <style>
        table { border-collapse: collapse; width: 80%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .error { color: red; font-weight: bold; }
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.currentEmployee}">
        <c:redirect url="login.jsp" />
    </c:if>
    
    <h1>Danh mục Thuốc</h1>
    <p>
        <a href="medicines?action=new">Thêm Thuốc Mới</a> |
        <a href="index.jsp">Trang Chủ</a>
    </p>

    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Tên Thuốc</th>
                <th>Giá</th>
                <th>Số Lượng</th>
                <th>Hạn Dùng</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="medicine" items="${requestScope.listMedicines}">
                <tr>
                    <td><c:out value="${medicine.medicineId}" /></td>
                    <td><c:out value="${medicine.name}" /></td>
                    <td><c:out value="${medicine.price}" /></td>
                    <td><c:out value="${medicine.quantity}" /></td>
                    <td><c:out value="${medicine.expiryDate}" /></td>
                    <td>
                        <a href="medicines?action=edit&id=<c:out value='${medicine.medicineId}' />">Sửa</a> |
                        <a href="medicines?action=delete&id=<c:out value='${medicine.medicineId}' />" 
                           onclick="return confirm('Xóa thuốc này?');">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty requestScope.listMedicines}">
                 <tr><td colspan="6">Không có dữ liệu thuốc nào.</td></tr>
            </c:if>
        </tbody>
    </table>
</body>
</html>