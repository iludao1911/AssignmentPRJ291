<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý tài khoản User</title>
</head>
<body>
    <h2>Quản lý tài khoản User</h2>
    <table border="1" cellpadding="6">
        <tr>
            <th>ID</th>
            <th>Tên</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Password</th>
            <th>Thao tác</th>
        </tr>
        <c:forEach var="user" items="${userList}">
            <tr>
                <td>${user.customerId}</td>
                <td>${user.name}</td>
                <td>${user.email}</td>
                <td>${user.phone}</td>
                <td>${user.password}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/edit-user?id=${user.customerId}">Sửa</a> |
                    <form action="${pageContext.request.contextPath}/admin/action/users/delete" method="post" onsubmit="return confirm('Xóa tài khoản này?');" style="display:inline;">
                        <input type="hidden" name="id" value="${user.customerId}" />
                        <input type="submit" value="Xóa" />
                    </form>
                </td>
            </tr>
        </c:forEach>
    </table>
    <p><a href="${pageContext.request.contextPath}/admin/action/dashboard">Quay lại Dashboard</a></p>
</body>
</html>
