<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Cart" %>
<%@ page import="model.User" %>
<%@ page import="model.Order" %>
<%@ page import="model.OrderDetail" %>
<%@ page import="dao.OrderDAO" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("auth-login.jsp");
        return;
    }

    // Kiểm tra xem có orderId trong session không (từ order history)
    Integer pendingOrderId = (Integer) session.getAttribute("pendingOrderId");

    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
    Double totalAmount = (Double) request.getAttribute("totalAmount");
    Integer orderId = (Integer) request.getAttribute("orderId");

    // Nếu có pendingOrderId, load thông tin từ order
    if (pendingOrderId != null && cartItems == null) {
        try {
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById(pendingOrderId);

            if (order != null && "Pending".equals(order.getStatus()) && order.getUserId() == currentUser.getUserId()) {
                // Load order details và convert sang Cart để hiển thị
                List<OrderDetail> orderDetails = orderDAO.getOrderDetails(pendingOrderId);
                cartItems = new java.util.ArrayList<>();

                for (OrderDetail detail : orderDetails) {
                    Cart cart = new Cart();
                    cart.setMedicineId(detail.getMedicineId());
                    cart.setMedicineName(detail.getMedicineName());
                    cart.setPrice(detail.getPrice());
                    cart.setQuantity(detail.getQuantity());
                    cart.setTotalPrice(detail.getTotalPrice());
                    cartItems.add(cart);
                }

                totalAmount = order.getTotalAmount();
                orderId = pendingOrderId;
            } else {
                response.sendRedirect("order-history.jsp");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("order-history.jsp");
            return;
        }
    }

    if (cartItems == null || totalAmount == null || orderId == null) {
        // Redirect về cart nếu truy cập trực tiếp
        response.sendRedirect("cart-view.jsp");
        return;
    }

    if (totalAmount == 0) {
        totalAmount = 0.0;
    }

    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán</title>
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

        /* Checkout Layout */
        .checkout-layout {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 30px;
        }

        /* Checkout Form */
        .checkout-form {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .form-section {
            margin-bottom: 30px;
        }

        .section-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: #0891b2;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }

        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #0891b2;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .payment-methods {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        .payment-option {
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            padding: 15px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .payment-option:hover {
            border-color: #0891b2;
            background: #f8f9fa;
        }

        .payment-option input[type="radio"] {
            width: 20px;
            height: 20px;
            cursor: pointer;
        }

        .payment-option.selected {
            border-color: #0891b2;
            background: #f0f4ff;
        }

        .payment-icon {
            font-size: 1.5rem;
            color: #0891b2;
        }

        /* Order Summary */
        .order-summary {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 20px;
            height: fit-content;
        }

        .summary-title {
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 20px;
            color: #333;
        }

        .order-items {
            max-height: 300px;
            overflow-y: auto;
            margin-bottom: 20px;
        }

        .order-item {
            display: flex;
            gap: 12px;
            padding: 12px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .item-image {
            width: 60px;
            height: 60px;
            border-radius: 8px;
            overflow: hidden;
            flex-shrink: 0;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .item-image i {
            font-size: 1.5rem;
            color: #0891b2;
        }

        .item-info {
            flex: 1;
        }

        .item-name {
            font-weight: 600;
            color: #333;
            font-size: 0.9rem;
            margin-bottom: 5px;
        }

        .item-quantity {
            font-size: 0.85rem;
            color: #666;
        }

        .item-price {
            font-weight: 700;
            color: #0891b2;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .summary-row:last-child {
            border-bottom: none;
            padding-top: 20px;
            margin-top: 10px;
            border-top: 2px solid #0891b2;
        }

        .summary-label {
            color: #666;
        }

        .summary-value {
            font-weight: 600;
            color: #333;
        }

        .summary-total {
            font-size: 1.5rem;
            color: #0891b2;
            font-weight: 700;
        }

        .confirm-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            margin-top: 20px;
            transition: transform 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .confirm-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(8, 145, 178, 0.4);
        }

        .confirm-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        .order-status {
            background: #fff3cd;
            border: 1px solid #ffc107;
            border-radius: 8px;
            padding: 12px 15px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: #856404;
        }

        .order-status i {
            font-size: 1.2rem;
        }

        @media (max-width: 968px) {
            .checkout-layout {
                grid-template-columns: 1fr;
            }

            .order-summary {
                position: static;
            }

            .payment-methods {
                grid-template-columns: 1fr;
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
            
            <a href="cart-view.jsp" class="back-link">
                <i class="fas fa-arrow-left"></i>
                <span>Quay lại giỏ hàng</span>
            </a>
        </div>
    </header>

    <div class="container">
        <h1 class="page-title">
            <i class="fas fa-credit-card"></i>
            Thanh Toán
        </h1>

        <div class="checkout-layout">
            <!-- Checkout Form -->
            <div class="checkout-form">
                <div class="order-status">
                    <i class="fas fa-clock"></i>
                    <span>Đơn hàng #<%= orderId %> đang chờ xác nhận</span>
                </div>

                <form id="checkoutForm">
                    <!-- Shipping Information -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="fas fa-user"></i>
                            Thông Tin Người Nhận
                        </h3>
                        
                        <div class="form-group">
                            <label>Họ và tên người nhận *</label>
                            <input type="text" name="receiverName" required placeholder="Nhập họ tên người nhận" value="<%= currentUser.getName() %>">
                        </div>
                        
                        <div class="form-group">
                            <label>Số điện thoại *</label>
                            <input type="tel" name="receiverPhone" required placeholder="Nhập số điện thoại" value="<%= currentUser.getPhone() != null ? currentUser.getPhone() : "" %>">
                        </div>
                        
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email" value="<%= currentUser.getEmail() %>" readonly>
                        </div>
                    </div>

                    <!-- Delivery Address -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="fas fa-map-marker-alt"></i>
                            Địa Chỉ Giao Hàng
                        </h3>
                        
                        <div class="form-group">
                            <label>Địa chỉ chi tiết *</label>
                            <textarea name="shippingAddress" required placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố"></textarea>
                        </div>
                        
                        <div class="form-group">
                            <label>Ghi chú đơn hàng</label>
                            <textarea name="orderNote" placeholder="Ghi chú cho người giao hàng (tùy chọn)" style="min-height: 80px;"></textarea>
                        </div>
                    </div>

                    <!-- Payment Method -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="fas fa-wallet"></i>
                            Phương Thức Thanh Toán
                        </h3>
                        
                        <div class="payment-methods">
                            <label class="payment-option selected">
                                <input type="radio" name="paymentMethod" value="COD" checked>
                                <div class="payment-icon"><i class="fas fa-money-bill-wave"></i></div>
                                <div>
                                    <div style="font-weight: 600;">Thanh toán khi nhận hàng</div>
                                    <div style="font-size: 0.85rem; color: #666;">COD</div>
                                </div>
                            </label>
                            
                            <label class="payment-option">
                                <input type="radio" name="paymentMethod" value="Banking">
                                <div class="payment-icon"><i class="fas fa-university"></i></div>
                                <div>
                                    <div style="font-weight: 600;">Chuyển khoản ngân hàng</div>
                                    <div style="font-size: 0.85rem; color: #666;">Banking</div>
                                </div>
                            </label>
                            
                            <label class="payment-option">
                                <input type="radio" name="paymentMethod" value="Credit Card">
                                <div class="payment-icon"><i class="fas fa-credit-card"></i></div>
                                <div>
                                    <div style="font-weight: 600;">Thẻ tín dụng</div>
                                    <div style="font-size: 0.85rem; color: #666;">Visa/Master</div>
                                </div>
                            </label>
                            
                            <label class="payment-option">
                                <input type="radio" name="paymentMethod" value="E-Wallet">
                                <div class="payment-icon"><i class="fas fa-mobile-alt"></i></div>
                                <div>
                                    <div style="font-weight: 600;">Ví điện tử</div>
                                    <div style="font-size: 0.85rem; color: #666;">Momo/ZaloPay</div>
                                </div>
                            </label>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Order Summary -->
            <div class="order-summary">
                <h3 class="summary-title">Đơn Hàng</h3>
                
                <div class="order-items">
                    <% for (Cart item : cartItems) { 
                        double itemPrice = item.getEffectivePrice();
                    %>
                        <div class="order-item">
                            <div class="item-image">
                                <% if (item.getMedicineImage() != null && !item.getMedicineImage().isEmpty()) { 
                                    String imgPath = item.getMedicineImage();
                                    if (!imgPath.startsWith("image/")) {
                                        imgPath = "image/" + imgPath;
                                    }
                                %>
                                    <img src="<%= imgPath %>" alt="<%= item.getMedicineName() %>">
                                <% } else { %>
                                    <i class="fas fa-pills"></i>
                                <% } %>
                            </div>
                            
                            <div class="item-info">
                                <div class="item-name"><%= item.getMedicineName() %></div>
                                <div class="item-quantity">Số lượng: <%= item.getQuantity() %></div>
                            </div>
                            
                            <div class="item-price"><%= String.format("%,d", (long)item.getTotalPrice()) %>đ</div>
                        </div>
                    <% } %>
                </div>
                
                <div class="summary-row">
                    <span class="summary-label">Tạm tính:</span>
                    <span class="summary-value"><%= String.format("%,d", (totalAmount != null ? totalAmount.longValue() : 0)) %>đ</span>
                </div>
                
                <div class="summary-row">
                    <span class="summary-label">Phí vận chuyển:</span>
                    <span class="summary-value">Miễn phí</span>
                </div>
                
                <div class="summary-row">
                    <span class="summary-label">Tổng cộng:</span>
                    <span class="summary-total"><%= String.format("%,d", (totalAmount != null ? totalAmount.longValue() : 0)) %>đ</span>
                </div>
                
                <button class="confirm-btn" onclick="confirmPayment()">
                    <i class="fas fa-check-circle"></i>
                    Xác Nhận Thanh Toán
                </button>
            </div>
        </div>
    </div>

    <script>
        // Payment method selection
        document.querySelectorAll('.payment-option').forEach(option => {
            option.addEventListener('click', function() {
                document.querySelectorAll('.payment-option').forEach(opt => opt.classList.remove('selected'));
                this.classList.add('selected');
            });
        });

        function confirmPayment() {
            const form = document.getElementById('checkoutForm');
            const receiverName = form.querySelector('[name="receiverName"]').value.trim();
            const receiverPhone = form.querySelector('[name="receiverPhone"]').value.trim();
            const shippingAddress = form.querySelector('[name="shippingAddress"]').value.trim();
            const orderNote = form.querySelector('[name="orderNote"]').value.trim();
            const paymentMethod = form.querySelector('[name="paymentMethod"]:checked').value;
            
            if (!receiverName) {
                alert('Vui lòng nhập tên người nhận');
                return;
            }
            
            if (!receiverPhone) {
                alert('Vui lòng nhập số điện thoại');
                return;
            }
            
            if (!shippingAddress) {
                alert('Vui lòng nhập địa chỉ giao hàng');
                return;
            }
            
            if (!confirm('Xác nhận thanh toán đơn hàng này?')) {
                return;
            }
            
            const btn = document.querySelector('.confirm-btn');
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';

            // Gộp thông tin giao hàng
            let fullAddress = 'Người nhận: ' + receiverName + '\nSĐT: ' + receiverPhone + '\nĐịa chỉ: ' + shippingAddress;
            if (orderNote) {
                fullAddress += '\nGhi chú: ' + orderNote;
            }

            const params = new URLSearchParams();
            params.append('shippingAddress', fullAddress);
            params.append('paymentMethod', paymentMethod);
            
            fetch('confirm-payment', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params.toString()
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.message);
                    window.location.href = 'order-history.jsp';
                } else {
                    alert(data.message);
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fas fa-check-circle"></i> Xác Nhận Thanh Toán';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra');
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-check-circle"></i> Xác Nhận Thanh Toán';
            });
        }
    </script>
</body>
</html>
