<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="model.Medicine" %><%@ page import="model.Medicine" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%<%

    request.setAttribute("pageTitle", "Quản lý Thuốc");    request.setAttribute("pageTitle", "Quản lý Thuốc");

    request.setAttribute("page", "medicines");    request.setAttribute("page", "medicines");

%>%>

<jsp:include page="../includes/admin-header.jsp" /><jsp:include page="../includes/admin-header.jsp" />



<div class="page-header"><style>

    <h1 class="page-title">Quản lý Thuốc</h1>        body {

    <p class="page-subtitle">Quản lý danh mục thuốc trong hệ thống</p>            background-color: #f0f8ff;

</div>            font-family: Arial, sans-serif;

            margin: 0;

<div class="content-card">            padding: 0;

    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">        }

        <div>

            <h3 style="font-size: 1.3rem; color: #333; margin-bottom: 5px;">Danh sách Thuốc</h3>        h2 {

            <p style="color: #666; font-size: 0.9rem;">Quản lý kho thuốc và giá cả</p>            text-align: center;

        </div>            color: #1b5e20;

        <div style="display: flex; gap: 10px; align-items: center;">            margin: 25px 0 15px 0;

            <form action="${pageContext.request.contextPath}/medicines" method="get" style="display: flex; gap: 10px;">        }

                <input type="hidden" name="action" value="searchName">

                <input type="text" name="name" placeholder="Tìm kiếm thuốc..." value="${searchName}"         /* --- Bố cục chính gồm sidebar + nội dung chính --- */

                       style="padding: 10px 15px; border: 1px solid #ddd; border-radius: 8px; width: 250px;">        .main-layout {

                <button type="submit" style="padding: 10px 20px; background: #0891b2; color: white; border: none; border-radius: 8px; cursor: pointer; font-weight: 600;">            display: flex;

                    <i class="fas fa-search"></i> Tìm            align-items: flex-start;

                </button>            gap: 20px;

            </form>            padding: 20px 40px;

            <select id="categoryFilter" onchange="filterByCategory(this.value)" style="padding: 10px 15px; border: 1px solid #ddd; border-radius: 8px;">        }

                <option value="">Tất cả loại</option>

                <c:forEach var="c" items="${categories}">        /* --- Sidebar thể loại --- */

                    <option value="${c}" ${selectedCategory == c ? 'selected' : ''}>${c}</option>        .sidebar {

                </c:forEach>            width: 220px;

            </select>            background-color: #e8f5e9;

            <a href="${pageContext.request.contextPath}/medicines?action=new" style="padding: 10px 20px; background: linear-gradient(135deg, #0891b2, #0d9488); color: white; border-radius: 8px; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; font-weight: 600;">            padding: 20px;

                <i class="fas fa-plus"></i> Thêm Thuốc            border-radius: 10px;

            </a>            box-shadow: 0 4px 8px rgba(0,0,0,0.1);

        </div>            height: fit-content;

    </div>        }



    <c:choose>        .sidebar h3 {

        <c:when test="${empty listMedicine}">            margin-top: 0;

            <div style="text-align: center; padding: 60px 20px; color: #999;">            color: #1b5e20;

                <i class="fas fa-pills" style="font-size: 4rem; margin-bottom: 20px; color: #ddd;"></i>            border-bottom: 2px solid #1b5e20;

                <h3 style="font-size: 1.3rem; margin-bottom: 10px;">Chưa có thuốc</h3>            padding-bottom: 8px;

                <p>Thêm thuốc đầu tiên để bắt đầu</p>            margin-bottom: 12px;

            </div>        }

        </c:when>

        <c:otherwise>        .sidebar a {

            <table style="width: 100%; border-collapse: collapse;">            display: block;

                <thead>            color: #2e7d32;

                    <tr style="background: #f8f9fa; border-bottom: 2px solid #dee2e6;">            padding: 8px 10px;

                        <th style="padding: 15px; text-align: left; font-weight: 600; color: #333; width: 80px;">Ảnh</th>            text-decoration: none;

                        <th style="padding: 15px; text-align: left; font-weight: 600; color: #333;">Tên Thuốc</th>            border-radius: 6px;

                        <th style="padding: 15px; text-align: left; font-weight: 600; color: #333;">Loại</th>            margin-bottom: 5px;

                        <th style="padding: 15px; text-align: right; font-weight: 600; color: #333;">Giá</th>            font-weight: 500;

                        <th style="padding: 15px; text-align: center; font-weight: 600; color: #333;">Số lượng</th>            transition: 0.2s;

                        <th style="padding: 15px; text-align: center; font-weight: 600; color: #333;">Hạn dùng</th>        }

                        <th style="padding: 15px; text-align: center; font-weight: 600; color: #333;">Thao tác</th>

                    </tr>        .sidebar a:hover {

                </thead>            background-color: #2e7d32;

                <tbody>            color: white;

                    <c:forEach var="m" items="${listMedicine}">        }

                        <tr style="border-bottom: 1px solid #dee2e6;" class="medicine-row">

                            <td style="padding: 15px;">        .sidebar a.active {

                                <c:choose>            background-color: #1b5e20;

                                    <c:when test="${not empty m.imagePath}">            color: white;

                                        <img src="${pageContext.request.contextPath}/image/${m.imagePath}" alt="${m.name}"         }

                                             style="width: 60px; height: 60px; object-fit: cover; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">

                                    </c:when>        /* --- Nội dung chính bên phải --- */

                                    <c:otherwise>        .main-content {

                                        <div style="width: 60px; height: 60px; background: #f0f0f0; border-radius: 8px; display: flex; align-items: center; justify-content: center;">            flex-grow: 1;

                                            <i class="fas fa-pills" style="font-size: 1.5rem; color: #999;"></i>        }

                                        </div>

                                    </c:otherwise>        /* Thanh tìm kiếm */

                                </c:choose>        .search-box {

                            </td>            display: flex;

                            <td style="padding: 15px;">            justify-content: center;

                                <div style="font-weight: 600; color: #333; margin-bottom: 3px;">${m.name}</div>            align-items: center;

                                <div style="font-size: 0.85rem; color: #666; max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">            gap: 10px;

                                    ${m.description}            background-color: #fff;

                                </div>            padding: 12px 18px;

                            </td>            border-radius: 15px;

                            <td style="padding: 15px;">            box-shadow: 0 3px 8px rgba(0,0,0,0.1);

                                <span style="background: #e0f2fe; color: #0891b2; padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; display: inline-block;">            width: fit-content;

                                    ${m.category}            margin: 0 auto 25px;

                                </span>        }

                            </td>

                            <td style="padding: 15px; text-align: right; font-weight: 600; color: #0891b2; font-size: 1.05rem;">        .search-box input[type="text"] {

                                ${m.price}₫            padding: 10px 14px;

                            </td>            border: 1px solid #2e7d32;

                            <td style="padding: 15px; text-align: center;">            border-radius: 10px;

                                <c:choose>            font-size: 14px;

                                    <c:when test="${m.quantity <= 10}">            width: 260px;

                                        <span style="background: #fee2e2; color: #dc2626; padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">            outline: none;

                                            ${m.quantity}            transition: all 0.2s ease;

                                        </span>        }

                                    </c:when>

                                    <c:when test="${m.quantity <= 50}">        .search-box input[type="text"]:focus {

                                        <span style="background: #fef3c7; color: #f59e0b; padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">            border-color: #1b5e20;

                                            ${m.quantity}            box-shadow: 0 0 6px rgba(27, 94, 32, 0.4);

                                        </span>        }

                                    </c:when>

                                    <c:otherwise>        .search-btn {

                                        <span style="background: #d1fae5; color: #059669; padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">            background-color: #2e7d32;

                                            ${m.quantity}            color: white;

                                        </span>            border: none;

                                    </c:otherwise>            padding: 10px 16px;

                                </c:choose>            border-radius: 10px;

                            </td>            font-weight: bold;

                            <td style="padding: 15px; text-align: center; color: #666; font-size: 0.9rem;">            cursor: pointer;

                                <i class="fas fa-calendar-alt" style="color: #0891b2; margin-right: 5px;"></i>            font-size: 14px;

                                ${m.expiryDate}            transition: all 0.2s ease;

                            </td>        }

                            <td style="padding: 15px; text-align: center;">

                                <a href="${pageContext.request.contextPath}/medicines?action=edit&id=${m.medicineId}"         .search-btn:hover {

                                   style="padding: 6px 12px; background: #0891b2; color: white; border: none; border-radius: 6px; text-decoration: none; display: inline-flex; align-items: center; gap: 5px; margin-right: 5px; font-size: 0.9rem;">            background-color: #1b5e20;

                                    <i class="fas fa-edit"></i>            transform: scale(1.05);

                                </a>        }

                                <a href="${pageContext.request.contextPath}/medicines?action=delete&id=${m.medicineId}" 

                                   onclick="return confirm('Xóa thuốc ${m.name}?');"        .reset-btn {

                                   style="padding: 6px 12px; background: #dc3545; color: white; border: none; border-radius: 6px; text-decoration: none; display: inline-flex; align-items: center; gap: 5px; font-size: 0.9rem;">            background-color: #9e9e9e;

                                    <i class="fas fa-trash"></i>            color: white;

                                </a>            text-decoration: none;

                            </td>            padding: 10px 16px;

                        </tr>            border-radius: 10px;

                    </c:forEach>            font-weight: bold;

                </tbody>            font-size: 14px;

            </table>            transition: all 0.2s ease;

        }

            <!-- Pagination -->

            <c:if test="${totalPages > 1}">        .reset-btn:hover {

                <div style="display: flex; justify-content: center; align-items: center; gap: 10px; margin-top: 30px; padding-top: 20px; border-top: 1px solid #dee2e6;">            background-color: #757575;

                    <c:if test="${currentPage > 1}">            transform: scale(1.05);

                        <a href="medicines?page=${currentPage - 1}${paginationQuery}"         }

                           style="padding: 8px 16px; background: #f8f9fa; color: #333; border-radius: 6px; text-decoration: none; font-weight: 600;">

                            <i class="fas fa-chevron-left"></i> Trước        /* Nút thêm thuốc */

                        </a>        .add-button {

                    </c:if>            display: block;

                                width: 200px;

                    <span style="color: #666; font-weight: 600;">            margin: 0 auto 20px;

                        Trang ${currentPage} / ${totalPages}            text-align: center;

                    </span>            background-color: #2e7d32;

                                color: white;

                    <c:if test="${currentPage < totalPages}">            padding: 10px;

                        <a href="medicines?page=${currentPage + 1}${paginationQuery}"             border-radius: 10px;

                           style="padding: 8px 16px; background: #0891b2; color: white; border-radius: 6px; text-decoration: none; font-weight: 600;">            text-decoration: none;

                            Sau <i class="fas fa-chevron-right"></i>            font-weight: bold;

                        </a>            transition: all 0.2s ease;

                    </c:if>        }

                </div>

            </c:if>        .add-button:hover {

        </c:otherwise>            background-color: #1b5e20;

    </c:choose>            transform: scale(1.05);

</div>        }



<script>        /* Danh sách thuốc */

    function filterByCategory(category) {        .container {

        if (category) {            display: flex;

            window.location.href = '${pageContext.request.contextPath}/medicines?action=filterByCategory&category=' + category;            flex-wrap: wrap;

        } else {            justify-content: center;

            window.location.href = '${pageContext.request.contextPath}/medicines';            gap: 20px;

        }        }

    }

</script>        .card {

            background-color: #fff;

<jsp:include page="../includes/admin-footer.jsp" />            border-radius: 15px;

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

<div class="page-header">
    <h1 class="page-title">Quản lý Thuốc</h1>
    <p class="page-subtitle">Quản lý danh mục thuốc trong hệ thống</p>
</div>

<div class="content-card">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
        <div>
            <h3 style="font-size: 1.3rem; color: #333; margin-bottom: 5px;">Danh sách Thuốc</h3>
            <p style="color: #666; font-size: 0.9rem;">Quản lý kho thuốc và giá cả</p>
        </div>
        <div style="display: flex; gap: 10px; align-items: center;">
            <form action="${pageContext.request.contextPath}/medicines" method="get" style="display: flex; gap: 10px;">
                <input type="hidden" name="action" value="searchName">
                <input type="text" name="name" placeholder="Tìm kiếm thuốc..." value="${searchName}" 
                       style="padding: 10px 15px; border: 1px solid #ddd; border-radius: 8px; width: 250px;">
                <button type="submit" style="padding: 10px 20px; background: #0891b2; color: white; border: none; border-radius: 8px; cursor: pointer; font-weight: 600;">
                    <i class="fas fa-search"></i> Tìm
                </button>
            </form>
            <select id="categoryFilter" onchange="filterByCategory(this.value)" style="padding: 10px 15px; border: 1px solid #ddd; border-radius: 8px;">
                <option value="">Tất cả loại</option>
                <c:forEach var="c" items="${categories}">
                    <option value="${c}" ${selectedCategory == c ? 'selected' : ''}>${c}</option>
                </c:forEach>
            </select>
            <a href="${pageContext.request.contextPath}/medicines?action=new" style="padding: 10px 20px; background: linear-gradient(135deg, #0891b2, #0d9488); color: white; border-radius: 8px; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; font-weight: 600;">
                <i class="fas fa-plus"></i> Thêm Thuốc
            </a>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty listMedicine}">
            <div style="text-align: center; padding: 60px 20px; color: #999;">
                <i class="fas fa-pills" style="font-size: 4rem; margin-bottom: 20px; color: #ddd;"></i>
                <h3 style="font-size: 1.3rem; margin-bottom: 10px;">Chưa có thuốc</h3>
                <p>Thêm thuốc đầu tiên để bắt đầu</p>
            </div>
        </c:when>
        <c:otherwise>
            <table style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr style="background: #f8f9fa; border-bottom: 2px solid #dee2e6;">
                        <th style="padding: 15px; text-align: left; font-weight: 600; color: #333; width: 80px;">Ảnh</th>
                        <th style="padding: 15px; text-align: left; font-weight: 600; color: #333;">Tên Thuốc</th>
                        <th style="padding: 15px; text-align: left; font-weight: 600; color: #333;">Loại</th>
                        <th style="padding: 15px; text-align: right; font-weight: 600; color: #333;">Giá</th>
                        <th style="padding: 15px; text-align: center; font-weight: 600; color: #333;">Số lượng</th>
                        <th style="padding: 15px; text-align: center; font-weight: 600; color: #333;">Hạn dùng</th>
                        <th style="padding: 15px; text-align: center; font-weight: 600; color: #333;">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="m" items="${listMedicine}">
                        <tr style="border-bottom: 1px solid #dee2e6;" class="medicine-row">
                            <td style="padding: 15px;">
                                <c:choose>
                                    <c:when test="${not empty m.imagePath}">
                                        <img src="${pageContext.request.contextPath}/image/${m.imagePath}" alt="${m.name}" 
                                             style="width: 60px; height: 60px; object-fit: cover; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                                    </c:when>
                                    <c:otherwise>
                                        <div style="width: 60px; height: 60px; background: #f0f0f0; border-radius: 8px; display: flex; align-items: center; justify-content: center;">
                                            <i class="fas fa-pills" style="font-size: 1.5rem; color: #999;"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="padding: 15px;">
                                <div style="font-weight: 600; color: #333; margin-bottom: 3px;">${m.name}</div>
                                <div style="font-size: 0.85rem; color: #666; max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                    ${m.description}
                                </div>
                            </td>
                            <td style="padding: 15px;">
                                <span style="background: #e0f2fe; color: #0891b2; padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; display: inline-block;">
                                    ${m.category}
                                </span>
                            </td>
                            <td style="padding: 15px; text-align: right; font-weight: 600; color: #0891b2; font-size: 1.05rem;">
                                ${m.price}₫
                            </td>
                            <td style="padding: 15px; text-align: center;">
                                <c:choose>
                                    <c:when test="${m.quantity <= 10}">
                                        <span style="background: #fee2e2; color: #dc2626; padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">
                                            ${m.quantity}
                                        </span>
                                    </c:when>
                                    <c:when test="${m.quantity <= 50}">
                                        <span style="background: #fef3c7; color: #f59e0b; padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">
                                            ${m.quantity}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="background: #d1fae5; color: #059669; padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">
                                            ${m.quantity}
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="padding: 15px; text-align: center; color: #666; font-size: 0.9rem;">
                                <i class="fas fa-calendar-alt" style="color: #0891b2; margin-right: 5px;"></i>
                                ${m.expiryDate}
                            </td>
                            <td style="padding: 15px; text-align: center;">
                                <a href="${pageContext.request.contextPath}/medicines?action=edit&id=${m.medicineId}" 
                                   style="padding: 6px 12px; background: #0891b2; color: white; border: none; border-radius: 6px; text-decoration: none; display: inline-flex; align-items: center; gap: 5px; margin-right: 5px; font-size: 0.9rem;">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/medicines?action=delete&id=${m.medicineId}" 
                                   onclick="return confirm('Xóa thuốc ${m.name}?');"
                                   style="padding: 6px 12px; background: #dc3545; color: white; border: none; border-radius: 6px; text-decoration: none; display: inline-flex; align-items: center; gap: 5px; font-size: 0.9rem;">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div style="display: flex; justify-content: center; align-items: center; gap: 10px; margin-top: 30px; padding-top: 20px; border-top: 1px solid #dee2e6;">
                    <c:if test="${currentPage > 1}">
                        <a href="medicines?page=${currentPage - 1}${paginationQuery}" 
                           style="padding: 8px 16px; background: #f8f9fa; color: #333; border-radius: 6px; text-decoration: none; font-weight: 600;">
                            <i class="fas fa-chevron-left"></i> Trước
                        </a>
                    </c:if>
                    
                    <span style="color: #666; font-weight: 600;">
                        Trang ${currentPage} / ${totalPages}
                    </span>
                    
                    <c:if test="${currentPage < totalPages}">
                        <a href="medicines?page=${currentPage + 1}${paginationQuery}" 
                           style="padding: 8px 16px; background: #0891b2; color: white; border-radius: 6px; text-decoration: none; font-weight: 600;">
                            Sau <i class="fas fa-chevron-right"></i>
                        </a>
                    </c:if>
                </div>
            </c:if>
        </c:otherwise>
    </c:choose>
</div>

<script>
    function filterByCategory(category) {
        if (category) {
            window.location.href = '${pageContext.request.contextPath}/medicines?action=filterByCategory&category=' + category;
        } else {
            window.location.href = '${pageContext.request.contextPath}/medicines';
        }
    }
</script>
