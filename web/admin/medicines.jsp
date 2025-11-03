<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Medicine" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    request.setAttribute("pageTitle", "Quản lý Thuốc");
    request.setAttribute("page", "medicines");
%>
<jsp:include page="../includes/admin-header.jsp" />

<div class="page-header">
    <h1 class="page-title">Quản lý Thuốc</h1>
    <p class="page-subtitle">Quản lý danh mục thuốc trong hệ thống</p>
</div>

<div class="content-card">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
        <div>
            <h3 style="font-size: 1.3rem; color: #333; margin-bottom: 5px;">Danh sách Thuốc</h3>
            <p style="color: #666; font-size: 0.9rem;">Tổng cộng: <c:out value="${listMedicine != null ? listMedicine.size() : 0}" default="0"/> thuốc</p>
        </div>
        <div style="display: flex; gap: 10px; align-items: center;">
            <form action="${pageContext.request.contextPath}/admin/medicines" method="get" style="display: flex; gap: 10px;">
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
            <a href="${pageContext.request.contextPath}/admin/medicines?action=new" style="padding: 10px 20px; background: linear-gradient(135deg, #0891b2, #0d9488); color: white; border-radius: 8px; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; font-weight: 600;">
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
                                        <%
                                            String imgPath = ((model.Medicine)pageContext.findAttribute("m")).getImagePath();
                                            if (imgPath != null && !imgPath.startsWith("image/")) {
                                                imgPath = "image/" + imgPath;
                                            }
                                            pageContext.setAttribute("displayPath", imgPath);
                                        %>
                                        <img src="${pageContext.request.contextPath}/${displayPath}" alt="${m.name}" 
                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';"
                                             style="width: 60px; height: 60px; object-fit: cover; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                                        <div style="width: 60px; height: 60px; background: #f0f0f0; border-radius: 8px; display: none; align-items: center; justify-content: center;">
                                            <i class="fas fa-pills" style="font-size: 1.5rem; color: #999;"></i>
                                        </div>
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
                                <c:choose>
                                    <c:when test="${not empty m.price}">
                                        ${m.price}₫
                                    </c:when>
                                    <c:otherwise>
                                        -
                                    </c:otherwise>
                                </c:choose>
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
                                <a href="${pageContext.request.contextPath}/admin/medicines?action=edit&id=${m.medicineId}" 
                                   style="padding: 6px 12px; background: #0891b2; color: white; border: none; border-radius: 6px; text-decoration: none; display: inline-flex; align-items: center; gap: 5px; margin-right: 5px; font-size: 0.9rem;">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/medicines?action=delete&id=${m.medicineId}" 
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
            window.location.href = '${pageContext.request.contextPath}/admin/medicines?action=filterByCategory&category=' + category;
        } else {
            window.location.href = '${pageContext.request.contextPath}/admin/medicines';
        }
    }
</script>

<jsp:include page="../includes/admin-footer.jsp" />
