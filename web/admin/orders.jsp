<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Order" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    request.setAttribute("pageTitle", "Quản lý Đơn hàng");
    request.setAttribute("page", "orders");
%>
<jsp:include page="../includes/admin-header.jsp" />

<div class="page-header">
    <h1 class="page-title">Quản lý Đơn hàng</h1>
    <p class="page-subtitle">Xem và quản lý tất cả đơn hàng của khách hàng</p>
</div>

<div class="content-card">
    <!-- Tabs -->
    <div style="border-bottom: 2px solid #e5e7eb; margin-bottom: 25px;">
        <div style="display: flex; gap: 0; overflow-x: auto;">
            <button class="status-tab active" data-status="" style="padding: 15px 25px; background: none; border: none; border-bottom: 3px solid #0891b2; color: #0891b2; font-weight: 600; cursor: pointer; white-space: nowrap; transition: all 0.3s;">
                Tất cả (<span class="tab-count" data-status="">0</span>)
            </button>
            <button class="status-tab" data-status="Pending" style="padding: 15px 25px; background: none; border: none; border-bottom: 3px solid transparent; color: #666; font-weight: 600; cursor: pointer; white-space: nowrap; transition: all 0.3s;">
                Chờ xử lý (<span class="tab-count" data-status="Pending">0</span>)
            </button>
            <button class="status-tab" data-status="Processing" style="padding: 15px 25px; background: none; border: none; border-bottom: 3px solid transparent; color: #666; font-weight: 600; cursor: pointer; white-space: nowrap; transition: all 0.3s;">
                Đang xử lý (<span class="tab-count" data-status="Processing">0</span>)
            </button>
            <button class="status-tab" data-status="Shipped" style="padding: 15px 25px; background: none; border: none; border-bottom: 3px solid transparent; color: #666; font-weight: 600; cursor: pointer; white-space: nowrap; transition: all 0.3s;">
                Đang giao (<span class="tab-count" data-status="Shipped">0</span>)
            </button>
            <button class="status-tab" data-status="Done" style="padding: 15px 25px; background: none; border: none; border-bottom: 3px solid transparent; color: #666; font-weight: 600; cursor: pointer; white-space: nowrap; transition: all 0.3s;">
                Hoàn thành (<span class="tab-count" data-status="Done">0</span>)
            </button>
            <button class="status-tab" data-status="Cancelled" style="padding: 15px 25px; background: none; border: none; border-bottom: 3px solid transparent; color: #666; font-weight: 600; cursor: pointer; white-space: nowrap; transition: all 0.3s;">
                Đã hủy (<span class="tab-count" data-status="Cancelled">0</span>)
            </button>
        </div>
    </div>

    <div class="content-card">
    <!-- Status Tabs -->
    <div style="border-bottom: 2px solid #e5e7eb; margin-bottom: 25px;">
        <div style="display: flex; gap: 0; overflow-x: auto;">
            <button class="status-tab active" data-status="" onclick="filterByTab(this, '')" 
                    style="padding: 15px 25px; background: none; border: none; border-bottom: 3px solid #0891b2; color: #0891b2; font-weight: 600; cursor: pointer; white-space: nowrap; transition: all 0.3s;">
                Tất cả (<span id="count-all">0</span>)
            </button>
            <button class="status-tab" data-status="Chờ thanh toán" onclick="filterByTab(this, 'Chờ thanh toán')"
                    style="padding: 15px 25px; background: none; border: none; border-bottom: 3px solid transparent; color: #666; font-weight: 600; cursor: pointer; white-space: nowrap; transition: all 0.3s;">
                Chờ thanh toán (<span id="count-pending">0</span>)
            </button>
            <button class="status-tab" data-status="Đã thanh toán" onclick="filterByTab(this, 'Đã thanh toán')"
                    style="padding: 15px 25px; background: none; border: none; border-bottom: 3px solid transparent; color: #666; font-weight: 600; cursor: pointer; white-space: nowrap; transition: all 0.3s;">
                Đã thanh toán (<span id="count-paid">0</span>)
            </button>
            <button class="status-tab" data-status="Đang giao" onclick="filterByTab(this, 'Đang giao')"
                    style="padding: 15px 25px; background: none; border: none; border-bottom: 3px solid transparent; color: #666; font-weight: 600; cursor: pointer; white-space: nowrap; transition: all 0.3s;">
                Đang giao (<span id="count-shipped">0</span>)
            </button>
            <button class="status-tab" data-status="Hoàn thành" onclick="filterByTab(this, 'Hoàn thành')"
                    style="padding: 15px 25px; background: none; border: none; border-bottom: 3px solid transparent; color: #666; font-weight: 600; cursor: pointer; white-space: nowrap; transition: all 0.3s;">
                Hoàn thành (<span id="count-done">0</span>)
            </button>
            <button class="status-tab" data-status="Đã hủy" onclick="filterByTab(this, 'Đã hủy')"
                    style="padding: 15px 25px; background: none; border: none; border-bottom: 3px solid transparent; color: #666; font-weight: 600; cursor: pointer; white-space: nowrap; transition: all 0.3s;">
                Đã hủy (<span id="count-cancelled">0</span>)
            </button>
        </div>
    </div>

    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
        <div>
            <h3 style="font-size: 1.3rem; color: #333; margin-bottom: 5px;">Danh sách Đơn hàng</h3>
            <p style="color: #666; font-size: 0.9rem;">Hiển thị: <span id="displayCount">0</span> đơn hàng</p>
        </div>
        <div>
            <input type="text" id="searchInput" placeholder="Tìm kiếm đơn hàng..." style="padding: 10px 15px; border: 1px solid #ddd; border-radius: 8px; width: 300px;">
        </div>
    </div>

    <c:choose>
        <c:when test="${empty orders}">
            <div style="text-align: center; padding: 60px 20px; color: #999;">
                <i class="fas fa-shopping-cart" style="font-size: 4rem; margin-bottom: 20px; color: #ddd;"></i>
                <h3 style="font-size: 1.3rem; margin-bottom: 10px;">Chưa có đơn hàng</h3>
                <p>Các đơn hàng mới sẽ hiển thị tại đây</p>
            </div>
        </c:when>
        <c:otherwise>
            <table style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr style="background: #f8f9fa; border-bottom: 2px solid #dee2e6;">
                        <th style="padding: 15px; text-align: left; font-weight: 600; color: #333;">Mã ĐH</th>
                        <th style="padding: 15px; text-align: left; font-weight: 600; color: #333;">Khách hàng</th>
                        <th style="padding: 15px; text-align: left; font-weight: 600; color: #333;">Ngày đặt</th>
                        <th style="padding: 15px; text-align: right; font-weight: 600; color: #333;">Tổng tiền</th>
                        <th style="padding: 15px; text-align: center; font-weight: 600; color: #333;">Trạng thái</th>
                        <th style="padding: 15px; text-align: center; font-weight: 600; color: #333;">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}">
                    <tr style="border-bottom: 1px solid #dee2e6;" class="order-row" data-status="${order.status}">
                        <td style="padding: 15px; font-weight: 600; color: #0891b2;">#${order.orderId}</td>
                        <td style="padding: 15px;">
                            <div style="font-weight: 600; margin-bottom: 3px;">${not empty order.userName ? order.userName : 'N/A'}</div>
                            <div style="font-size: 0.85rem; color: #666;">${order.userEmail}</div>
                        </td>
                        <td style="padding: 15px; color: #666;"><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td style="padding: 15px; text-align: right; font-weight: 600; color: #0891b2;"><fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/>₫</td>
                        <td style="padding: 15px; text-align: center;">
                            <span style="background: ${order.status == 'Chờ thanh toán' ? '#fff3cd' : order.status == 'Đã thanh toán' ? '#d1ecf1' : order.status == 'Đang giao' ? '#cfe2ff' : order.status == 'Hoàn thành' ? '#d4edda' : '#f8d7da'}; color: ${order.status == 'Chờ thanh toán' ? '#856404' : order.status == 'Đã thanh toán' ? '#0c5460' : order.status == 'Đang giao' ? '#084298' : order.status == 'Hoàn thành' ? '#155724' : '#721c24'}; padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; display: inline-block;">${order.status}</span>
                        </td>
                        <td style="padding: 15px; text-align: center;">
                            <button onclick="viewOrderDetail(${order.orderId})" style="padding: 6px 12px; background: #6c757d; color: white; border: none; border-radius: 6px; cursor: pointer; display: inline-flex; align-items: center; gap: 5px; margin-right: 5px;">
                                <i class="fas fa-eye"></i> Xem
                            </button>
                            <c:if test="${order.status == 'Đã thanh toán'}">
                                <a href="${pageContext.request.contextPath}/admin/orders?action=updateStatus&id=${order.orderId}&status=Đang giao" onclick="return confirm('Xác nhận giao hàng?');" style="padding: 6px 12px; background: #0891b2; color: white; border: none; border-radius: 6px; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; gap: 5px; margin-right: 5px;">
                                    <i class="fas fa-truck"></i> Giao hàng
                                </a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/admin/orders?action=delete&id=${order.orderId}" onclick="return confirm('Xóa đơn hàng này?');" style="padding: 6px 12px; background: #dc3545; color: white; border: none; border-radius: 6px; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; gap: 5px;">
                                <i class="fas fa-trash"></i>
                            </a>
                        </td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>

