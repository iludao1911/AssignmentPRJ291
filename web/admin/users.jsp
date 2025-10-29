<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Người dùng</title>
    <style>
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .user-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .user-table th, .user-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .user-table th {
            background-color: #f8f9fa;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
        }
        .action-buttons button {
            padding: 5px 10px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        .edit-btn {
            background-color: #ffc107;
            color: #000;
        }
        .delete-btn {
            background-color: #dc3545;
            color: #fff;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Quản lý Người dùng</h1>
        
        <div class="admin-menu">
            <a href="${pageContext.request.contextPath}/admin/action/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/action/products">Quản lý Sản phẩm</a>
            <a href="${pageContext.request.contextPath}/admin/action/orders">Quản lý Đơn hàng</a>
            <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </div>

        <table class="user-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>Role</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${users}">
                    <tr>
                        <td>${user.customerId}</td>
                        <td>${user.name}</td>
                        <td>${user.email}</td>
                        <td>${user.phone}</td>
                        <td>${user.role}</td>
                        <td class="action-buttons">
                            <button class="edit-btn" onclick="editUser('${user.customerId}')">Sửa</button>
                            <c:if test="${user.role != 'Admin'}">
                                <button class="delete-btn" onclick="deleteUser('${user.customerId}')">Xóa</button>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script>
        function editUser(userId) {
            window.location.href = '${pageContext.request.contextPath}/admin/action/users/edit?id=' + userId;
        }

        function deleteUser(userId) {
            if (confirm('Bạn có chắc chắn muốn xóa người dùng này?')) {
                fetch('${pageContext.request.contextPath}/admin/action/users/delete?id=' + userId, {
                    method: 'POST'
                }).then(response => {
                    if (response.ok) {
                        window.location.reload();
                    }
                });
            }
        }
    </script>
</body>
</html>