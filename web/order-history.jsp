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
    List<Order> allOrders = null;
    try {
        // Lấy tất cả đơn hàng của user
        allOrders = orderDAO.getOrdersByUserId(currentUser.getUserId());
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
    <title>Lịch Sử Đơn Hàng - Nhà Thuốc MS</title>
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

        /* Filter Tabs */
        .filter-tabs {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .tabs-container {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .tab-btn {
            padding: 10px 20px;
            border: 2px solid #e0e0e0;
            background: white;
            color: #666;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .tab-btn:hover {
            border-color: #0891b2;
            color: #0891b2;
        }

        .tab-btn.active {
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
            border-color: #0891b2;
            color: white;
        }

        .tab-count {
            background: rgba(255, 255, 255, 0.3);
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 0.85rem;
        }

        .tab-btn.active .tab-count {
            background: rgba(255, 255, 255, 0.3);
        }

        /* Orders List */
        .orders-list {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
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
            font-size: 1.5rem;
            margin-bottom: 10px;
        }

        .empty-orders a {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 25px;
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            transition: transform 0.3s;
            font-size: 0.95rem;
        }

        .empty-orders a:hover {
            transform: translateY(-2px);
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
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-shipping {
            background: #cfe2ff;
            color: #084298;
        }

        .status-done {
            background: #d4edda;
            color: #155724;
        }

        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        .confirm-received-btn {
            margin-top: 15px;
            padding: 10px 20px;
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .confirm-received-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(8, 145, 178, 0.4);
        }

        .confirm-received-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .continue-payment-btn {
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(8, 145, 178, 0.3);
        }

        .continue-payment-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(8, 145, 178, 0.4);
        }

        .continue-payment-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .order-body {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
            align-items: center;
        }

        .order-info {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .order-info-row {
            display: flex;
            gap: 10px;
            font-size: 0.95rem;
        }

        .order-info-label {
            color: #666;
            font-weight: 500;
        }

        .order-info-value {
            color: #333;
        }

        .order-total {
            text-align: right;
        }

        .total-label {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 5px;
        }

        .total-amount {
            font-size: 1.8rem;
            font-weight: 700;
            color: #0891b2;
        }

        .order-address {
            grid-column: 1 / -1;
            margin-top: 10px;
            padding-top: 15px;
            border-top: 1px solid #f0f0f0;
        }

        .address-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }

        .address-text {
            color: #666;
            line-height: 1.5;
        }

        @media (max-width: 768px) {
            .order-body {
                grid-template-columns: 1fr;
            }

            .order-total {
                text-align: left;
            }

            .order-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
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
            <i class="fas fa-history"></i>
            Lịch Sử Đơn Hàng
        </h1>

        <!-- Filter Tabs -->
        <div class="filter-tabs">
            <div class="tabs-container">
                <button class="tab-btn active" onclick="filterOrders('all')" data-filter="all">
                    <i class="fas fa-list"></i>
                    Tất cả
                    <span class="tab-count" id="count-all">0</span>
                </button>
                <button class="tab-btn" onclick="filterOrders('Chờ thanh toán')" data-filter="Chờ thanh toán">
                    <i class="fas fa-clock"></i>
                    Chờ thanh toán
                    <span class="tab-count" id="count-pending">0</span>
                </button>
                <button class="tab-btn" onclick="filterOrders('Đã thanh toán')" data-filter="Đã thanh toán">
                    <i class="fas fa-check-circle"></i>
                    Đã thanh toán
                    <span class="tab-count" id="count-paid">0</span>
                </button>
                <button class="tab-btn" onclick="filterOrders('Đang giao')" data-filter="Đang giao">
                    <i class="fas fa-shipping-fast"></i>
                    Đang giao
                    <span class="tab-count" id="count-shipping">0</span>
                </button>
                <button class="tab-btn" onclick="filterOrders('Hoàn thành')" data-filter="Hoàn thành">
                    <i class="fas fa-check-double"></i>
                    Hoàn thành
                    <span class="tab-count" id="count-done">0</span>
                </button>
                <button class="tab-btn" onclick="filterOrders('Đã hủy')" data-filter="Đã hủy">
                    <i class="fas fa-times-circle"></i>
                    Đã hủy
                    <span class="tab-count" id="count-cancelled">0</span>
                </button>
            </div>
        </div>

        <div class="orders-list">
            <% if (allOrders == null || allOrders.isEmpty()) { %>
                <div class="empty-orders">
                    <i class="fas fa-shopping-bag"></i>
                    <h3>Chưa có đơn hàng nào</h3>
                    <p>Bạn chưa có đơn hàng nào trong hệ thống</p>
                    <a href="home.jsp">
                        <i class="fas fa-shopping-cart"></i>
                        Mua sắm ngay
                    </a>
                </div>
            <% } else {
                for (Order order : allOrders) {
                    String statusClass = "";
                    String statusText = "";
                    boolean canConfirmReceived = false;
                    boolean canContinuePayment = false;

                    switch (order.getStatus()) {
                        case "Chờ thanh toán":
                            statusClass = "status-pending";
                            statusText = "Chờ thanh toán";
                            canContinuePayment = true;
                            break;
                        case "Đã thanh toán":
                            statusClass = "status-pending";
                            statusText = "Đã thanh toán";
                            break;
                        case "Đang giao":
                            statusClass = "status-shipping";
                            statusText = "Đang giao";
                            canConfirmReceived = true;
                            break;
                        case "Hoàn thành":
                            statusClass = "status-done";
                            statusText = "Hoàn thành";
                            break;
                        case "Đã hủy":
                            statusClass = "status-cancelled";
                            statusText = "Đã hủy";
                            break;
                        default:
                            statusClass = "status-pending";
                            statusText = order.getStatus();
                    }
            %>
                <div class="order-card" data-status="<%= order.getStatus() %>">
                    <div class="order-header">
                        <div>
                            <div class="order-id">Đơn hàng #<%= order.getOrderId() %></div>
                            <div class="order-date">
                                <i class="far fa-clock"></i>
                                <%= dateFormat.format(order.getOrderDate()) %>
                            </div>
                        </div>
                        <span class="order-status <%= statusClass %>"><%= statusText %></span>
                    </div>
                    
                    <div class="order-body">
                        <div class="order-info">
                            <div class="order-info-row">
                                <span class="order-info-label">Người nhận:</span>
                                <span class="order-info-value"><%= order.getUserName() %></span>
                            </div>
                            <div class="order-info-row">
                                <span class="order-info-label">Email:</span>
                                <span class="order-info-value"><%= order.getUserEmail() %></span>
                            </div>
                        </div>
                        
                        <div class="order-total">
                            <div class="total-label">Tổng tiền:</div>
                            <div class="total-amount"><%= String.format("%,d", (long)order.getTotalAmount()) %>đ</div>
                        </div>
                        
                        <% if (order.getShippingAddress() != null && !order.getShippingAddress().isEmpty()) { %>
                        <div class="order-address">
                            <div class="address-label">
                                <i class="fas fa-map-marker-alt"></i>
                                Địa chỉ giao hàng:
                            </div>
                            <div class="address-text"><%= order.getShippingAddress() %></div>
                        </div>
                        <% } %>

                        <% if (canContinuePayment) { %>
                        <div class="order-address">
                            <button class="continue-payment-btn" onclick="continuePayment(<%= order.getOrderId() %>)">
                                <i class="fas fa-credit-card"></i>
                                Tiếp tục thanh toán
                            </button>
                        </div>
                        <% } %>

                        <% if (canConfirmReceived) { %>
                        <div class="order-address">
                            <button class="confirm-received-btn" onclick="confirmReceived(<%= order.getOrderId() %>)">
                                <i class="fas fa-check-circle"></i>
                                Đã nhận được hàng
                            </button>
                        </div>
                        <% } %>
                    </div>
                </div>
            <% 
                }
            } %>
        </div>
    </div>

    <script>
        // Count orders by status on page load
        document.addEventListener('DOMContentLoaded', function() {
            updateOrderCounts();
        });

        function updateOrderCounts() {
            const allCards = document.querySelectorAll('.order-card');
            const counts = {
                all: allCards.length,
                pending: 0,
                paid: 0,
                shipping: 0,
                done: 0,
                cancelled: 0
            };

            allCards.forEach(card => {
                const status = card.getAttribute('data-status');
                if (status === 'Chờ thanh toán') counts.pending++;
                else if (status === 'Đã thanh toán') counts.paid++;
                else if (status === 'Đang giao') counts.shipping++;
                else if (status === 'Hoàn thành') counts.done++;
                else if (status === 'Đã hủy') counts.cancelled++;
            });

            document.getElementById('count-all').textContent = counts.all;
            document.getElementById('count-pending').textContent = counts.pending;
            document.getElementById('count-paid').textContent = counts.paid;
            document.getElementById('count-shipping').textContent = counts.shipping;
            document.getElementById('count-done').textContent = counts.done;
            document.getElementById('count-cancelled').textContent = counts.cancelled;
        }

        function filterOrders(status) {
            // Update active tab
            document.querySelectorAll('.tab-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            event.target.closest('.tab-btn').classList.add('active');

            // Filter orders
            const allCards = document.querySelectorAll('.order-card');
            allCards.forEach(card => {
                if (status === 'all') {
                    card.style.display = 'block';
                } else {
                    if (card.getAttribute('data-status') === status) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                }
            });
        }

        function continuePayment(orderId) {
            // Lưu orderId vào session và chuyển đến trang checkout
            fetch('checkout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'action=continue&orderId=' + orderId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Chuyển đến servlet checkout (GET) để load dữ liệu
                    window.location.href = 'checkout';
                } else {
                    alert(data.message || 'Có lỗi xảy ra khi tiếp tục thanh toán');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi tiếp tục thanh toán');
            });
        }

        function confirmReceived(orderId) {
            if (!confirm('Xác nhận bạn đã nhận được hàng?')) {
                return;
            }

            const params = new URLSearchParams();
            params.append('orderId', orderId);
            params.append('action', 'confirm-received');

            fetch('update-order-status', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params.toString()
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Cảm ơn bạn! Đơn hàng đã được xác nhận hoàn thành.');
                    location.reload();
                } else {
                    alert(data.message || 'Có lỗi xảy ra');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi xác nhận đơn hàng');
            });
        }
    </script>

    <!-- AI Chatbot Widget -->
    <jsp:include page="chatbot-widget.jsp" />
</body>
</html>