<!-- Order Detail Modal -->
<div id="orderModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center;">
    <div style="background: white; border-radius: 12px; width: 90%; max-width: 900px; max-height: 90vh; overflow-y: auto; position: relative;">
        <div style="position: sticky; top: 0; background: white; border-bottom: 2px solid #e5e7eb; padding: 20px; display: flex; justify-content: space-between; align-items: center; z-index: 1;">
            <h2 style="margin: 0; color: #333;"><i class="fas fa-receipt"></i> Chi tiết Đơn hàng <span id="modalOrderId"></span></h2>
            <button onclick="closeModal()" style="background: none; border: none; font-size: 1.5rem; color: #999; cursor: pointer; padding: 5px 10px;">&times;</button>
        </div>
        
        <div style="padding: 20px;">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
                <!-- Customer Info -->
                <div style="padding: 15px; background: #f8f9fa; border-radius: 8px;">
                    <h3 style="margin: 0 0 15px 0; color: #0891b2; font-size: 1.1rem;"><i class="fas fa-user"></i> Khách hàng</h3>
                    <div style="display: flex; flex-direction: column; gap: 8px;">
                        <div><strong>Tên:</strong> <span id="modalCustomerName"></span></div>
                        <div><strong>Email:</strong> <span id="modalCustomerEmail"></span></div>
                    </div>
                </div>
                
                <!-- Order Info -->
                <div style="padding: 15px; background: #f8f9fa; border-radius: 8px;">
                    <h3 style="margin: 0 0 15px 0; color: #0891b2; font-size: 1.1rem;"><i class="fas fa-info-circle"></i> Thông tin</h3>
                    <div style="display: flex; flex-direction: column; gap: 8px;">
                        <div><strong>Ngày đặt:</strong> <span id="modalOrderDate"></span></div>
                        <div><strong>Trạng thái:</strong> <span id="modalOrderStatus"></span></div>
                        <div><strong>Địa chỉ:</strong> <span id="modalShippingAddress"></span></div>
                    </div>
                </div>
            </div>
            
            <!-- Order Items -->
            <div style="margin-bottom: 20px;">
                <h3 style="color: #333; margin-bottom: 15px;"><i class="fas fa-pills"></i> Sản phẩm</h3>
                <div id="modalOrderItems" style="background: #f8f9fa; border-radius: 8px; padding: 15px;">
                    <!-- Items will be loaded here -->
                </div>
            </div>
            
            <!-- Total -->
            <div style="background: #e7f6f8; padding: 15px; border-radius: 8px; text-align: right;">
                <span style="font-size: 1.2rem; font-weight: 600;">Tổng cộng: </span>
                <span id="modalTotalAmount" style="font-size: 1.4rem; font-weight: 700; color: #0891b2;"></span>
            </div>
        </div>
    </div>
