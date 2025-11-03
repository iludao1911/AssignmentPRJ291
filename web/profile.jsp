<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Order" %>
<%@ page import="model.User" %>
<%@ page import="dao.OrderDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("auth-login.jsp");
        return;
    }
    
    OrderDAO orderDAO = new OrderDAO();
    List<Order> doneOrders = null;
    try {
        // Chỉ lấy đơn hàng đã hoàn thành (đã nhận hàng)
        doneOrders = orderDAO.getOrdersByUserIdAndStatus(currentUser.getUserId(), "Hoàn thành");
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ - Nhà Thuốc MS</title>
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

        /* Header */
        .header {
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
            color: white;
            padding: 15px 0;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .header-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.5rem;
            font-weight: 700;
            text-decoration: none;
            color: white;
        }

        .logo i {
            font-size: 2rem;
        }

        .back-link {
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 15px;
            border-radius: 8px;
            transition: background 0.3s;
        }

        .back-link:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        /* Container */
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .page-title {
            font-size: 2rem;
            color: #333;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .page-title i {
            color: #0891b2;
        }

        /* Profile Layout */
        .profile-layout {
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 30px;
        }

        /* User Info Card */
        .user-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            height: fit-content;
        }

        .user-avatar-large {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: white;
            margin: 0 auto 20px;
            font-weight: 700;
        }

        .user-name-large {
            text-align: center;
            font-size: 1.3rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 5px;
        }

        .user-email-large {
            text-align: center;
            color: #666;
            margin-bottom: 20px;
        }

        .user-info-item {
            padding: 15px 0;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-info-item:last-child {
            border-bottom: none;
        }

        .user-info-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #f0f4ff;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #0891b2;
        }

        .user-info-text {
            flex: 1;
        }

        .user-info-label {
            font-size: 0.85rem;
            color: #999;
            margin-bottom: 3px;
        }

        .user-info-value {
            font-weight: 600;
            color: #333;
        }

        /* Edit Profile Button */
        .edit-profile-btn {
            width: 100%;
            padding: 12px;
            margin-top: 20px;
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.3s;
            text-decoration: none;
        }

        .edit-profile-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(8, 145, 178, 0.3);
        }

        /* Orders Section */
        .orders-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #333;
        }

        .view-all-link {
            color: #0891b2;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s;
        }

        .view-all-link:hover {
            color: #0d9488;
        }

        .empty-orders {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .empty-orders i {
            font-size: 5rem;
            color: #ddd;
            margin-bottom: 20px;
        }

        .empty-orders h3 {
            font-size: 1.3rem;
            margin-bottom: 10px;
        }

        .order-card {
            border: 2px solid #f0f0f0;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            transition: all 0.3s;
        }

        .order-card:hover {
            border-color: #0891b2;
            box-shadow: 0 5px 15px rgba(8, 145, 178, 0.1);
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #f0f0f0;
        }

        .order-id {
            font-size: 1.1rem;
            font-weight: 700;
            color: #333;
        }

        .order-date {
            color: #666;
            font-size: 0.9rem;
        }

        .order-status {
            display: inline-block;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            background: #d4edda;
            color: #155724;
        }

        .order-body {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .order-total {
            font-size: 1.5rem;
            font-weight: 700;
            color: #0891b2;
        }

        @media (max-width: 968px) {
            .profile-layout {
                grid-template-columns: 1fr;
            }
        }

        /* Edit Mode Styles */
        .edit-mode .user-info-value {
            display: none;
        }

        .edit-mode .edit-input {
            display: block !important;
        }

        .edit-input {
            display: none;
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 0.95rem;
            font-family: inherit;
        }

        .edit-input:focus {
            outline: none;
            border-color: #0891b2;
        }

        .edit-actions {
            display: none;
            gap: 10px;
            margin-top: 15px;
        }

        .edit-mode .edit-actions {
            display: flex;
        }

        .edit-mode .edit-profile-btn {
            display: none;
        }

        .btn-save, .btn-cancel {
            flex: 1;
            padding: 10px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-save {
            background: #0891b2;
            color: white;
        }

        .btn-save:hover {
            background: #0d9488;
        }

        .btn-cancel {
            background: #e5e7eb;
            color: #666;
        }

        .btn-cancel:hover {
            background: #d1d5db;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-content">
            <a href="home.jsp" class="logo">
                <i class="fas fa-capsules"></i>
                <span>Nhà Thuốc MS</span>
            </a>
            
            <a href="home.jsp" class="back-link">
                <i class="fas fa-arrow-left"></i>
                <span>Quay lại trang chủ</span>
            </a>
        </div>
    </header>

    <div class="container">
        <h1 class="page-title">
            <i class="fas fa-user-circle"></i>
            Hồ Sơ Của Tôi
        </h1>

        <div class="profile-layout">
            <!-- User Info Card -->
            <div class="user-card" id="userCard">
                <div class="user-avatar-large">
                    <%= currentUser.getName().substring(0, 1).toUpperCase() %>
                </div>
                
                <div class="user-name-large"><%= currentUser.getName() %></div>
                <div class="user-email-large"><%= currentUser.getEmail() %></div>
                
                <form id="editProfileForm" method="post" action="profile">
                    <div class="user-info-item">
                        <div class="user-info-icon">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="user-info-text">
                            <div class="user-info-label">Họ và tên</div>
                            <div class="user-info-value"><%= currentUser.getName() %></div>
                            <input type="text" name="name" class="edit-input" value="<%= currentUser.getName() %>">
                        </div>
                    </div>
                    
                    <div class="user-info-item">
                        <div class="user-info-icon">
                            <i class="fas fa-phone"></i>
                        </div>
                        <div class="user-info-text">
                            <div class="user-info-label">Số điện thoại</div>
                            <div class="user-info-value"><%= currentUser.getPhone() != null ? currentUser.getPhone() : "Chưa cập nhật" %></div>
                            <input type="text" name="phone" class="edit-input" value="<%= currentUser.getPhone() != null ? currentUser.getPhone() : "" %>">
                        </div>
                    </div>
                    
                    <div class="user-info-item">
                        <div class="user-info-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <div class="user-info-text">
                            <div class="user-info-label">Vai trò</div>
                            <div class="user-info-value"><%= currentUser.getRole() %></div>
                        </div>
                    </div>
                    
                    <div class="user-info-item">
                        <div class="user-info-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="user-info-text">
                            <div class="user-info-label">Trạng thái</div>
                            <div class="user-info-value"><%= currentUser.isVerified() ? "Đã xác thực" : "Chưa xác thực" %></div>
                        </div>
                    </div>
                    
                    <div class="edit-actions">
                        <button type="submit" class="btn-save">
                            <i class="fas fa-check"></i> Lưu
                        </button>
                        <button type="button" class="btn-cancel" onclick="toggleEditMode()">
                            <i class="fas fa-times"></i> Hủy
                        </button>
                    </div>
                </form>
                
                <!-- Edit Profile Button -->
                <button class="edit-profile-btn" onclick="toggleEditMode()">
                    <i class="fas fa-edit"></i>
                    Chỉnh sửa hồ sơ
                </button>
            </div>

            <!-- Orders Section -->
            <div class="orders-section">
                <div class="section-header">
                    <h2 class="section-title">Đơn Hàng Đã Hoàn Thành</h2>
                    <a href="order-history.jsp" class="view-all-link">
                        Xem tất cả →
                    </a>
                </div>
                
                <% if (doneOrders == null || doneOrders.isEmpty()) { %>
                    <div class="empty-orders">
                        <i class="fas fa-check-circle"></i>
                        <h3>Chưa có đơn hàng hoàn thành</h3>
                        <p>Các đơn hàng đã nhận sẽ hiển thị tại đây</p>
                    </div>
                <% } else { 
                    int displayCount = Math.min(3, doneOrders.size());
                    for (int i = 0; i < displayCount; i++) {
                        Order order = doneOrders.get(i);
                %>
                    <div class="order-card">
                        <div class="order-header">
                            <div>
                                <div class="order-id">Đơn hàng #<%= order.getOrderId() %></div>
                                <div class="order-date">
                                    <i class="far fa-clock"></i>
                                    <%= dateFormat.format(order.getOrderDate()) %>
                                </div>
                            </div>
                            <span class="order-status">Hoàn thành</span>
                        </div>
                        
                        <div class="order-body">
                            <div>
                                <i class="fas fa-box"></i>
                                Đã nhận hàng
                            </div>
                            <div class="order-total"><%= String.format("%,d", (long)order.getTotalAmount()) %>đ</div>
                        </div>
                    </div>
                <% 
                    }
                } %>
            </div>
        </div>
    </div>

    <!-- AI Chatbot Widget -->
    <jsp:include page="chatbot-widget.jsp" />
    
    <% if (request.getAttribute("success") != null) { %>
        <script>alert('<%= request.getAttribute("success") %>');</script>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
        <script>alert('<%= request.getAttribute("error") %>');</script>
    <% } %>
    
    <script>
        function toggleEditMode() {
            const userCard = document.getElementById('userCard');
            userCard.classList.toggle('edit-mode');
        }
    </script>
</body>
</html>
