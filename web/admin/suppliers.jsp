<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    request.setAttribute("pageTitle", "Quản lý Nhà cung cấp");
    request.setAttribute("page", "suppliers");
%>
<jsp:include page="../includes/admin-header.jsp" />

<div class="page-header">
    <h1 class="page-title">Quản lý Nhà cung cấp</h1>
    <p class="page-subtitle">Quản lý thông tin các nhà cung cấp thuốc</p>
</div>

<div class="content-card">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
        <div>
            <h3 style="font-size: 1.3rem; color: #333; margin-bottom: 5px;">Danh sách Nhà cung cấp</h3>
            <p style="color: #666; font-size: 0.9rem;">Quản lý các đối tác cung cấp thuốc</p>
        </div>
        <div style="display: flex; gap: 10px;">
            <input type="text" id="searchInput" placeholder="Tìm kiếm nhà cung cấp..." style="padding: 10px 15px; border: 1px solid #ddd; border-radius: 8px; width: 300px;">
            <a href="${pageContext.request.contextPath}/admin/suppliers?action=new" style="padding: 10px 20px; background: linear-gradient(135deg, #0891b2, #0d9488); color: white; border-radius: 8px; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; font-weight: 600;">
                <i class="fas fa-plus"></i> Thêm NCC Mới
            </a>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty requestScope.listSuppliers}">
            <div style="text-align: center; padding: 60px 20px; color: #999;">
                <i class="fas fa-truck" style="font-size: 4rem; margin-bottom: 20px; color: #ddd;"></i>
                <h3 style="font-size: 1.3rem; margin-bottom: 10px;">Chưa có nhà cung cấp</h3>
                <p>Thêm nhà cung cấp đầu tiên để bắt đầu</p>
            </div>
        </c:when>
        <c:otherwise>
            <table style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr style="background: #f8f9fa; border-bottom: 2px solid #dee2e6;">
                        <th style="padding: 15px; text-align: left; font-weight: 600; color: #333;">ID</th>
                        <th style="padding: 15px; text-align: left; font-weight: 600; color: #333;">Tên NCC</th>
                        <th style="padding: 15px; text-align: left; font-weight: 600; color: #333;">Địa chỉ</th>
                        <th style="padding: 15px; text-align: left; font-weight: 600; color: #333;">Điện thoại</th>
                        <th style="padding: 15px; text-align: left; font-weight: 600; color: #333;">Email</th>
                        <th style="padding: 15px; text-align: center; font-weight: 600; color: #333;">Thao tác</th>
                    </tr>
                </thead>
                <tbody id="supplierTableBody">
                    <c:forEach var="supplier" items="${requestScope.listSuppliers}">
                        <tr style="border-bottom: 1px solid #dee2e6;" class="supplier-row">
                            <td style="padding: 15px; font-weight: 600; color: #0891b2;">#<c:out value="${supplier.supplierId}" /></td>
                            <td style="padding: 15px;">
                                <div style="display: flex; align-items: center; gap: 12px;">
                                    <div style="width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, #0891b2, #0d9488); color: white; display: flex; align-items: center; justify-content: center; font-weight: 600; font-size: 1.1rem;">
                                        <i class="fas fa-truck"></i>
                                    </div>
                                    <div style="font-weight: 600;"><c:out value="${supplier.name}" /></div>
                                </div>
                            </td>
                            <td style="padding: 15px; color: #666;"><c:out value="${supplier.address}" /></td>
                            <td style="padding: 15px; color: #666;">
                                <i class="fas fa-phone" style="color: #0891b2; margin-right: 5px;"></i>
                                <c:out value="${supplier.phone}" />
                            </td>
                            <td style="padding: 15px; color: #666;">
                                <i class="fas fa-envelope" style="color: #0891b2; margin-right: 5px;"></i>
                                <c:out value="${supplier.email}" />
                            </td>
                            <td style="padding: 15px; text-align: center;">
                                <a href="${pageContext.request.contextPath}/admin/suppliers?action=edit&id=<c:out value='${supplier.supplierId}' />" style="padding: 6px 12px; background: #0891b2; color: white; border: none; border-radius: 6px; text-decoration: none; display: inline-flex; align-items: center; gap: 5px; margin-right: 5px;">
                                    <i class="fas fa-edit"></i> Sửa
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/suppliers?action=delete&id=<c:out value='${supplier.supplierId}' />" onclick="return confirm('Xóa nhà cung cấp này?');" style="padding: 6px 12px; background: #dc3545; color: white; border: none; border-radius: 6px; text-decoration: none; display: inline-flex; align-items: center; gap: 5px;">
                                    <i class="fas fa-trash"></i> Xóa
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>

<script>
    // Search functionality
    document.getElementById('searchInput').addEventListener('keyup', function() {
        const searchValue = this.value.toLowerCase();
        const rows = document.querySelectorAll('.supplier-row');

        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(searchValue) ? '' : 'none';
        });
    });
</script>

<jsp:include page="../includes/admin-footer.jsp" />