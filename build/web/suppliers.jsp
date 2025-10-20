<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Nhà cung cấp</title>
    <style>
        table { border-collapse: collapse; width: 80%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.currentEmployee}">
        <c:redirect url="login.jsp" />
    </c:if>

    <h1>Danh sách Nhà cung cấp</h1>
    <p>
        <a href="suppliers?action=new">Thêm NCC Mới</a> |
        <a href="index.jsp">Trang Chủ</a>
    </p>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Tên Nhà cung cấp</th>
                <th>Địa chỉ</th>
                <th>Điện thoại</th>
                <th>Email</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="supplier" items="${requestScope.listSuppliers}">
                <tr>
                    <td><c:out value="${supplier.supplierId}" /></td>
                    <td><c:out value="${supplier.name}" /></td>
                    <td><c:out value="${supplier.address}" /></td>
                    <td><c:out value="${supplier.phone}" /></td>
                    <td><c:out value="${supplier.email}" /></td>
                    <td>
                        <a href="suppliers?action=edit&id=<c:out value='${supplier.supplierId}' />">Sửa</a> |
                        <a href="suppliers?action=delete&id=<c:out value='${supplier.supplierId}' />" 
                           onclick="return confirm('Xóa nhà cung cấp này?');">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>