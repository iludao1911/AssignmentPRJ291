                                                                <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .admin-menu {
            background: #f8f9fa;
            padding: 15px;
            margin-bottom: 20px;
        }
        .admin-menu a {
            margin-right: 15px;
            text-decoration: none;
            color: #333;
        }
        .admin-menu a:hover {
            color: #007bff;
        }
        .stats-container {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-box {
            background: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .stat-box h3 {
            margin-top: 0;
            color: #333;
        }
        .stat-box p {
            font-size: 24px;
            color: #007bff;
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <h1>Admin Dashboard</h1>
        
        <div class="admin-menu">
            <a href="${pageContext.request.contextPath}/medicines">Quản lý Sản phẩm</a>
            <a href="${pageContext.request.contextPath}/admin/action/users">Quản lý Người dùng</a>
            <a href="${pageContext.request.contextPath}/admin/action/orders">Quản lý Đơn hàng</a>
            <a href="${pageContext.request.contextPath}/admin/action/suppliers">Quản lý Nhà cung cấp</a>
            <a href="${pageContext.request.contextPath}/login?action=logout">Đăng xuất</a>
        </div>

        <div class="stats-container">
            <div class="stat-box">
                <h3>Tổng số sản phẩm</h3>
                <p>${totalProducts}</p>
            </div>
            <div class="stat-box">
                <h3>Tổng số người dùng</h3>
                <p>${totalUsers}</p>
            </div>
            <div class="stat-box">
                <h3>Đơn hàng mới</h3>
                <p>${newOrders}</p>
            </div>
        </div>

        <div class="quick-actions">
            <h2>Thao tác nhanh</h2>
            <ul>
                <li><a href="${pageContext.request.contextPath}/medicines?action=new">Thêm sản phẩm mới</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/action/orders?status=pending">Xem đơn hàng chờ xử lý</a></li>
                <%-- <li><a href="${pageContext.request.contextPath}/admin/action/inventory">Kiểm tra tồn kho</a></li> --%>
            </ul>
        </div>
    </div>
</body>
</html>