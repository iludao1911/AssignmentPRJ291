<%@page import="model.Medicine"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh Sách Thuốc</title>
    <style>
        body {
            background-color: #f0f8ff;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        h2 {
            text-align: center;
            color: #1b5e20;
            margin: 25px 0 15px 0;
        }

        /* --- Bố cục chính gồm sidebar + nội dung chính --- */
        .main-layout {
            display: flex;
            align-items: flex-start;
            gap: 20px;
            padding: 20px 40px;
        }

        /* --- Sidebar thể loại --- */
        .sidebar {
            width: 220px;
            background-color: #e8f5e9;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            height: fit-content;
        }

        .sidebar h3 {
            margin-top: 0;
            color: #1b5e20;
            border-bottom: 2px solid #1b5e20;
            padding-bottom: 8px;
            margin-bottom: 12px;
        }

        .sidebar a {
            display: block;
            color: #2e7d32;
            padding: 8px 10px;
            text-decoration: none;
            border-radius: 6px;
            margin-bottom: 5px;
            font-weight: 500;
            transition: 0.2s;
        }

        .sidebar a:hover {
            background-color: #2e7d32;
            color: white;
        }

        .sidebar a.active {
            background-color: #1b5e20;
            color: white;
        }

        /* --- Nội dung chính bên phải --- */
        .main-content {
            flex-grow: 1;
        }

        /* Thanh tìm kiếm */
        .search-box {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            background-color: #fff;
            padding: 12px 18px;
            border-radius: 15px;
            box-shadow: 0 3px 8px rgba(0,0,0,0.1);
            width: fit-content;
            margin: 0 auto 25px;
        }

        .search-box input[type="text"] {
            padding: 10px 14px;
            border: 1px solid #2e7d32;
            border-radius: 10px;
            font-size: 14px;
            width: 260px;
            outline: none;
            transition: all 0.2s ease;
        }

        .search-box input[type="text"]:focus {
            border-color: #1b5e20;
            box-shadow: 0 0 6px rgba(27, 94, 32, 0.4);
        }

        .search-btn {
            background-color: #2e7d32;
            color: white;
            border: none;
            padding: 10px 16px;
            border-radius: 10px;
            font-weight: bold;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.2s ease;
        }

        .search-btn:hover {
            background-color: #1b5e20;
            transform: scale(1.05);
        }

        .reset-btn {
            background-color: #9e9e9e;
            color: white;
            text-decoration: none;
            padding: 10px 16px;
            border-radius: 10px;
            font-weight: bold;
            font-size: 14px;
            transition: all 0.2s ease;
        }

        .reset-btn:hover {
            background-color: #757575;
            transform: scale(1.05);
        }

        /* Nút thêm thuốc */
        .add-button {
            display: block;
            width: 200px;
            margin: 0 auto 20px;
            text-align: center;
            background-color: #2e7d32;
            color: white;
            padding: 10px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.2s ease;
        }

        .add-button:hover {
            background-color: #1b5e20;
            transform: scale(1.05);
        }

        /* Danh sách thuốc */
        .container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
        }

        .card {
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            width: 220px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            transition: transform 0.2s;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }

        .card-body {
            padding: 10px 12px;
            display: flex;
            flex-direction: column;
            gap: 3px;
            line-height: 1.2;
        }

        .card-body h3 {
            font-size: 16px;
            margin: 2px 0;
            color: #1b5e20;
        }

        .card-body p {
            margin: 0;
            font-size: 13px;
            color: #333;
        }

        .price {
            font-weight: bold;
            color: #1b5e20;
        }

        .action-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 8px;
        }

        .action-buttons a {
            flex: 1;
            text-align: center;
            padding: 6px;
            margin: 0 4px;
            border-radius: 6px;
            color: white;
            text-decoration: none;
            font-size: 13px;
            font-weight: bold;
            transition: all 0.2s ease;
        }

        .edit-btn {
            background-color: #43a047;
        }

        .edit-btn:hover {
            background-color: #2e7d32;
            transform: scale(1.05);
        }

        .delete-btn {
            background-color: #e53935;
        }

        .delete-btn:hover {
            background-color: #c62828;
            transform: scale(1.05);
        }

        /* Phân trang */
        .pagination {
            text-align: center;
            margin: 25px 0;
        }

        .pagination a, .pagination span {
            display: inline-block;
            padding: 6px 10px;
            margin: 0 3px;
            border-radius: 5px;
            text-decoration: none;
            border: 1px solid #2e7d32;
            color: #2e7d32;
            font-size: 13px;
        }

        .pagination span {
            background-color: #2e7d32;
            color: white;
        }

        .pagination a:hover {
            background-color: #1b5e20;
            color: white;
        }
    </style>
</head>

