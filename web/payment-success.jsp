<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.User, model.Order, dao.OrderDAO, java.text.NumberFormat, java.util.Locale" %>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("auth-login.jsp");
        return;
    }
    
    // Lấy orderId từ parameter
    String orderIdStr = request.getParameter("orderId");
    Order order = null;
    
    if (orderIdStr != null) {
        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderDAO orderDAO = new OrderDAO();
            order = orderDAO.getOrderById(orderId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    NumberFormat currencyFormatter = NumberFormat.getInstance(new Locale("vi", "VN"));
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán Thành Công - Pharmacy Store</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #14b8a6 0%, #0d9488 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .success-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            max-width: 600px;
            width: 100%;
            padding: 40px;
            text-align: center;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .success-icon {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: linear-gradient(135deg, #14b8a6 0%, #0d9488 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 30px;
            animation: scaleIn 0.5s ease-out 0.2s both;
        }

        @keyframes scaleIn {
            from {
                transform: scale(0);
            }
            to {
                transform: scale(1);
            }
        }

        .success-icon i {
            font-size: 50px;
            color: white;
        }

        h1 {
            color: #333;
            font-size: 32px;
            margin-bottom: 15px;
            font-weight: 700;
        }

        .subtitle {
            color: #666;
            font-size: 16px;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .order-info {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 25px;
            margin: 30px 0;
            text-align: left;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #e0e0e0;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            color: #666;
            font-weight: 500;
            font-size: 14px;
        }

        .info-value {
            color: #333;
            font-weight: 600;
            font-size: 15px;
        }

        .info-value.highlight {
            color: #14b8a6;
            font-size: 20px;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }

        .status-badge.pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-badge.paid {
            background: #d1ecf1;
            color: #0c5460;
        }

        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }

        .btn {
            flex: 1;
            min-width: 200px;
            padding: 15px 30px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #14b8a6 0%, #0d9488 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(20, 184, 166, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(20, 184, 166, 0.5);
        }

        .btn-secondary {
            background: white;
            color: #14b8a6;
            border: 2px solid #14b8a6;
        }

        .btn-secondary:hover {
            background: #f8f9ff;
            transform: translateY(-2px);
        }

        .btn-outline {
            background: transparent;
            color: #666;
            border: 2px solid #ddd;
        }

        .btn-outline:hover {
            background: #f8f9fa;
            border-color: #999;
            color: #333;
        }

        .divider {
            height: 1px;
            background: linear-gradient(to right, transparent, #ddd, transparent);
            margin: 30px 0;
        }

        .note {
            background: #e3f2fd;
            border-left: 4px solid #2196F3;
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
            text-align: left;
        }

        .note i {
            color: #2196F3;
            margin-right: 10px;
        }

        .note p {
            color: #555;
            font-size: 14px;
            line-height: 1.6;
            margin: 5px 0;
        }

        @media (max-width: 600px) {
            .success-container {
                padding: 30px 20px;
            }

            h1 {
                font-size: 24px;
            }

            .button-group {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }
        }

        /* Animation for confetti effect */
        @keyframes confetti-fall {
            0% {
                top: -10%;
                transform: translateX(0) rotateZ(0deg);
            }
            100% {
                top: 100%;
                transform: translateX(100px) rotateZ(720deg);
            }
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-icon">
            <i class="fas fa-check"></i>
        </div>

        <h1>🎉 Thanh Toán Thành Công!</h1>
        <p class="subtitle">
            Cảm ơn bạn đã tin tưởng và đặt hàng tại Pharmacy Store.<br>
            Đơn hàng của bạn đã được ghi nhận và đang chờ xác nhận từ cửa hàng.
        </p>

        <% if (order != null) { %>
        <div class="order-info">
            <div class="info-row">
                <span class="info-label">
                    <i class="fas fa-hashtag"></i> Mã đơn hàng
                </span>
                <span class="info-value">#<%= order.getOrderId() %></span>
            </div>

            <div class="info-row">
                <span class="info-label">
                    <i class="fas fa-calendar"></i> Ngày đặt
                </span>
                <span class="info-value"><%= order.getOrderDate() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(order.getOrderDate()) : "N/A" %></span>
            </div>

            <div class="info-row">
                <span class="info-label">
                    <i class="fas fa-info-circle"></i> Trạng thái
                </span>
                <span class="status-badge paid"><%= order.getStatus() %></span>
            </div>

            <div class="divider"></div>

            <div class="info-row">
                <span class="info-label">
                    <i class="fas fa-money-bill-wave"></i> Tổng tiền
                </span>
                <span class="info-value highlight"><%= currencyFormatter.format(order.getTotalAmount()) %>đ</span>
            </div>
        </div>
        <% } %>

        <div class="note">
            <p><i class="fas fa-info-circle"></i> <strong>Lưu ý:</strong></p>
            <p>• Đơn hàng sẽ được xử lý trong vòng 24 giờ làm việc</p>
            <p>• Bạn có thể theo dõi trạng thái đơn hàng tại trang "Đơn hàng của tôi"</p>
            <p>• Chúng tôi sẽ liên hệ với bạn qua số điện thoại đã cung cấp</p>
        </div>

        <div class="button-group">
            <% if (order != null) { %>
            <button onclick="viewOrderDetail(<%= order.getOrderId() %>)" class="btn btn-primary">
                <i class="fas fa-file-invoice"></i>
                Xem Chi Tiết Đơn Hàng
            </button>
            <% } %>
            
            <a href="order-history.jsp" class="btn btn-secondary">
                <i class="fas fa-list"></i>
                Đơn Hàng Của Tôi
            </a>
            
            <a href="home.jsp" class="btn btn-outline">
                <i class="fas fa-home"></i>
                Về Trang Chủ
            </a>
        </div>
    </div>

    <!-- Modal for order details -->
    <div id="orderModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9999; justify-content: center; align-items: center;">
        <div style="background: white; border-radius: 12px; max-width: 800px; width: 90%; max-height: 90vh; overflow-y: auto; position: relative;">
            <div style="padding: 25px; border-bottom: 2px solid #e5e7eb;">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <h2 style="color: #333; margin: 0;">Chi Tiết Đơn Hàng</h2>
                    <button onclick="closeModal()" style="background: none; border: none; font-size: 28px; color: #666; cursor: pointer; padding: 0; width: 32px; height: 32px; display: flex; align-items: center; justify-content: center;">&times;</button>
                </div>
            </div>
            
            <div id="modalContent" style="padding: 25px;">
                <div style="text-align: center; padding: 40px;">
                    <i class="fas fa-spinner fa-spin" style="font-size: 32px; color: #14b8a6;"></i>
                    <p style="margin-top: 15px; color: #666;">Đang tải thông tin...</p>
                </div>
            </div>
        </div>
    </div>

    <script>
        function viewOrderDetail(orderId) {
            const modal = document.getElementById('orderModal');
            modal.style.display = 'flex';
            
            fetch('order-details?orderId=' + orderId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        displayOrderDetails(data.order);
                    } else {
                        document.getElementById('modalContent').innerHTML = 
                            '<div style="text-align: center; padding: 40px;"><i class="fas fa-exclamation-triangle" style="font-size: 32px; color: #ef4444;"></i><p style="margin-top: 15px; color: #666;">' + data.message + '</p></div>';
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('modalContent').innerHTML = 
                        '<div style="text-align: center; padding: 40px;"><i class="fas fa-exclamation-triangle" style="font-size: 32px; color: #ef4444;"></i><p style="margin-top: 15px; color: #666;">Có lỗi xảy ra khi tải dữ liệu</p></div>';
                });
        }

        function displayOrderDetails(order) {
            const statusColors = {
                'Chờ thanh toán': '#ffc107',
                'Đã thanh toán': '#17a2b8',
                'Đang giao': '#007bff',
                'Hoàn thành': '#28a745',
                'Đã hủy': '#dc3545'
            };
            
            const statusColor = statusColors[order.status] || '#6c757d';
            
            let itemsHtml = '';
            order.items.forEach(function(item) {
                // Handle image path - check if it already has 'image/' prefix
                let imgPath = item.medicineImage || 'default-medicine.png';
                if (!imgPath.startsWith('image/')) {
                    imgPath = 'image/' + imgPath;
                }
                itemsHtml += '<div style="display: flex; gap: 15px; padding: 15px; background: #f8f9fa; border-radius: 8px; margin-bottom: 12px;">' +
                    '<img src="' + imgPath + '" alt="' + item.medicineName + '" style="width: 80px; height: 80px; object-fit: cover; border-radius: 8px;">' +
                    '<div style="flex: 1;">' +
                        '<h4 style="margin: 0 0 8px 0; color: #333;">' + item.medicineName + '</h4>' +
                        '<p style="color: #666; margin: 4px 0; font-size: 14px;">Đơn giá: ' + item.unitPrice.toLocaleString('vi-VN') + 'đ</p>' +
                        '<p style="color: #666; margin: 4px 0; font-size: 14px;">Số lượng: ' + item.quantity + '</p>' +
                        '<p style="color: #14b8a6; margin: 8px 0 0 0; font-weight: 600; font-size: 15px;">Thành tiền: ' + item.subtotal.toLocaleString('vi-VN') + 'đ</p>' +
                    '</div>' +
                '</div>';
            });

            document.getElementById('modalContent').innerHTML = 
                '<div style="margin-bottom: 25px;">' +
                    '<div style="display: flex; justify-content: space-between; margin-bottom: 15px;">' +
                        '<div><p style="color: #666; margin-bottom: 5px;">Mã đơn hàng</p><p style="font-weight: 600; color: #333; font-size: 18px;">#' + order.orderId + '</p></div>' +
                        '<div style="text-align: right;"><p style="color: #666; margin-bottom: 5px;">Ngày đặt</p><p style="font-weight: 600; color: #333;">' + order.orderDate + '</p></div>' +
                    '</div>' +
                    '<div style="background: ' + statusColor + '; color: white; padding: 10px 20px; border-radius: 8px; text-align: center; font-weight: 600;">' + order.status + '</div>' +
                '</div>' +
                '<div style="border: 1px solid #e5e7eb; border-radius: 8px; padding: 20px; margin-bottom: 20px;">' +
                    '<h3 style="margin: 0 0 15px 0; color: #333; border-bottom: 2px solid #e5e7eb; padding-bottom: 10px;">Thông tin khách hàng</h3>' +
                    '<p style="margin: 8px 0; color: #555;"><i class="fas fa-user" style="width: 20px; color: #14b8a6;"></i> ' + order.customerName + '</p>' +
                    '<p style="margin: 8px 0; color: #555;"><i class="fas fa-envelope" style="width: 20px; color: #14b8a6;"></i> ' + order.customerEmail + '</p>' +
                    '<p style="margin: 8px 0; color: #555;"><i class="fas fa-map-marker-alt" style="width: 20px; color: #14b8a6;"></i> ' + order.shippingAddress.replace(/\n/g, '<br>') + '</p>' +
                '</div>' +
                '<div style="margin-bottom: 20px;">' +
                    '<h3 style="margin: 0 0 15px 0; color: #333; border-bottom: 2px solid #e5e7eb; padding-bottom: 10px;">Sản phẩm đã đặt</h3>' +
                    itemsHtml +
                '</div>' +
                '<div style="background: linear-gradient(135deg, #14b8a6 0%, #0d9488 100%); color: white; padding: 20px; border-radius: 8px;">' +
                    '<div style="display: flex; justify-content: space-between; align-items: center;">' +
                        '<span style="font-size: 18px; font-weight: 600;">Tổng cộng:</span>' +
                        '<span style="font-size: 24px; font-weight: 700;">' + order.totalAmount.toLocaleString('vi-VN') + 'đ</span>' +
                    '</div>' +
                '</div>';
        }

        function closeModal() {
            document.getElementById('orderModal').style.display = 'none';
        }

        // Close modal when clicking outside
        document.getElementById('orderModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeModal();
            }
        });
    </script>
</body>
</html>
