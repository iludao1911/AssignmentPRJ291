<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Cart" %>
<%@ page import="model.User" %>
<%@ page import="dao.CartDAO" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%
    // Kiểm tra đăng nhập
    Object userObj = session.getAttribute("currentUser");
    User currentUser = null;
    if (userObj instanceof User) {
        currentUser = (User) userObj;
    }
    
    if (currentUser == null) {
        response.sendRedirect("auth-login.jsp");
        return;
    }
    
    // Lấy giỏ hàng
    CartDAO cartDAO = new CartDAO();
    List<Cart> cartItems = null;
    try {
        cartItems = cartDAO.getCartByUserId(currentUser.getUserId());
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    // Tính tổng tiền
    double totalAmount = 0;
    if (cartItems != null) {
        for (Cart item : cartItems) {
            totalAmount += item.getTotalPrice();
        }
    }
    
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ Hàng - Nhà Thuốc MS</title>
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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

        /* Header Actions */
        .header-actions {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .header-actions a {
            color: white;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 8px;
            transition: background 0.3s;
        }

        .header-actions a:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        /* Search Bar */
        .search-container {
            position: relative;
            margin-right: 20px;
        }

        .search-container input {
            padding: 10px 40px 10px 15px;
            border: none;
            border-radius: 25px;
            width: 300px;
            font-size: 0.95rem;
            outline: none;
        }

        .search-container i {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #667eea;
        }

        /* Cart Icon */
        .cart-icon {
            position: relative;
            padding: 10px 15px !important;
        }

        .cart-icon i {
            font-size: 1.3rem;
        }

        .cart-count {
            position: absolute;
            top: 5px;
            right: 8px;
            background: #ff4757;
            color: white;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.7rem;
            font-weight: bold;
        }

        /* User Menu */
        .user-menu {
            position: relative;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            overflow: hidden;
            cursor: pointer;
            border: 2px solid white;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, 0.1);
        }

        .user-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .user-avatar i {
            font-size: 1.5rem;
        }

        .dropdown-menu {
            position: absolute;
            top: 55px;
            right: 0;
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
            min-width: 200px;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.3s;
            z-index: 1000;
        }

        .user-menu:hover .dropdown-menu {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .dropdown-menu .user-info {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
        }

        .dropdown-menu .user-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }

        .dropdown-menu .user-email {
            font-size: 0.85rem;
            color: #999;
        }

        .dropdown-menu a {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 15px;
            color: #333;
            text-decoration: none;
            transition: background 0.3s;
        }

        .dropdown-menu a:hover {
            background: #f8f9fa;
        }

        .dropdown-menu a i {
            color: #667eea;
            width: 20px;
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
            color: #667eea;
        }

        /* Cart Layout */
        .cart-layout {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 30px;
        }

        /* Cart Items */
        .cart-items {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .empty-cart {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .empty-cart i {
            font-size: 5rem;
            color: #ddd;
            margin-bottom: 20px;
        }

        .empty-cart h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
        }

        .empty-cart a {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 25px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            transition: transform 0.3s;
            font-size: 0.95rem;
        }

        .empty-cart a:hover {
            transform: translateY(-2px);
        }

        .cart-item {
            display: flex;
            gap: 20px;
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
            transition: background 0.3s;
        }

        .cart-item:last-child {
            border-bottom: none;
        }

        .cart-item:hover {
            background: #f8f9fa;
        }

        .item-image {
            width: 100px;
            height: 100px;
            border-radius: 10px;
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
            font-size: 2.5rem;
            color: #667eea;
        }

        .item-details {
            flex: 1;
        }

        .item-name {
            font-size: 1.1rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }

        .item-price {
            font-size: 1.2rem;
            color: #667eea;
            font-weight: 700;
            margin-bottom: 15px;
        }

        .item-controls {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .quantity-control {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .quantity-control button {
            width: 30px;
            height: 30px;
            border: 1px solid #ddd;
            background: white;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .quantity-control button:hover {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        .quantity-control input {
            width: 50px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 5px;
        }

        .remove-btn {
            color: #dc3545;
            background: none;
            border: none;
            cursor: pointer;
            padding: 5px 10px;
            border-radius: 5px;
            transition: all 0.3s;
        }

        .remove-btn:hover {
            background: #dc3545;
            color: white;
        }

        /* Cart Summary */
        .cart-summary {
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
            border-top: 2px solid #667eea;
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
            color: #667eea;
            font-weight: 700;
        }

        .checkout-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            margin-top: 20px;
            transition: transform 0.3s;
        }

        .checkout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.4);
        }

        .continue-shopping {
            width: 100%;
            padding: 12px;
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            margin-top: 10px;
            transition: all 0.3s;
            text-decoration: none;
            display: block;
            text-align: center;
        }

        .continue-shopping:hover {
            background: #667eea;
            color: white;
        }

        @media (max-width: 968px) {
            .cart-layout {
                grid-template-columns: 1fr;
            }

            .cart-summary {
                position: static;
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
            
            <div class="header-actions">                
                <a href="cart-view.jsp" class="cart-icon">
                    <i class="fas fa-shopping-cart"></i>
                    <% 
                        int cartCount = 0;
                        try {
                            cartCount = cartDAO.getCartCount(currentUser.getUserId());
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                    <span class="cart-count"><%= cartCount %></span>
                </a>
                
                <div class="user-menu">
                    <div class="user-avatar">
                        <% if (currentUser.getImage() != null && !currentUser.getImage().isEmpty()) { %>
                            <img src="<%= currentUser.getImage() %>" alt="<%= currentUser.getName() %>">
                        <% } else { %>
                            <i class="fas fa-user-circle"></i>
                        <% } %>
                    </div>
                    <div class="dropdown-menu">
                        <div class="user-info">
                            <p class="user-name"><%= currentUser.getName() %></p>
                            <p class="user-email"><%= currentUser.getEmail() %></p>
                        </div>
                        <a href="profile.jsp"><i class="fas fa-user"></i> Tài khoản</a>
                        <a href="order-history.jsp"><i class="fas fa-history"></i> Đơn hàng</a>
                        <a href="logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <div class="container">
        <h1 class="page-title">
            <i class="fas fa-shopping-cart"></i>
            Giỏ Hàng Của Bạn
        </h1>

        <% if (cartItems == null || cartItems.isEmpty()) { %>
            <div class="cart-items">
                <div class="empty-cart">
                    <i class="fas fa-shopping-cart"></i>
                    <h3>Giỏ hàng trống</h3>
                    <p>Bạn chưa có sản phẩm nào trong giỏ hàng</p>
                    <a href="home.jsp">
                        <i class="fas fa-arrow-left"></i>
                        Tiếp tục mua sắm
                    </a>
                </div>
            </div>
        <% } else { %>
            <div class="cart-layout">
                <!-- Cart Items -->
                <div class="cart-items">
                    <% for (Cart item : cartItems) { 
                        double itemPrice = (item.getMedicineSalePrice() != null && item.getMedicineSalePrice() > 0) 
                            ? item.getMedicineSalePrice() 
                            : item.getMedicinePrice();
                    %>
                        <div class="cart-item" data-cart-id="<%= item.getCartId() %>" data-medicine-id="<%= item.getMedicineId() %>">
                            <div class="item-image">
                                <% if (item.getMedicineImage() != null && !item.getMedicineImage().isEmpty()) { %>
                                    <img src="image/<%= item.getMedicineImage() %>" alt="<%= item.getMedicineName() %>">
                                <% } else { %>
                                    <i class="fas fa-pills"></i>
                                <% } %>
                            </div>
                            
                            <div class="item-details">
                                <div class="item-name"><%= item.getMedicineName() %></div>
                                <div class="item-price"><%= String.format("%,d", (long)itemPrice) %>đ</div>
                                
                                <div class="item-controls">
                                    <div class="quantity-control">
                                        <button onclick="updateQuantity(<%= item.getMedicineId() %>, -1)">
                                            <i class="fas fa-minus"></i>
                                        </button>
                                        <input type="number" value="<%= item.getQuantity() %>" min="1" readonly>
                                        <button onclick="updateQuantity(<%= item.getMedicineId() %>, 1)">
                                            <i class="fas fa-plus"></i>
                                        </button>
                                    </div>
                                    
                                    <button class="remove-btn" onclick="removeItem(<%= item.getMedicineId() %>)">
                                        <i class="fas fa-trash"></i> Xóa
                                    </button>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>

                <!-- Cart Summary -->
                <div class="cart-summary">
                    <h3 class="summary-title">Tổng Đơn Hàng</h3>
                    
                    <div class="summary-row">
                        <span class="summary-label">Tạm tính:</span>
                        <span class="summary-value"><%= String.format("%,d", (long)totalAmount) %>đ</span>
                    </div>
                    
                    <div class="summary-row">
                        <span class="summary-label">Phí vận chuyển:</span>
                        <span class="summary-value">Miễn phí</span>
                    </div>
                    
                    <div class="summary-row">
                        <span class="summary-label">Tổng cộng:</span>
                        <span class="summary-total"><%= String.format("%,d", (long)totalAmount) %>đ</span>
                    </div>
                    
                    <button class="checkout-btn" onclick="checkout()">
                        <i class="fas fa-credit-card"></i>
                        Thanh Toán
                    </button>
                    
                    <a href="home.jsp" class="continue-shopping">
                        <i class="fas fa-arrow-left"></i>
                        Tiếp tục mua sắm
                    </a>
                </div>
            </div>
        <% } %>
    </div>

    <script>
        function updateQuantity(medicineId, change) {
            const cartItem = document.querySelector(`[data-medicine-id="${medicineId}"]`);
            const input = cartItem.querySelector('input[type="number"]');
            let newQuantity = parseInt(input.value) + change;
            
            if (newQuantity < 1) {
                if (confirm('Bạn muốn xóa sản phẩm này khỏi giỏ hàng?')) {
                    removeItem(medicineId);
                }
                return;
            }
            
            // Call API to update
            const params = new URLSearchParams();
            params.append('medicineId', medicineId);
            params.append('quantity', newQuantity);
            params.append('action', 'update');
            
            fetch('cart-update', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params.toString()
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert(data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra');
            });
        }

        function removeItem(medicineId) {
            if (!confirm('Bạn có chắc muốn xóa sản phẩm này?')) {
                return;
            }
            
            const params = new URLSearchParams();
            params.append('medicineId', medicineId);
            params.append('action', 'remove');
            
            fetch('cart-update', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params.toString()
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert(data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra');
            });
        }

        function checkout() {
            alert('Chức năng thanh toán đang được phát triển!');
            // window.location.href = 'checkout.jsp';
        }
    </script>
</body>
</html>