<body>
    <h2>Danh Sách Thuốc</h2>

    <div class="main-layout">
        <!-- Sidebar Thể loại -->
        <div class="sidebar">
            <h3>Thể loại</h3>
            <a href="${pageContext.request.contextPath}/medicines" 
               class="${empty selectedCategory ? 'active' : ''}">Tất cả</a>
            <c:forEach var="c" items="${categories}">
                <a href="${pageContext.request.contextPath}/medicines?action=filterByCategory&category=${c}"
                   class="${selectedCategory == c ? 'active' : ''}">
                   ${c}
                </a>
            </c:forEach>
        </div>

        <!-- Nội dung chính -->
        <div class="main-content">
            <div class="controls-container">
                <!-- Thanh tìm kiếm -->
                <form action="${pageContext.request.contextPath}/medicines" method="get" class="search-box">
                    <input type="hidden" name="action" value="searchName">
                    <input type="text" name="name" placeholder="Nhập tên thuốc cần tìm..." value="${searchName}">
                    <button type="submit" class="search-btn">🔍 Tìm kiếm</button>
                    <a href="${pageContext.request.contextPath}/medicines" class="reset-btn">🔄 Làm mới</a>
                </form>

                <!-- Thanh sắp xếp -->
                <div class="sort-box">
                    <span>Sắp xếp theo giá:</span>
                    <c:url var="urlPriceAsc" value="/medicines">
                        <c:param name="action" value="${not empty selectedCategory ? 'filterByCategory' : (not empty searchName ? 'searchName' : 'list')}" />
                        <c:if test="${not empty selectedCategory}"><c:param name="category" value="${selectedCategory}"/></c:if>
                        <c:if test="${not empty searchName}"><c:param name="name" value="${searchName}"/></c:if>
                        <c:param name="sort" value="price_asc"/>
                    </c:url>
                    <c:url var="urlPriceDesc" value="/medicines">
                        <c:param name="action" value="${not empty selectedCategory ? 'filterByCategory' : (not empty searchName ? 'searchName' : 'list')}" />
                        <c:if test="${not empty selectedCategory}"><c:param name="category" value="${selectedCategory}"/></c:if>
                        <c:if test="${not empty searchName}"><c:param name="name" value="${searchName}"/></c:if>
                        <c:param name="sort" value="price_desc"/>
                    </c:url>
                    <a href="${urlPriceAsc}" class="${sortOrder == 'price_asc' ? 'active' : ''}">Thấp → Cao</a>
                    <a href="${urlPriceDesc}" class="${sortOrder == 'price_desc' ? 'active' : ''}">Cao → Thấp</a>
                </div>
            </div>

            <a class="add-button" href="${pageContext.request.contextPath}/medicines?action=new">
                + Thêm Thuốc Mới
            </a>

            <!-- Danh sách thuốc -->
            <div class="container">
                <c:forEach var="m" items="${listMedicine}">
                    <div class="card">
                        <c:choose>
                            <c:when test="${not empty m.imagePath}">
                                <img src="${pageContext.request.contextPath}/image/${m.imagePath}" alt="${m.name}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/image/no-image.png" alt="Không có ảnh">
                            </c:otherwise>
                        </c:choose>

                        <div class="card-body">
                            <h3>${m.name}</h3>
                            <p>${m.description}</p>
                            <p>Loại: ${m.category}</p>

                            <c:choose>
                                <c:when test="${m.salePrice != null && m.salePrice > 0}">
                                    <p class="price">
                                        Giá gốc: <span style="text-decoration: line-through; color:red;">${m.price} VND</span><br/>
                                        Giá sale: <span style="color:green; font-weight:bold;">${m.salePrice} VND</span>
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <p class="price">Giá: ${m.price} VND</p>
                                </c:otherwise>
                            </c:choose>

                            <p>Số lượng: ${m.quantity}</p>
                            <p>Hạn sử dụng: ${m.expiryDate}</p>

                            <div class="action-buttons">
                                <a class="edit-btn" href="${pageContext.request.contextPath}/medicines?action=edit&id=${m.medicineId}">Edit</a>
                                <a class="delete-btn" href="${pageContext.request.contextPath}/medicines?action=delete&id=${m.medicineId}"
                                   onclick="return confirm('Bạn có chắc muốn xóa thuốc này không?');">Delete</a>
                                <a class="edit-btn" href="${pageContext.request.contextPath}/medicines?action=sale&id=${m.medicineId}">Sale</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Pagination -->
            <div class="pagination">
                <c:set var="paginationQuery">
                    <c:choose>
                        <c:when test="${not empty searchName}">
                            <c:out value="&action=searchName&name=${searchName}"/>
                        </c:when>
                        <c:when test="${not empty selectedCategory}">
                            <c:out value="&action=filterByCategory&category=${selectedCategory}"/>
                        </c:when>
                    </c:choose>
                    <c:if test="${not empty sortOrder}">
                        <c:out value="&sort=${sortOrder}"/>
                    </c:if>
                </c:set>

                <c:if test="${currentPage > 1}">
                    <a href="medicines?page=${currentPage - 1}${paginationQuery}">Previous</a>
                </c:if>

                <c:forEach begin="1" end="${totalPages}" var="i">
                    <c:choose>
                        <c:when test="${currentPage eq i}">
                            <span>${i}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="medicines?page=${i}${paginationQuery}">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <a href="medicines?page=${currentPage + 1}${paginationQuery}">Next</a>
                </c:if>
            </div>         
        </div>
    </div>
</body>
</html>
