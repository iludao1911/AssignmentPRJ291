<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    User adminUser = (User) session.getAttribute("currentUser");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/auth-login.jsp");
        return;
    }
    String currentPage = request.getParameter("page");
    if (currentPage == null) currentPage = "";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Admin" %> - Nhà Thuốc MS</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
            min-height: 100vh;
        }

        .admin-layout {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
            color: white;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            z-index: 1000;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
        }

        .sidebar-header {
            padding: 25px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .logo {
            display: flex;
            align-items: center;
            text-decoration: none;
            color: white;
        }

        .logo-icon {
            width: 45px;
            height: 45px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
        }

        .logo-icon i {
            font-size: 1.4rem;
        }

        .logo-text {
            font-size: 1.2rem;
            font-weight: 700;
        }

        .sidebar-menu {
            padding: 20px 0;
        }

        .menu-item {
            padding: 12px 20px;
            display: flex;
            align-items: center;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            transition: all 0.3s;
            cursor: pointer;
        }

        .menu-item:hover,
        .menu-item.active {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border-left: 4px solid white;
            padding-left: 16px;
        }

        .menu-item i {
            width: 25px;
            margin-right: 12px;
            font-size: 1.1rem;
        }

        .sidebar-footer {
            position: absolute;
            bottom: 0;
            width: 260px;
            padding: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            background: rgba(0, 0, 0, 0.1);
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            font-weight: 700;
        }

        .user-details {
            flex: 1;
        }

        .user-name {
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 3px;
        }

        .user-role {
            font-size: 0.75rem;
            opacity: 0.8;
        }

        /* Main Content */
        .main-content {
            margin-left: 260px;
            flex: 1;
            padding: 30px;
            width: calc(100% - 260px);
        }

        .page-header {
            background: white;
            padding: 25px 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .page-title {
            font-size: 1.8rem;
            color: #333;
            margin-bottom: 5px;
        }

        .page-subtitle {
            color: #666;
            font-size: 0.95rem;
        }

        .content-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        /* Buttons */
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(8, 145, 178, 0.3);
        }

        .btn-secondary {
            background: #e5e7eb;
            color: #374151;
        }

        .btn-secondary:hover {
            background: #d1d5db;
        }

        .btn-danger {
            background: #ef4444;
            color: white;
        }

        .btn-danger:hover {
            background: #dc2626;
        }

        .btn-success {
            background: #10b981;
            color: white;
        }

        .btn-success:hover {
            background: #059669;
        }

        @media (max-width: 968px) {
            .sidebar {
                width: 70px;
            }

            .sidebar-footer {
                width: 70px;
            }

            .main-content {
                margin-left: 70px;
                width: calc(100% - 70px);
            }

            .menu-item span,
            .logo-text,
            .user-details {
                display: none;
            }

            .logo-icon {
                margin-right: 0;
            }
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="logo">
                    <div class="logo-icon">
                        <i class="fas fa-capsules"></i>
                    </div>
                    <div class="logo-text">Nhà Thuốc MS</div>
                </a>
            </div>

            <nav class="sidebar-menu">
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="menu-item <%= "dashboard".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-home"></i>
                    <span>Tổng quan</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin/medicines" class="menu-item <%= "medicines".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-pills"></i>
                    <span>Quản lý thuốc</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin/suppliers" class="menu-item <%= "suppliers".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-truck"></i>
                    <span>Nhà cung cấp</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin/orders" class="menu-item <%= "orders".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Đơn hàng</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin-users.jsp" class="menu-item <%= "users".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-users"></i>
                    <span>Khách hàng</span>
                </a>
                <a href="<%= request.getContextPath() %>/home.jsp" class="menu-item">
                    <i class="fas fa-store"></i>
                    <span>Xem cửa hàng</span>
                </a>
            </nav>

            <div class="sidebar-footer">
                <div class="user-info">
                    <div class="user-avatar">
                        <%= adminUser.getName().substring(0, 1).toUpperCase() %>
                    </div>
                    <div class="user-details">
                        <div class="user-name"><%= adminUser.getName() %></div>
                        <div class="user-role"><%= adminUser.getRole() %></div>
                    </div>
                    <a href="<%= request.getContextPath() %>/logout" style="color: white;">
                        <i class="fas fa-sign-out-alt"></i>
                    </a>
                </div>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
