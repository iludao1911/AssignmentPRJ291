<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Khách hàng</title>
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

    <h1>Danh sách Khách hàng</h1>
    <p>
        <a href="customers?action=new">Thêm Khách hàng Mới</a> |
        <a href="index.jsp">Trang Chủ</a>
    </p>

    <c:if test="${not empty error}">
        <p style="color: red;">Lỗi: <c:out value="${error}" /></p>
    </c:if>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Tên Khách hàng</th>
                <th>Email</th>
                <th>Điện thoại</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="customer" items="${requestScope.listCustomers}">
                <tr>
                    <td><c:out value="${customer.customerId}" /></td>
                    <td><c:out value="${customer.name}" /></td>
                    <td><c:out value="${customer.email}" /></td>
                    <td><c:out value="${customer.phone}" /></td>
                    <td>
                        <a href="customers?action=edit&id=<c:out value='${customer.customerId}' />">Sửa</a> |
                        <a href="customers?action=delete&id=<c:out value='${customer.customerId}' />" 
                           onclick="return confirm('Xóa khách hàng này?');">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty requestScope.listCustomers}">
                 <tr><td colspan="5">Không có khách hàng nào trong hệ thống.</td></tr>
            </c:if>
        </tbody>
    </table>
</body>
</html>