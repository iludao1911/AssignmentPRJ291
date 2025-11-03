<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Medicine" %>
<%@ page import="model.User" %>
<%@ page import="dao.MedicineDAO" %>
<%@ page import="dao.ReviewDAO" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhà Thuốc MS - Trang Chủ</title>
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

        /* Search Dropdown */
        .search-dropdown {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
            margin-top: 8px;
            max-height: 400px;
            overflow-y: auto;
            display: none;
            z-index: 1000;
        }

        .search-dropdown.show {
            display: block;
        }

        .search-result-item {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            border-bottom: 1px solid #f0f0f0;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            color: #333;
        }

        .search-result-item:hover {
            background: #f8f9fa;
        }

        .search-result-item:last-child {
            border-bottom: none;
        }

        .search-result-img {
            width: 50px;
            height: 50px;
            border-radius: 8px;
            object-fit: cover;
            margin-right: 15px;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: #0891b2;
        }

        .search-result-info {
            flex: 1;
        }

        .search-result-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 4px;
        }

        .search-result-category {
            font-size: 0.85rem;
            color: #999;
        }

        .search-view-more {
            display: block;
            text-align: center;
            padding: 12px;
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
            color: white;
            font-weight: 600;
            border-radius: 0 0 12px 12px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
        }

        .search-view-more:hover {
            background: linear-gradient(135deg, #0d9488 0%, #0891b2 100%);
            color: white;
        }

        .search-no-results {
            padding: 20px;
            text-align: center;
            color: #999;
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

        .cart-link {
            position: relative;
        }

        .cart-count {
            position: absolute;
            top: 3px;
            right: 8px;
            background: #ff4757;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: bold;
        }

        /* User Avatar Dropdown */
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

        /* Carousel Section */
        .carousel-section {
            position: relative;
            max-width: 100%;
            margin: 0 auto 30px;
            overflow: hidden;
        }

        .carousel-container {
            position: relative;
            width: 100%;
            height: 460px;
            overflow: hidden;
        }

        .carousel-slide {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            transition: opacity 1s ease-in-out;
        }

        .carousel-slide.active {
            opacity: 1;
        }

        .carousel-slide img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .carousel-prev,
        .carousel-next {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(255, 255, 255, 0.8);
            border: none;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            cursor: pointer;
            font-size: 1.5rem;
            color: #0891b2;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10;
            transition: all 0.3s;
        }

        .carousel-prev:hover,
        .carousel-next:hover {
            background: white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .carousel-prev {
            left: 20px;
        }

        .carousel-next {
            right: 20px;
        }

        .carousel-indicators {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 10px;
            z-index: 10;
        }

        .carousel-indicator {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.5);
            border: none;
            cursor: pointer;
            transition: all 0.3s;
        }

        .carousel-indicator.active {
            background: white;
            width: 30px;
            border-radius: 6px;
        }

        /* Main Content */
        .main-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 20px 40px;
        }

        /* Category Tabs */
        .category-tabs {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            overflow-x: auto;
            overflow-y: hidden;
            padding-bottom: 10px;
            scroll-behavior: smooth;
            -webkit-overflow-scrolling: touch;
        }

        .category-tabs::-webkit-scrollbar {
            height: 6px;
        }

        .category-tabs::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }

        .category-tabs::-webkit-scrollbar-thumb {
            background: #0891b2;
            border-radius: 10px;
        }

        .category-tabs::-webkit-scrollbar-thumb:hover {
            background: #0d9488;
        }

        .category-tabs button {
            padding: 12px 30px;
            border: 2px solid #0891b2;
            background: white;
            color: #0891b2;
            border-radius: 25px;
            cursor: pointer;
            font-size: 0.95rem;
            font-weight: 600;
            transition: all 0.3s;
            white-space: nowrap;
            min-width: 140px;
            text-align: center;
            flex-shrink: 0;
        }

        .category-tabs button:hover,
        .category-tabs button.active {
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
            color: white;
            border-color: transparent;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(8, 145, 178, 0.3);
        }

        /* Section Header */
        .section-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .section-header h2 {
            font-size: 2rem;
            color: #333;
            margin-bottom: 10px;
        }

        .section-header p {
            color: #666;
            font-size: 1.05rem;
        }

        /* Products Grid */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .product-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            transition: all 0.3s;
            position: relative;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(8, 145, 178, 0.2);
        }

        .product-image {
            width: 100%;
            height: 220px;
            background: linear-gradient(135deg, rgba(8, 145, 178, 0.05) 0%, rgba(13, 148, 136, 0.05) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .product-image i {
            font-size: 4rem;
            color: #0891b2;
            opacity: 0.3;
        }

        .discount-badge {
            position: absolute;
            top: 10px;
            left: 10px;
            background: #e74c3c;
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }



        .product-info {
            padding: 20px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .product-category {
            color: #0891b2;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .product-name {
            font-size: 1.1rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            min-height: 50px;
        }

        .product-description {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 12px;
            min-height: 40px;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }

        .product-rating {
            display: flex;
            align-items: center;
            gap: 5px;
            margin-bottom: 15px;
        }

        .stars {
            color: #ffc107;
        }

        .rating-count {
            color: #999;
            font-size: 0.85rem;
        }

        .product-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 1px solid #f0f0f0;
            margin-top: auto;
        }

        .product-price {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }

        .current-price {
            font-size: 1.3rem;
            font-weight: 700;
            color: #0891b2;
            line-height: 1.2;
        }

        .original-price {
            font-size: 0.85rem;
            color: #999;
            text-decoration: line-through;
            line-height: 1.2;
        }

        .stock-badge {
            background: #27ae60;
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .add-to-cart-btn {
            width: 100%;
            margin-top: 15px;
            padding: 12px;
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 0.95rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.3s;
            box-shadow: 0 2px 8px rgba(8, 145, 178, 0.2);
        }

        .add-to-cart-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(8, 145, 178, 0.4);
        }

        .add-to-cart-btn:active {
            transform: translateY(-1px);
        }

        .product-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .product-actions .add-to-cart-btn,
        .product-actions .buy-now-btn {
            flex: 1;
            margin-top: 0;
            padding: 10px;
            font-size: 0.9rem;
        }

        .buy-now-btn {
            background: linear-gradient(135deg, #ff6b35 0%, #f7931e 100%);
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.3s;
            box-shadow: 0 2px 8px rgba(255, 107, 53, 0.3);
        }

        .buy-now-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 107, 53, 0.5);
        }

        .buy-now-btn:active {
            transform: translateY(-1px);
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin: 40px 0;
        }

        .pagination button {
            padding: 10px 16px;
            border: 1px solid #ddd;
            background: white;
            color: #333;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s;
        }

        .pagination button:hover:not(:disabled) {
            background: #0891b2;
            color: white;
            border-color: #0891b2;
        }

        .pagination button.active {
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
            color: white;
            border-color: transparent;
        }

        .pagination button:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .pagination-info {
            color: #666;
            font-size: 0.9rem;
        }

        /* No products message */
        .no-products {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .no-products i {
            font-size: 4rem;
            color: #ddd;
            margin-bottom: 20px;
        }

        /* Rating Badge */
        .rating-badge {
            position: absolute;
            bottom: 10px;
            right: 10px;
            background: #27ae60;
            color: white;
            padding: 8px 15px;
            border-radius: 10px;
            display: flex;
            flex-direction: column;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .rating-badge .rating {
            font-weight: 700;
            font-size: 1rem;
        }

        .rating-badge .count {
            font-size: 0.75rem;
            opacity: 0.9;
        }
    </style>
</head>
<body>
    <%
        // Lấy danh sách thuốc từ database
        MedicineDAO medicineDAO = new MedicineDAO();
        ReviewDAO reviewDAO = new ReviewDAO();
        List<Medicine> medicines = medicineDAO.getAllMedicines();
        
        // Format tiền tệ VNĐ
        NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
        
        // Lấy thông tin user từ session
        Object userObj = session.getAttribute("currentUser");
        model.User currentUser = null;
        if (userObj instanceof model.User) {
            currentUser = (model.User) userObj;
        }
        
        // Lấy số lượng giỏ hàng
        int cartCount = 0;
        if (currentUser != null) {
            try {
                dao.CartDAO cartDAO = new dao.CartDAO();
                cartCount = cartDAO.getCartCount(currentUser.getUserId());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    %>

    <!-- Header -->
    <header class="header">
        <div class="header-content">
            <div class="logo">
                <i class="fas fa-capsules"></i>
                <span>Nhà Thuốc MS</span>
            </div>
            
            <div class="search-bar">
                <input type="text" placeholder="Tìm kiếm thuốc, sản phẩm sức khỏe..." id="searchInput">
                <button><i class="fas fa-search"></i></button>
                <div class="search-dropdown" id="searchDropdown">
                    <!-- Search results will be inserted here -->
                </div>
            </div>
            
            <div class="header-actions">
                <% if (currentUser != null) { %>
                    <!-- Giỏ hàng -->
                    <a href="cart-view.jsp" class="cart-link">
                        <i class="fas fa-shopping-cart"></i>
                        <span class="cart-count"><%= cartCount %></span>
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

    <!-- Carousel Section -->
    <section class="carousel-section">
        <div class="carousel-container">
            <!-- Slide 1 -->
            <div class="carousel-slide active">
                <img src="https://cdn.nhathuoclongchau.com.vn/unsafe/2560x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/Top_Banner1440x414_f2b995ac75.jpg" alt="Banner 1">
            </div>
            
            <!-- Slide 2 -->
            <div class="carousel-slide">
                <img src="https://nhathuoclongchau.com.vn/estore-images/landing-bmi/bg-banner-desk-v2.png" alt="Banner 2">
            </div>
            
            <!-- Slide 3 -->
            <div class="carousel-slide">
                <img src="https://cdn.nhathuoclongchau.com.vn/unsafe/2560x0/filters:quality(90)/https://cms-prod.s3-sgn09.fptcloud.com/D_Desktop_Main_Banner_1600x460_2_fe24def85a.png" alt="Banner 3">
            </div>
            
            <!-- Navigation Buttons -->
            <button class="carousel-prev" onclick="changeSlide(-1)">
                <i class="fas fa-chevron-left"></i>
            </button>
            <button class="carousel-next" onclick="changeSlide(1)">
                <i class="fas fa-chevron-right"></i>
            </button>
            
            <!-- Indicators -->
            <div class="carousel-indicators">
                <button class="active" onclick="goToSlide(0)"></button>
                <button onclick="goToSlide(1)"></button>
                <button onclick="goToSlide(2)"></button>
            </div>
        </div>
    </section>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Section Header -->
        <div class="section-header">
            <h2>Sản Phẩm Nổi Bật</h2>
            <p>Khám phá những sản phẩm sức khỏe và y tế phổ biến nhất của chúng tôi</p>
        </div>

        <!-- Category Tabs -->
        <div class="category-tabs">
            <button class="active">Tất Cả</button>
            <button>Giảm Đau - Hạ Sốt</button>
            <button>Kháng Sinh</button>
            <button>Sinh Tố - Khoáng Chất</button>
            <button>Tiêu Hóa</button>
            <button>Dị Ứng</button>
            <button>Kháng Viêm</button>
            <button>Tiểu Đường</button>
        </div>

        <!-- Products Grid -->
        <div class="products-grid">
            <% 
            if (medicines != null && !medicines.isEmpty()) {
                for (Medicine medicine : medicines) {
                    // Lấy giá từ database
                    BigDecimal originalPriceBD = medicine.getPrice();
                    BigDecimal salePriceBD = medicine.getSalePrice();
                    
                    double originalPrice = originalPriceBD != null ? originalPriceBD.doubleValue() : 0.0;
                    double displayPrice = originalPrice;
                    int discount = 0;
                    
                    // Nếu có sale_price thì tính discount
                    if (salePriceBD != null && salePriceBD.doubleValue() > 0) {
                        displayPrice = salePriceBD.doubleValue();
                        discount = (int)((originalPrice - displayPrice) / originalPrice * 100);
                    }
                    
                    // Lấy rating và review count thật từ database
                    double rating = reviewDAO.getAverageRating(medicine.getMedicineId());
                    int reviewCount = reviewDAO.getReviewCount(medicine.getMedicineId());
            %>
            <div class="product-card" data-product-id="<%= medicine.getMedicineId() %>" onclick="window.location.href='medicine-detail?id=<%= medicine.getMedicineId() %>'" style="cursor: pointer;">
                <div class="product-image">
                    <% if (medicine.getImagePath() != null && !medicine.getImagePath().isEmpty()) { 
                        String imgPath = medicine.getImagePath();
                        if (!imgPath.startsWith("image/")) {
                            imgPath = "image/" + imgPath;
                        }
                    %>
                        <img src="<%= imgPath %>" alt="<%= medicine.getName() %>" onerror="this.parentElement.innerHTML='<i class=\'fas fa-pills\'></i>'">
                    <% } else { %>
                        <i class="fas fa-pills"></i>
                    <% } %>
                    
                    <% if (discount > 0) { %>
                        <div class="discount-badge">-<%= discount %>%</div>
                    <% } %>
                </div>
                
                <div class="product-info">
                    <div class="product-category"><%= medicine.getCategory() != null ? medicine.getCategory() : "Thuốc" %></div>
                    <div class="product-name"><%= medicine.getName() %></div>
                    <div class="product-description"><%= medicine.getDescription() != null ? medicine.getDescription() : "Sản phẩm chất lượng cao" %></div>
                    
                    <div class="product-rating">
                        <div class="stars">
                            <% 
                            if (reviewCount > 0) {
                                int fullStars = (int) rating;
                                for (int i = 0; i < fullStars; i++) { %>
                                    <i class="fas fa-star"></i>
                                <% } 
                                if (rating % 1 >= 0.5) { %>
                                    <i class="fas fa-star-half-alt"></i>
                                <% }
                                for (int i = (int)Math.ceil(rating); i < 5; i++) { %>
                                    <i class="far fa-star"></i>
                                <% }
                            } else {
                                // Hiển thị 5 sao rỗng nếu chưa có review
                                for (int i = 0; i < 5; i++) { %>
                                    <i class="far fa-star"></i>
                                <% }
                            } %>
                        </div>
                        <span class="rating-count">
                            <%= reviewCount > 0 ? String.format("%.1f", rating) + " (" + reviewCount + ")" : "Chưa có đánh giá" %>
                        </span>
                    </div>
                    
                    <div class="product-footer">
                        <div class="product-price">
                            <span class="current-price"><%= String.format("%,d", (long)displayPrice) %>đ</span>
                            <% if (discount > 0) { %>
                                <span class="original-price"><%= String.format("%,d", (long)originalPrice) %>đ</span>
                            <% } %>
                        </div>
                        <span class="stock-badge">Còn hàng</span>
                    </div>
                    
                    <div class="product-actions">
                        <button class="add-to-cart-btn" onclick="event.stopPropagation(); addToCartFromHome(<%= medicine.getMedicineId() %>)">
                            <i class="fas fa-shopping-cart"></i>
                            Thêm vào giỏ
                        </button>
                        <button class="buy-now-btn" onclick="event.stopPropagation(); buyNowFromHome(<%= medicine.getMedicineId() %>)">
                            <i class="fas fa-bolt"></i>
                            Mua ngay
                        </button>
                    </div>
                </div>
            </div>
            <% 
                }
            } else { 
            %>
            <div class="no-products">
                <i class="fas fa-box-open"></i>
                <h3>Không có sản phẩm nào</h3>
                <p>Vui lòng quay lại sau</p>
            </div>
            <% } %>
        </div>

        <!-- Pagination -->
        <div class="pagination" id="pagination">
            <button id="prevPage"><i class="fas fa-chevron-left"></i> Trước</button>
            <span class="pagination-info" id="pageInfo"></span>
            <button id="nextPage">Sau <i class="fas fa-chevron-right"></i></button>
        </div>
    </main>

    <script>
        // Global variables
        let allProducts = [];
        let filteredProducts = [];
        let currentPage = 1;
        const productsPerPage = 8;

        // Initialize everything when DOM is ready
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM loaded, initializing...');
            
            // Initialize products array
            const productCards = document.querySelectorAll('.product-card');
            console.log('Found products:', productCards.length);
            allProducts = Array.from(productCards);
            filteredProducts = [...allProducts];
            
            // Initialize pagination
            initPagination();
            
            // Initialize add to cart buttons
            initAddToCart();
            
            // Initialize category filter
            initCategoryFilter();
            
            // Initialize search
            initSearch();
        });

        // Pagination functions
        function initPagination() {
            const prevBtn = document.getElementById('prevPage');
            const nextBtn = document.getElementById('nextPage');
            
            if (!prevBtn || !nextBtn) {
                console.error('Pagination buttons not found');
                return;
            }
            
            updatePagination();
            
            prevBtn.addEventListener('click', () => {
                if (currentPage > 1) {
                    currentPage--;
                    updatePagination();
                }
            });
            
            nextBtn.addEventListener('click', () => {
                const totalPages = Math.ceil(filteredProducts.length / productsPerPage);
                if (currentPage < totalPages) {
                    currentPage++;
                    updatePagination();
                }
            });
        }

        function updatePagination() {
            const totalPages = Math.ceil(filteredProducts.length / productsPerPage);
            const start = (currentPage - 1) * productsPerPage;
            const end = start + productsPerPage;
            
            // Hide all products first
            allProducts.forEach(product => {
                product.style.display = 'none';
            });
            
            // Show current page products
            filteredProducts.slice(start, end).forEach(product => {
                product.style.display = 'flex';
            });
            
            // Update pagination controls
            const prevBtn = document.getElementById('prevPage');
            const nextBtn = document.getElementById('nextPage');
            const pageInfo = document.getElementById('pageInfo');
            
            if (prevBtn) prevBtn.disabled = currentPage === 1;
            if (nextBtn) nextBtn.disabled = currentPage === totalPages || totalPages === 0;
            if (pageInfo) {
                const displayPages = totalPages > 0 ? totalPages : 1;
                pageInfo.textContent = 'Trang ' + currentPage + ' / ' + displayPages;
            }
            
            // Scroll to top
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        // Add to cart functionality
        function initAddToCart() {
            document.querySelectorAll('.add-to-cart-btn').forEach(button => {
                button.addEventListener('click', function() {
                    const productName = this.closest('.product-card').querySelector('.product-name').textContent;
                    showToast('Thành công', 'Đã thêm "' + productName + '" vào giỏ hàng!', 'success');
                });
            });
        }

        // Category filter functionality
        function initCategoryFilter() {
            const categoryButtons = document.querySelectorAll('.category-tabs button');
            console.log('Found category buttons:', categoryButtons.length);
            
            categoryButtons.forEach(button => {
                button.addEventListener('click', function() {
                    console.log('Category clicked:', this.textContent.trim());
                    
                    // Update active button
                    categoryButtons.forEach(btn => {
                        btn.classList.remove('active');
                    });
                    this.classList.add('active');
                    
                    // Filter products
                    const category = this.textContent.trim();
                    
                    if (category === 'Tất Cả') {
                        filteredProducts = [...allProducts];
                    } else {
                        filteredProducts = allProducts.filter(card => {
                            const productCategory = card.querySelector('.product-category').textContent.trim();
                            return productCategory === category;
                        });
                    }
                    
                    console.log('Filtered products:', filteredProducts.length);
                    currentPage = 1;
                    updatePagination();
                });
            });
        }

        // Search functionality
        function initSearch() {
            const searchInput = document.getElementById('searchInput');
            const searchButton = document.querySelector('.search-bar button');
            const searchDropdown = document.getElementById('searchDropdown');
            
            if (!searchInput || !searchButton || !searchDropdown) {
                console.error('Search elements not found');
                return;
            }
            
            searchInput.addEventListener('input', function() {
                const searchValue = this.value.toLowerCase().trim();
                
                if (searchValue.length < 2) {
                    searchDropdown.classList.remove('show');
                    return;
                }
                
                // Filter products matching search
                const matchedProducts = allProducts.filter(card => {
                    const productName = card.querySelector('.product-name').textContent.toLowerCase();
                    const productDescription = card.querySelector('.product-description').textContent.toLowerCase();
                    const productCategory = card.querySelector('.product-category').textContent.toLowerCase();
                    
                    return productName.includes(searchValue) || 
                           productDescription.includes(searchValue) || 
                           productCategory.includes(searchValue);
                });
                
                if (matchedProducts.length === 0) {
                    searchDropdown.innerHTML = '<div class="search-no-results">Không tìm thấy sản phẩm nào</div>';
                    searchDropdown.classList.add('show');
                    return;
                }
                
                // Show top 3 results in dropdown
                const topResults = matchedProducts.slice(0, 3);
            let dropdownHTML = '';
            
            topResults.forEach(card => {
                const name = card.querySelector('.product-name').textContent;
                const category = card.querySelector('.product-category').textContent;
                const imgElement = card.querySelector('.product-image img');
                const imgSrc = imgElement ? imgElement.getAttribute('src') : '';
                const hasImg = imgSrc && imgSrc.trim() !== '' && !imgSrc.includes('undefined');
                const productId = card.dataset.productId ? card.dataset.productId : '';
                
                dropdownHTML += `
                    <a href="medicine-detail?id=` + productId + `" class="search-result-item">
                        <div class="search-result-img">
                            ` + (hasImg ? `<img src="` + imgSrc + `" alt="` + name + `" style="width:100%; height:100%; object-fit:cover; border-radius:8px;">` : '<i class="fas fa-pills"></i>') + `
                        </div>
                        <div class="search-result-info">
                            <div class="search-result-name">` + name + `</div>
                            <div class="search-result-category">` + category + `</div>
                        </div>
                    </a>
                `;
            });
            
            if (matchedProducts.length > 3) {
                dropdownHTML += '<a href="#" class="search-view-more" onclick="viewAllResults(event)">Xem thêm ' + (matchedProducts.length - 3) + ' sản phẩm</a>';
            }
            
            searchDropdown.innerHTML = dropdownHTML;
            searchDropdown.classList.add('show');
            });
            
            // Close dropdown when clicking outside
            document.addEventListener('click', function(e) {
                if (!e.target.closest('.search-bar')) {
                    searchDropdown.classList.remove('show');
                }
            });
            
            // Search button click
            searchButton.addEventListener('click', performSearch);
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    performSearch();
                }
            });
        }
        
        function performSearch() {
            const searchInput = document.getElementById('searchInput');
            const searchDropdown = document.getElementById('searchDropdown');
            const searchValue = searchInput.value.toLowerCase().trim();
            searchDropdown.classList.remove('show');
            
            if (!searchValue) {
                filteredProducts = [...allProducts];
            } else {
                filteredProducts = allProducts.filter(card => {
                    const productName = card.querySelector('.product-name').textContent.toLowerCase();
                    const productDescription = card.querySelector('.product-description').textContent.toLowerCase();
                    const productCategory = card.querySelector('.product-category').textContent.toLowerCase();
                    
                    return productName.includes(searchValue) || 
                           productDescription.includes(searchValue) || 
                           productCategory.includes(searchValue);
                });
            }
            
            // Reset category filter to "Tất Cả"
            document.querySelectorAll('.category-tabs button').forEach(btn => {
                btn.classList.remove('active');
            });
            document.querySelector('.category-tabs button:first-child').classList.add('active');
            
            currentPage = 1;
            updatePagination();
        }
        
        function scrollToProduct(element) {
            event.preventDefault();
            const searchDropdown = document.getElementById('searchDropdown');
            searchDropdown.classList.remove('show');
            const card = element.closest('.search-result-item');
            setTimeout(() => {
                const name = card.querySelector('.search-result-name').textContent;
                const targetCard = Array.from(allProducts).find(p => 
                    p.querySelector('.product-name').textContent === name
                );
                if (targetCard) {
                    targetCard.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    targetCard.style.outline = '3px solid #0891b2';
                    setTimeout(() => {
                        targetCard.style.outline = 'none';
                    }, 2000);
                }
            }, 100);
        }
        
        function viewAllResults(event) {
            event.preventDefault();
            performSearch();
        }
        
        // Carousel functionality
        let currentSlide = 0;
        const slides = document.querySelectorAll('.carousel-slide');
        const indicators = document.querySelectorAll('.carousel-indicators button');
        let autoSlideInterval;
        
        function showSlide(index) {
            // Wrap around
            if (index >= slides.length) {
                currentSlide = 0;
            } else if (index < 0) {
                currentSlide = slides.length - 1;
            } else {
                currentSlide = index;
            }
            
            // Update slides
            slides.forEach((slide, i) => {
                slide.classList.toggle('active', i === currentSlide);
            });
            
            // Update indicators
            indicators.forEach((indicator, i) => {
                indicator.classList.toggle('active', i === currentSlide);
            });
        }
        
        function changeSlide(direction) {
            showSlide(currentSlide + direction);
            resetAutoSlide();
        }
        
        function goToSlide(index) {
            showSlide(index);
            resetAutoSlide();
        }
        
        function autoSlide() {
            currentSlide++;
            showSlide(currentSlide);
        }
        
        function resetAutoSlide() {
            clearInterval(autoSlideInterval);
            autoSlideInterval = setInterval(autoSlide, 5000);
        }
        
        // Initialize carousel
        document.addEventListener('DOMContentLoaded', function() {
            showSlide(0);
            autoSlideInterval = setInterval(autoSlide, 5000);
        });

        // Add to cart from home page
        function addToCartFromHome(medicineId) {
            <% if (currentUser == null) { %>
                showToast('Vui lòng đăng nhập', 'Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng', 'warning');
                window.location.href = 'auth-login.jsp';
                return;
            <% } %>

            const params = new URLSearchParams();
            params.append('medicineId', medicineId);
            params.append('quantity', 1);

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
                    showToast('Thành công', 'Đã thêm vào giỏ hàng!', 'success');
                    // Update cart count
                    const cartCount = document.querySelector('.cart-count');
                    if (cartCount) {
                        cartCount.textContent = data.cartCount;
                    }
                } else {
                    showToast('Thông báo', data.message, 'info');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Lỗi', 'Có lỗi xảy ra khi thêm vào giỏ hàng', 'error');
            });
        }

        // Buy now from home page
        function buyNowFromHome(medicineId) {
            <% if (currentUser == null) { %>
                showToast('Vui lòng đăng nhập', 'Vui lòng đăng nhập để mua hàng', 'warning');
                window.location.href = 'auth-login.jsp';
                return;
            <% } %>

            const params = new URLSearchParams();
            params.append('medicineId', medicineId);
            params.append('quantity', 1);

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
                    window.location.href = 'cart-view.jsp';
                } else {
                    showToast('Thông báo', data.message, 'info');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Lỗi', 'Có lỗi xảy ra', 'error');
            });
        }
    </script>

    <!-- AI Chatbot Widget -->
    <jsp:include page="chatbot-widget.jsp" />
</body>
</html>
