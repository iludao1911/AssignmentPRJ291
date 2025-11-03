<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Medicine, model.Review, model.User, java.util.List, java.text.NumberFormat, java.util.Locale, java.text.SimpleDateFormat" %>
<%
    Medicine medicine = (Medicine) request.getAttribute("medicine");
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    Double avgRating = (Double) request.getAttribute("avgRating");
    Integer reviewCount = (Integer) request.getAttribute("reviewCount");
    
    if (medicine == null) {
        response.sendRedirect("home.jsp");
        return;
    }
    
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat reviewDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    
    // Lấy thông tin user từ session
    Object userObj = session.getAttribute("currentUser");
    User currentUser = null;
    if (userObj instanceof User) {
        currentUser = (User) userObj;
    }
    
    // Tính giá hiển thị
    double displayPrice = medicine.getPrice().doubleValue();
    double discount = 0;
    if (medicine.getSalePrice() != null && medicine.getSalePrice().compareTo(java.math.BigDecimal.ZERO) > 0) {
        displayPrice = medicine.getSalePrice().doubleValue();
        discount = (int) Math.round(((medicine.getPrice().subtract(medicine.getSalePrice()).doubleValue()) / medicine.getPrice().doubleValue()) * 100);
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= medicine.getName() %> - Nhà Thuốc MS</title>
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

        .search-bar {
            flex: 1;
            max-width: 600px;
            margin: 0 40px;
            position: relative;
        }

        .search-bar input {
            width: 100%;
            padding: 12px 50px 12px 20px;
            border: none;
            border-radius: 25px;
            font-size: 0.95rem;
            outline: none;
        }

        .search-bar button {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
            border: none;
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            cursor: pointer;
            font-size: 0.9rem;
        }

        .header-actions {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .header-actions a {
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 15px;
            border-radius: 8px;
            transition: background 0.3s;
        }

        .header-actions a:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        .user-menu {
            position: relative;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: white;
            color: #0891b2;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 1.1rem;
            cursor: pointer;
            border: 2px solid rgba(255, 255, 255, 0.3);
            transition: all 0.3s;
        }

        .user-avatar:hover {
            transform: scale(1.05);
            border-color: white;
        }

        .dropdown-menu {
            position: absolute;
            top: 55px;
            right: 0;
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.15);
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

        .dropdown-menu::before {
            content: '';
            position: absolute;
            top: -8px;
            right: 15px;
            width: 0;
            height: 0;
            border-left: 8px solid transparent;
            border-right: 8px solid transparent;
            border-bottom: 8px solid white;
        }

        .dropdown-header {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
        }

        .dropdown-header .user-name {
            font-weight: 600;
            color: #333;
            font-size: 1rem;
        }

        .dropdown-header .user-email {
            font-size: 0.85rem;
            color: #999;
            margin-top: 3px;
        }

        .dropdown-menu a {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 15px;
            color: #333;
            text-decoration: none;
            transition: background 0.2s;
        }

        .dropdown-menu a:hover {
            background: #f8f9fa;
        }

        .dropdown-menu a i {
            width: 20px;
            text-align: center;
            color: #0891b2;
        }

        .dropdown-menu a.logout-link {
            color: #dc3545;
            border-top: 1px solid #f0f0f0;
        }

        .dropdown-menu a.logout-link i {
            color: #dc3545;
        }

        .btn-login {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            transition: all 0.3s;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .btn-login:hover {
            background: rgba(255, 255, 255, 0.3);
            border-color: white;
        }

        .container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: white;
            color: #0891b2;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            margin-bottom: 20px;
            transition: all 0.3s;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .back-button:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            transform: translateY(-2px);
        }

        .detail-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }

        .product-header {
            display: grid;
            grid-template-columns: 400px 1fr;
            gap: 40px;
            padding: 40px;
        }

        .product-image-section {
            position: relative;
        }

        .product-image {
            width: 100%;
            height: 400px;
            background: #f8f9fa;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .product-image img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }

        .discount-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: #e74c3c;
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 1.1rem;
        }

        .product-info-section {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .product-category {
            color: #0891b2;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9rem;
        }

        .product-name {
            font-size: 2.5rem;
            font-weight: 700;
            color: #2d3748;
            margin: 10px 0;
        }

        .rating-section {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .stars {
            color: #ffc107;
            font-size: 1.5rem;
        }

        .rating-text {
            color: #666;
            font-size: 1.1rem;
        }

        .price-section {
            display: flex;
            align-items: center;
            gap: 15px;
            margin: 20px 0;
        }

        .current-price {
            font-size: 2.5rem;
            font-weight: 700;
            color: #0891b2;
        }

        .original-price {
            font-size: 1.5rem;
            color: #999;
            text-decoration: line-through;
        }

        .product-meta {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .meta-item i {
            color: #0891b2;
            font-size: 1.2rem;
        }

        .meta-label {
            color: #666;
            font-size: 0.9rem;
        }

        .meta-value {
            color: #333;
            font-weight: 600;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }

        .btn {
            flex: 1;
            padding: 15px 30px;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(8, 145, 178, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #ff6b35 0%, #f7931e 100%);
            color: white;
            border: none;
            box-shadow: 0 2px 8px rgba(255, 107, 53, 0.3);
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 107, 53, 0.5);
        }

        .description-section {
            padding: 40px;
            border-top: 1px solid #e0e0e0;
        }

        .section-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: #0891b2;
        }

        .description-content {
            color: #555;
            line-height: 1.8;
            font-size: 1.1rem;
        }

        .reviews-section {
            padding: 40px;
            background: #f8f9fa;
        }

        .review-form {
            background: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
        }

        .rating-input {
            display: flex;
            gap: 10px;
            margin: 20px 0;
        }

        .rating-input i {
            font-size: 2rem;
            color: #ddd;
            cursor: pointer;
            transition: all 0.2s;
        }

        .rating-input i:hover,
        .rating-input i.active {
            color: #ffc107;
            transform: scale(1.2);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .form-group textarea {
            width: 100%;
            padding: 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 1rem;
            font-family: inherit;
            resize: vertical;
            min-height: 100px;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: #0891b2;
        }

        .review-item {
            background: white;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 20px;
        }

        .review-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
        }

        .reviewer-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 1.3rem;
        }

        .reviewer-avatar img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
        }

        .reviewer-info {
            flex: 1;
        }

        .reviewer-name {
            font-weight: 700;
            color: #333;
            font-size: 1.1rem;
        }

        .review-date {
            color: #999;
            font-size: 0.9rem;
        }

        .review-stars {
            color: #ffc107;
        }

        .review-comment {
            color: #555;
            line-height: 1.6;
            margin-top: 10px;
        }

        .no-reviews {
            text-align: center;
            padding: 40px;
            color: #999;
        }

        @media (max-width: 768px) {
            .product-header {
                grid-template-columns: 1fr;
            }
            
            .product-meta {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
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
            
            <div class="search-bar">
                <input type="text" placeholder="Tìm kiếm thuốc, sản phẩm sức khỏe...">
                <button><i class="fas fa-search"></i></button>
            </div>
            
            <div class="header-actions">
                <% if (currentUser != null) { %>
                    <!-- Giỏ hàng -->
                    <a href="cart-view.jsp">
                        <i class="fas fa-shopping-cart"></i>
                        <span>Giỏ hàng</span>
                    </a>
                    
                    <!-- User Menu với Avatar -->
                    <div class="user-menu">
                        <div class="user-avatar" title="<%= currentUser.getName() %>">
                            <% if (currentUser.getImage() != null && !currentUser.getImage().isEmpty()) { %>
                                <img src="<%= currentUser.getImage() %>" alt="<%= currentUser.getName() %>" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
                            <% } else { %>
                                <%= currentUser.getName().substring(0, 1).toUpperCase() %>
                            <% } %>
                        </div>
                        <div class="dropdown-menu">
                            <div class="dropdown-header">
                                <div class="user-name"><%= currentUser.getName() %></div>
                                <div class="user-email"><%= currentUser.getEmail() %></div>
                            </div>
                            <a href="profile.jsp">
                                <i class="fas fa-user"></i>
                                <span>Hồ Sơ</span>
                            </a>
                            <a href="order-history.jsp">
                                <i class="fas fa-box"></i>
                                <span>Đơn Hàng</span>
                            </a>
                            <% if (currentUser.getRole().equals("Admin")) { %>
                            <a href="admin-dashboard.jsp">
                                <i class="fas fa-tachometer-alt"></i>
                                <span>Quản Trị</span>
                            </a>
                            <% } %>
                            <a href="logout" class="logout-link">
                                <i class="fas fa-sign-out-alt"></i>
                                <span>Đăng Xuất</span>
                            </a>
                        </div>
                    </div>
                <% } else { %>
                    <!-- Nút Đăng nhập khi chưa login -->
                    <a href="auth-login.jsp" class="btn-login">
                        <i class="fas fa-sign-in-alt"></i>
                        <span>Đăng Nhập</span>
                    </a>
                <% } %>
            </div>
        </div>
    </header>

    <div class="container">
        <a href="home.jsp" class="back-button">
            <i class="fas fa-arrow-left"></i>
            Quay lại
        </a>

        <div class="detail-card">
            <!-- Product Header -->
            <div class="product-header">
                <div class="product-image-section">
                    <% if (discount > 0) { %>
                        <div class="discount-badge">-<%= discount %>%</div>
                    <% } %>
                    <div class="product-image">
                        <% if (medicine.getImagePath() != null && !medicine.getImagePath().isEmpty()) { 
                            String imgPath = medicine.getImagePath();
                            if (!imgPath.startsWith("image/")) {
                                imgPath = "image/" + imgPath;
                            }
                        %>
                            <img src="<%= imgPath %>" alt="<%= medicine.getName() %>" 
                                 onerror="this.parentElement.innerHTML='<i class=\'fas fa-pills\' style=\'font-size:5rem;color:#ddd;\'></i>'">
                        <% } else { %>
                            <i class="fas fa-pills" style="font-size: 5rem; color: #ddd;"></i>
                        <% } %>
                    </div>
                </div>

                <div class="product-info-section">
                    <div class="product-category"><%= medicine.getCategory() != null ? medicine.getCategory() : "Thuốc" %></div>
                    <h1 class="product-name"><%= medicine.getName() %></h1>
                    
                    <div class="rating-section">
                        <div class="stars">
                            <% 
                            int fullStars = (int) Math.floor(avgRating);
                            for (int i = 0; i < fullStars; i++) { %>
                                <i class="fas fa-star"></i>
                            <% } 
                            if (avgRating % 1 >= 0.5) { %>
                                <i class="fas fa-star-half-alt"></i>
                                <% fullStars++; %>
                            <% }
                            for (int i = fullStars; i < 5; i++) { %>
                                <i class="far fa-star"></i>
                            <% } %>
                        </div>
                        <span class="rating-text"><%= String.format("%.1f", avgRating) %> (<%= reviewCount %> đánh giá)</span>
                    </div>

                    <div class="price-section">
                        <span class="current-price"><%= String.format("%,d", (long)displayPrice) %>đ</span>
                        <% if (discount > 0) { %>
                            <span class="original-price"><%= String.format("%,d", medicine.getPrice().longValue()) %>đ</span>
                        <% } %>
                    </div>

                    <div class="product-meta">
                        <div class="meta-item">
                            <i class="fas fa-boxes"></i>
                            <div>
                                <div class="meta-label">Còn lại</div>
                                <div class="meta-value"><%= medicine.getQuantity() %> sản phẩm</div>
                            </div>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-calendar-alt"></i>
                            <div>
                                <div class="meta-label">Hạn sử dụng</div>
                                <div class="meta-value">
                                    <%= medicine.getExpiryDate() != null ? dateFormat.format(medicine.getExpiryDate()) : "N/A" %>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="quantity-selector" style="margin: 20px 0;">
                        <label style="font-weight: 600; color: #333; margin-bottom: 10px; display: block;">Số lượng:</label>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <button onclick="changeQuantity(-1)" style="width: 40px; height: 40px; border: 2px solid #0891b2; background: white; color: #0891b2; border-radius: 8px; cursor: pointer; font-size: 1.2rem; transition: all 0.3s;">
                                <i class="fas fa-minus"></i>
                            </button>
                            <input type="number" id="quantityInput" value="1" min="1" max="<%= medicine.getQuantity() %>"
                                   style="width: 80px; text-align: center; border: 2px solid #e0e0e0; border-radius: 8px; padding: 10px; font-size: 1.1rem; font-weight: 600;">
                            <button onclick="changeQuantity(1)" style="width: 40px; height: 40px; border: 2px solid #0891b2; background: white; color: #0891b2; border-radius: 8px; cursor: pointer; font-size: 1.2rem; transition: all 0.3s;">
                                <i class="fas fa-plus"></i>
                            </button>
                            <span style="color: #999; font-size: 0.9rem;">(Tối đa: <%= medicine.getQuantity() %>)</span>
                        </div>
                    </div>

                    <div class="action-buttons">
                        <button class="btn btn-primary" onclick="addToCart()">
                            <i class="fas fa-shopping-cart"></i>
                            Thêm vào giỏ
                        </button>
                        <button class="btn btn-secondary" onclick="buyNow()">
                            <i class="fas fa-bolt"></i>
                            Mua ngay
                        </button>
                    </div>
                </div>
            </div>

            <!-- Description Section -->
            <div class="description-section">
                <h2 class="section-title">
                    <i class="fas fa-info-circle"></i>
                    Mô tả sản phẩm
                </h2>
                <div class="description-content">
                    <%= medicine.getDescription() != null ? medicine.getDescription() : "Chưa có mô tả chi tiết" %>
                </div>
            </div>

            <!-- Reviews Section -->
            <div class="reviews-section">
                <h2 class="section-title">
                    <i class="fas fa-comments"></i>
                    Đánh giá (<%= reviewCount %>)
                </h2>

                <% if (currentUser != null) { %>
                    <div class="review-form">
                        <h3 style="margin-bottom: 20px;">Viết đánh giá của bạn</h3>
                        <form id="reviewForm">
                            <input type="hidden" name="medicineId" value="<%= medicine.getMedicineId() %>">
                            
                            <div class="form-group">
                                <label>Đánh giá của bạn *</label>
                                <div class="rating-input">
                                    <i class="far fa-star" data-rating="1"></i>
                                    <i class="far fa-star" data-rating="2"></i>
                                    <i class="far fa-star" data-rating="3"></i>
                                    <i class="far fa-star" data-rating="4"></i>
                                    <i class="far fa-star" data-rating="5"></i>
                                </div>
                                <input type="hidden" name="rating" id="ratingValue" value="0">
                            </div>

                            <div class="form-group">
                                <label>Nhận xét của bạn</label>
                                <textarea name="comment" placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm này..."></textarea>
                            </div>

                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-paper-plane"></i>
                                Gửi đánh giá
                            </button>
                        </form>
                    </div>
                <% } else { %>
                    <div class="review-form">
                        <p style="text-align: center; color: #999;">
                            <a href="auth-login.jsp" style="color: #0891b2; text-decoration: none; font-weight: 600;">Đăng nhập</a> 
                            để viết đánh giá
                        </p>
                    </div>
                <% } %>

                <!-- Reviews List -->
                <div id="reviewsList">
                    <% if (reviews != null && !reviews.isEmpty()) {
                        for (Review review : reviews) { %>
                            <div class="review-item">
                                <div class="review-header">
                                    <div class="reviewer-avatar">
                                        <% if (review.getUserImage() != null && !review.getUserImage().isEmpty()) { %>
                                            <img src="<%= review.getUserImage() %>" alt="<%= review.getUserName() %>">
                                        <% } else { %>
                                            <%= review.getUserName().substring(0, 1).toUpperCase() %>
                                        <% } %>
                                    </div>
                                    <div class="reviewer-info">
                                        <div class="reviewer-name"><%= review.getUserName() %></div>
                                        <div class="review-date"><%= reviewDateFormat.format(review.getCreatedAt()) %></div>
                                    </div>
                                    <div class="review-stars">
                                        <% for (int i = 0; i < review.getRating(); i++) { %>
                                            <i class="fas fa-star"></i>
                                        <% } 
                                        for (int i = review.getRating(); i < 5; i++) { %>
                                            <i class="far fa-star"></i>
                                        <% } %>
                                    </div>
                                </div>
                                <div class="review-comment"><%= review.getComment() != null ? review.getComment() : "" %></div>
                            </div>
                        <% }
                    } else { %>
                        <div class="no-reviews">
                            <i class="far fa-comment-dots" style="font-size: 3rem; color: #ddd; margin-bottom: 10px;"></i>
                            <p>Chưa có đánh giá nào. Hãy là người đầu tiên đánh giá sản phẩm này!</p>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Quantity selector
        const maxQuantity = <%= medicine.getQuantity() %>;

        function changeQuantity(change) {
            const input = document.getElementById('quantityInput');
            let newValue = parseInt(input.value) + change;

            if (newValue < 1) {
                newValue = 1;
            } else if (newValue > maxQuantity) {
                newValue = maxQuantity;
                alert('Số lượng tối đa là ' + maxQuantity);
            }

            input.value = newValue;
        }

        // Validate quantity input
        document.getElementById('quantityInput').addEventListener('change', function() {
            let value = parseInt(this.value);

            if (isNaN(value) || value < 1) {
                this.value = 1;
            } else if (value > maxQuantity) {
                this.value = maxQuantity;
                alert('Số lượng tối đa là ' + maxQuantity);
            }
        });

        // Rating input functionality
        const ratingStars = document.querySelectorAll('.rating-input i');
        const ratingValue = document.getElementById('ratingValue');

        if (ratingStars.length > 0 && ratingValue) {
            ratingStars.forEach(star => {
                star.addEventListener('click', function() {
                    const rating = this.getAttribute('data-rating');
                    ratingValue.value = rating;

                    // Update stars display
                    ratingStars.forEach((s, index) => {
                        if (index < rating) {
                            s.classList.remove('far');
                            s.classList.add('fas', 'active');
                        } else {
                            s.classList.remove('fas', 'active');
                            s.classList.add('far');
                        }
                    });
                });
            });
        }

        // Review form submission
        const reviewForm = document.getElementById('reviewForm');
        if (reviewForm && ratingValue) {
            reviewForm.addEventListener('submit', function(e) {
                e.preventDefault();
                
                const rating = ratingValue.value;
                if (rating == 0 || rating == '') {
                    alert('Vui lòng chọn số sao đánh giá');
                    return;
                }
                
                // Lấy data từ form
                const medicineId = document.querySelector('input[name="medicineId"]').value;
                const comment = document.querySelector('textarea[name="comment"]').value;
                
                // Tạo URLSearchParams thay vì FormData
                const params = new URLSearchParams();
                params.append('medicineId', medicineId);
                params.append('rating', rating);
                params.append('comment', comment);
                
                // Debug log
                console.log('Sending review data:');
                console.log('Medicine ID:', medicineId);
                console.log('Rating:', rating);
                console.log('Comment:', comment);
                
                fetch('add-review', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: params.toString()
                })
                .then(response => {
                    console.log('Response status:', response.status);
                    return response.json();
                })
                .then(data => {
                    console.log('Response data:', data);
                    if (data.success) {
                        alert(data.message);
                        location.reload();
                    } else {
                        alert(data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra, vui lòng thử lại');
                });
            });
        }

        function addToCart() {
            <% if (currentUser == null) { %>
                alert('Vui lòng đăng nhập để thêm vào giỏ hàng');
                window.location.href = 'auth-login.jsp';
                return;
            <% } %>

            const medicineId = <%= medicine.getMedicineId() %>;
            const quantity = parseInt(document.getElementById('quantityInput').value);

            if (isNaN(quantity) || quantity < 1) {
                alert('Vui lòng nhập số lượng hợp lệ');
                return;
            }

            const params = new URLSearchParams();
            params.append('medicineId', medicineId);
            params.append('quantity', quantity);

            fetch('add-to-cart', {
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
                    // Update cart count if needed
                    if (data.cartCount) {
                        // You can update cart badge here
                        console.log('Cart count:', data.cartCount);
                    }
                } else {
                    alert(data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra, vui lòng thử lại');
            });
        }

        function buyNow() {
            <% if (currentUser == null) { %>
                alert('Vui lòng đăng nhập để mua hàng');
                window.location.href = 'auth-login.jsp';
                return;
            <% } %>

            // Thêm vào giỏ hàng trước
            const medicineId = <%= medicine.getMedicineId() %>;
            const quantity = parseInt(document.getElementById('quantityInput').value);

            if (isNaN(quantity) || quantity < 1) {
                alert('Vui lòng nhập số lượng hợp lệ');
                return;
            }

            const params = new URLSearchParams();
            params.append('medicineId', medicineId);
            params.append('quantity', quantity);

            fetch('add-to-cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params.toString()
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Chuyển đến trang giỏ hàng
                    window.location.href = 'cart-view.jsp';
                } else {
                    alert(data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra, vui lòng thử lại');
            });
        }
    </script>

    <!-- AI Chatbot Widget -->
    <jsp:include page="chatbot-widget.jsp" />
</body>
</html>