</div>

<script>
    let currentStatus = '';
    const ordersData = [
        <c:forEach var="order" items="${orders}" varStatus="status">
        {
            orderId: ${order.orderId},
            customerName: '${not empty order.userName ? order.userName : "N/A"}',
            customerEmail: '${order.userEmail}',
            orderDate: '<fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>',
            status: '${order.status}',
            shippingAddress: '${not empty order.shippingAddress ? order.shippingAddress : "Chưa cập nhật"}',
            totalAmount: ${order.totalAmount}
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    
    // Count orders by status on page load
    document.addEventListener('DOMContentLoaded', function() {
        updateCounts();
        filterOrders();
    });
    
    document.getElementById('searchInput').addEventListener('keyup', filterOrders);

    function updateCounts() {
        const rows = document.querySelectorAll('.order-row');
        const counts = {all: 0, pending: 0, paid: 0, shipped: 0, done: 0, cancelled: 0};
        
        rows.forEach(row => {
            const status = row.getAttribute('data-status');
            counts.all++;
            if (status === 'Chờ thanh toán') counts.pending++;
            else if (status === 'Đã thanh toán') counts.paid++;
            else if (status === 'Đang giao') counts.shipped++;
            else if (status === 'Hoàn thành') counts.done++;
            else if (status === 'Đã hủy') counts.cancelled++;
        });
        
        document.getElementById('count-all').textContent = counts.all;
        document.getElementById('count-pending').textContent = counts.pending;
        document.getElementById('count-paid').textContent = counts.paid;
        document.getElementById('count-shipped').textContent = counts.shipped;
        document.getElementById('count-done').textContent = counts.done;
        document.getElementById('count-cancelled').textContent = counts.cancelled;
    }
    
    function filterByTab(button, status) {
        // Update active tab
        document.querySelectorAll('.status-tab').forEach(tab => {
            tab.classList.remove('active');
            tab.style.borderBottom = '3px solid transparent';
            tab.style.color = '#666';
        });
        button.classList.add('active');
        button.style.borderBottom = '3px solid #0891b2';
        button.style.color = '#0891b2';
        
        currentStatus = status;
        filterOrders();
    }

    function filterOrders() {
        const searchValue = document.getElementById('searchInput').value.toLowerCase();
        const rows = document.querySelectorAll('.order-row');
        let displayCount = 0;

        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            const status = row.getAttribute('data-status');
            const matchesSearch = text.includes(searchValue);
            const matchesStatus = !currentStatus || status === currentStatus;

            if (matchesSearch && matchesStatus) {
                row.style.display = '';
                displayCount++;
            } else {
                row.style.display = 'none';
            }
        });
        
        document.getElementById('displayCount').textContent = displayCount;
    }
    
    function viewOrderDetail(orderId) {
        const order = ordersData.find(o => o.orderId === orderId);
        if (!order) return;
        
        // Fill modal data
        document.getElementById('modalOrderId').textContent = '#' + order.orderId;
        document.getElementById('modalCustomerName').textContent = order.customerName;
        document.getElementById('modalCustomerEmail').textContent = order.customerEmail;
        document.getElementById('modalOrderDate').textContent = order.orderDate;
        document.getElementById('modalShippingAddress').textContent = order.shippingAddress;
        
        // Status badge
        let statusHtml = '';
        switch(order.status) {
            case 'Chờ thanh toán':
                statusHtml = '<span style="background: #fff3cd; color: #856404; padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">Chờ thanh toán</span>';
                break;
            case 'Đã thanh toán':
                statusHtml = '<span style="background: #d1ecf1; color: #0c5460; padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">Đã thanh toán</span>';
                break;
            case 'Đang giao':
                statusHtml = '<span style="background: #cfe2ff; color: #084298; padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">Đang giao</span>';
                break;
            case 'Hoàn thành':
                statusHtml = '<span style="background: #d4edda; color: #155724; padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">Hoàn thành</span>';
                break;
            case 'Đã hủy':
                statusHtml = '<span style="background: #f8d7da; color: #721c24; padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">Đã hủy</span>';
                break;
        }
        document.getElementById('modalOrderStatus').innerHTML = statusHtml;
        
        // Load order items via AJAX
        fetch('${pageContext.request.contextPath}/admin/orders?action=getDetails&id=' + orderId)
            .then(response => response.json())
            .then(data => {
                let itemsHtml = '<table style="width: 100%; border-collapse: collapse;">';
                itemsHtml += '<tr style="background: #dee2e6; font-weight: 600;"><td style="padding: 10px;">Sản phẩm</td><td style="padding: 10px; text-align: center;">SL</td><td style="padding: 10px; text-align: right;">Giá</td><td style="padding: 10px; text-align: right;">Tổng</td></tr>';
                data.items.forEach(item => {
                    itemsHtml += '<tr style="border-bottom: 1px solid #dee2e6;">';
                    itemsHtml += '<td style="padding: 10px;">' + item.medicineName + '</td>';
                    itemsHtml += '<td style="padding: 10px; text-align: center;">' + item.quantity + '</td>';
                    itemsHtml += '<td style="padding: 10px; text-align: right;">' + item.price.toLocaleString() + '₫</td>';
                    itemsHtml += '<td style="padding: 10px; text-align: right; font-weight: 600;">' + (item.price * item.quantity).toLocaleString() + '₫</td>';
                    itemsHtml += '</tr>';
                });
                itemsHtml += '</table>';
                document.getElementById('modalOrderItems').innerHTML = itemsHtml;
            });
        
        document.getElementById('modalTotalAmount').textContent = order.totalAmount.toLocaleString() + '₫';
        
        // Show modal
        document.getElementById('orderModal').style.display = 'flex';
    }
    
    function closeModal() {
        document.getElementById('orderModal').style.display = 'none';
    }
    
    // Close modal when clicking outside
    document.getElementById('orderModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeModal();
        }
    });
</script>

<jsp:include page="../includes/admin-footer.jsp" />
