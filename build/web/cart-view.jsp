<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.CartItem" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng của bạn</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    
</head>
<body>
<div class="container">
    <h2>🛒 Giỏ hàng của bạn</h2>

    <%
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
    %>
        <div class="empty">Giỏ hàng của bạn đang trống 😢</div>
        <div style="text-align:center;">
            <a href="customer-view-products.jsp" class="btn-checkout">🛍 Tiếp tục mua hàng</a>
        </div>
    <%
        } else {
            double totalAmount = 0;
            int totalQuantity = 0;
    %>

    <table>
        <thead>
        <tr>
            <th>Tên thuốc</th>
            <th>Giá (₫)</th>
            <th>Số lượng</th>
            <th>Thành tiền</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (CartItem item : cart) {
                double itemTotal = item.getMedicine().getPrice().doubleValue() * item.getQuantity();
                totalAmount += itemTotal;
                totalQuantity += item.getQuantity();
        %>
        <tr>
            <td><%= item.getMedicine().getName() %></td>
            <td><%= item.getMedicine().getPrice() %></td>
            <td><%= item.getQuantity() %></td>
            <td><%= String.format("%.2f", itemTotal) %></td>
            <td>
                <form action="cart" method="post">
    <input type="hidden" name="action" value="remove">
    <input type="hidden" name="medicineId" value="<%= item.getMedicine().getMedicineId() %>">
    <button type="submit" class="btn btn-danger">Xóa</button>
</form>


            </td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <div class="summary">
        <p><strong>Tổng số lượng:</strong> <%= totalQuantity %></p>
        <p><strong>Tổng tiền:</strong> <%= String.format("%.2f", totalAmount) %> ₫</p>
        <a href="checkout.jsp" class="btn-checkout">💳 Thanh toán</a>
        <br>
        <a href="customer-view-products.jsp" class="back-link">↩ Tiếp tục mua hàng</a>
    </div>

    <% } %>
</div>
</body>
</html>
