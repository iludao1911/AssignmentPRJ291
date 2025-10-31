<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    request.setAttribute("pageTitle", request.getAttribute("action").equals("insert") ? "Thêm Nhà Cung Cấp" : "Chỉnh Sửa NCC");
    request.setAttribute("page", "suppliers");
%>
<jsp:include page="includes/admin-header.jsp" />

<div class="page-header">
    <h1 class="page-title">
        <c:if test="${action == 'insert'}">Thêm Nhà Cung Cấp Mới</c:if>
        <c:if test="${action == 'update'}">Chỉnh Sửa Nhà Cung Cấp</c:if>
    </h1>
    <a href="${pageContext.request.contextPath}/admin/suppliers" style="padding: 10px 20px; background: #6c757d; color: white; border-radius: 8px; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; font-weight: 600;">
        <i class="fas fa-arrow-left"></i> Quay lại
    </a>
</div>

<div class="content-card" style="max-width: 800px; margin: 0 auto;">
    <c:if test="${not empty error}">
        <div style="padding: 15px; background: #f8d7da; color: #721c24; border-radius: 8px; margin-bottom: 20px; border-left: 4px solid #dc3545;">
            <i class="fas fa-exclamation-circle"></i> <strong>Lỗi:</strong> <c:out value="${error}" />
        </div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/admin/suppliers" style="max-width: 600px;">
        <input type="hidden" name="action" value="<c:out value="${action}" />" />
        <c:if test="${action == 'update'}">
            <input type="hidden" name="id" value="<c:out value="${supplier.supplierId}" />" />
        </c:if>

        <div style="margin-bottom: 20px;">
            <label style="display: block; font-weight: 600; color: #333; margin-bottom: 8px;">
                <i class="fas fa-building"></i> Tên Nhà Cung Cấp <span style="color: #dc3545;">*</span>
            </label>
            <input type="text" name="name" value="<c:out value="${supplier.name}" />" required 
                   style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem;"/>
        </div>

        <div style="margin-bottom: 20px;">
            <label style="display: block; font-weight: 600; color: #333; margin-bottom: 8px;">
                <i class="fas fa-map-marker-alt"></i> Địa Chỉ <span style="color: #dc3545;">*</span>
            </label>
            <input type="text" name="address" value="<c:out value="${supplier.address}" />" required 
                   style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem;"/>
        </div>

        <div style="margin-bottom: 20px;">
            <label style="display: block; font-weight: 600; color: #333; margin-bottom: 8px;">
                <i class="fas fa-phone"></i> Số Điện Thoại <span style="color: #dc3545;">*</span>
            </label>
            <input type="text" name="phone" value="<c:out value="${supplier.phone}" />" required 
                   pattern="[0-9]{10,11}" placeholder="Nhập 10-11 số"
                   style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem;"/>
        </div>

        <div style="margin-bottom: 25px;">
            <label style="display: block; font-weight: 600; color: #333; margin-bottom: 8px;">
                <i class="fas fa-envelope"></i> Email
            </label>
            <input type="email" name="email" value="<c:out value="${supplier.email}" />" 
                   placeholder="example@company.com"
                   style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem;"/>
        </div>

        <div style="display: flex; gap: 10px; justify-content: flex-end;">
            <a href="${pageContext.request.contextPath}/admin/suppliers" style="padding: 12px 24px; background: #6c757d; color: white; border-radius: 8px; text-decoration: none; font-weight: 600;">
                Hủy
            </a>
            <button type="submit" style="padding: 12px 24px; background: linear-gradient(135deg, #0891b2, #0d9488); color: white; border: none; border-radius: 8px; font-weight: 600; cursor: pointer;">
                <i class="fas fa-save"></i> Lưu NCC
            </button>
        </div>
    </form>
</div>

<jsp:include page="includes/admin-footer.jsp" />