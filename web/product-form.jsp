<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    request.setAttribute("pageTitle", request.getAttribute("action").equals("insert") ? "Thêm Thuốc Mới" : "Chỉnh Sửa Thuốc");
    request.setAttribute("page", "medicines");
%>
<jsp:include page="includes/admin-header.jsp" />

<div class="page-header">
    <h1 class="page-title">
        <c:if test="${action == 'insert'}">Thêm Thuốc Mới</c:if>
        <c:if test="${action == 'update'}">Chỉnh Sửa Thuốc</c:if>
    </h1>
    <a href="${pageContext.request.contextPath}/admin/medicines?action=list" style="padding: 10px 20px; background: #6c757d; color: white; border-radius: 8px; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; font-weight: 600;">
        <i class="fas fa-arrow-left"></i> Quay lại
    </a>
</div>

<div class="content-card" style="max-width: 800px; margin: 0 auto;">
    <c:if test="${not empty error}">
        <div style="padding: 15px; background: #f8d7da; color: #721c24; border-radius: 8px; margin-bottom: 20px; border-left: 4px solid #dc3545;">
            <i class="fas fa-exclamation-circle"></i> <strong>Lỗi:</strong> <c:out value="${error}" />
        </div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/admin/medicines" enctype="multipart/form-data" style="max-width: 600px;">
        <input type="hidden" name="action" value="<c:out value="${action}" />" />
        <c:if test="${action == 'update'}">
            <input type="hidden" name="id" value="<c:out value="${medicine.medicineId}" />" />
        </c:if>

        <div style="margin-bottom: 20px;">
            <label style="display: block; font-weight: 600; color: #333; margin-bottom: 8px;">
                <i class="fas fa-pills"></i> Tên Thuốc <span style="color: #dc3545;">*</span>
            </label>
            <input type="text" name="name" value="<c:out value="${medicine.name}" />" required 
                   style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem;"/>
        </div>

        <div style="margin-bottom: 20px;">
            <label style="display: block; font-weight: 600; color: #333; margin-bottom: 8px;">
                <i class="fas fa-truck"></i> Nhà Cung Cấp <span style="color: #dc3545;">*</span>
            </label>
            <select name="supplierId" required 
                    style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem; background: white; cursor: pointer;">
                <option value="">-- Chọn Nhà Cung Cấp --</option>
                <c:forEach var="supplier" items="${suppliers}">
                    <option value="${supplier.supplierId}" ${medicine.supplierId == supplier.supplierId ? 'selected' : ''}>
                        ${supplier.name}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 20px;">
            <div>
                <label style="display: block; font-weight: 600; color: #333; margin-bottom: 8px;">
                    <i class="fas fa-dollar-sign"></i> Giá <span style="color: #dc3545;">*</span>
                </label>
                <input type="number" step="100" name="price" value="<c:out value="${medicine.price}" />" required 
                       style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem;"/>
            </div>
            <div>
                <label style="display: block; font-weight: 600; color: #333; margin-bottom: 8px;">
                    <i class="fas fa-boxes"></i> Số Lượng <span style="color: #dc3545;">*</span>
                </label>
                <input type="number" name="quantity" value="<c:out value="${medicine.quantity}" />" required 
                       style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem;"/>
            </div>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 20px;">
            <div>
                <label style="display: block; font-weight: 600; color: #333; margin-bottom: 8px;">
                    <i class="fas fa-tags"></i> Loại Thuốc <span style="color: #dc3545;">*</span>
                </label>
                <select name="category" required 
                        style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem; background: white; cursor: pointer;">
                    <option value="">-- Chọn Loại Thuốc --</option>
                    <option value="Giảm Đau - Hạ Sốt" ${medicine.category == 'Giảm Đau - Hạ Sốt' ? 'selected' : ''}>Giảm Đau - Hạ Sốt</option>
                    <option value="Kháng Sinh" ${medicine.category == 'Kháng Sinh' ? 'selected' : ''}>Kháng Sinh</option>
                    <option value="Sinh Tố - Khoáng Chất" ${medicine.category == 'Sinh Tố - Khoáng Chất' ? 'selected' : ''}>Sinh Tố - Khoáng Chất</option>
                    <option value="Tiêu Hóa" ${medicine.category == 'Tiêu Hóa' ? 'selected' : ''}>Tiêu Hóa</option>
                    <option value="Dị Ứng" ${medicine.category == 'Dị Ứng' ? 'selected' : ''}>Dị Ứng</option>
                    <option value="Kháng Viêm" ${medicine.category == 'Kháng Viêm' ? 'selected' : ''}>Kháng Viêm</option>
                    <option value="Tiểu Đường" ${medicine.category == 'Tiểu Đường' ? 'selected' : ''}>Tiểu Đường</option>
                </select>
            </div>
            <div>
                <label style="display: block; font-weight: 600; color: #333; margin-bottom: 8px;">
                    <i class="fas fa-calendar-alt"></i> Ngày Hết Hạn <span style="color: #dc3545;">*</span>
                </label>
                <input type="date" name="expiryDate" value="<c:out value="${medicine.expiryDate}" />" required 
                       style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem;"/>
            </div>
        </div>

        <div style="margin-bottom: 20px;">
            <label style="display: block; font-weight: 600; color: #333; margin-bottom: 8px;">
                <i class="fas fa-align-left"></i> Mô Tả
            </label>
            <textarea name="description" rows="4" 
                      style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem; resize: vertical;"><c:out value="${medicine.description}" /></textarea>
        </div>

        <div style="margin-bottom: 25px;">
            <label style="display: block; font-weight: 600; color: #333; margin-bottom: 8px;">
                <i class="fas fa-image"></i> Ảnh Thuốc
            </label>
            <c:if test="${not empty medicine.imagePath}">
                <div style="margin-bottom: 10px;">
                    <%
                        String imagePath = ((model.Medicine)request.getAttribute("medicine")).getImagePath();
                        if (imagePath != null && !imagePath.startsWith("image/")) {
                            imagePath = "image/" + imagePath;
                        }
                        pageContext.setAttribute("displayImagePath", imagePath);
                    %>
                    <img src="${pageContext.request.contextPath}/${displayImagePath}" 
                         alt="Current image" 
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';"
                         style="max-width: 200px; max-height: 200px; border: 2px solid #ddd; border-radius: 8px; padding: 5px;">
                    <div style="width: 200px; height: 200px; background: #f0f0f0; border-radius: 8px; display: none; align-items: center; justify-content: center; border: 2px solid #ddd;">
                        <i class="fas fa-pills" style="font-size: 3rem; color: #999;"></i>
                    </div>
                    <p style="font-size: 0.9rem; color: #666; margin-top: 5px;">Ảnh hiện tại</p>
                </div>
            </c:if>
            <input type="file" name="imageFile" accept="image/*"
                   style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem; background: white;"/>
            <p style="font-size: 0.85rem; color: #666; margin-top: 5px;">
                <i class="fas fa-info-circle"></i> Chấp nhận: JPG, PNG, GIF (Tối đa 10MB)
            </p>
        </div>

        <div style="display: flex; gap: 10px; justify-content: flex-end;">
            <a href="${pageContext.request.contextPath}/admin/medicines?action=list" style="padding: 12px 24px; background: #6c757d; color: white; border-radius: 8px; text-decoration: none; font-weight: 600;">
                Hủy
            </a>
            <button type="submit" style="padding: 12px 24px; background: linear-gradient(135deg, #0891b2, #0d9488); color: white; border: none; border-radius: 8px; font-weight: 600; cursor: pointer;">
                <i class="fas fa-save"></i> Lưu Thuốc
            </button>
        </div>
    </form>
</div>

<jsp:include page="includes/admin-footer.jsp" />