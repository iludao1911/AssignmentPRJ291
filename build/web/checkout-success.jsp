<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<head>
    <meta charset="UTF-8">
    <title>Hóa đơn thanh toán</title>
    <style>
        body { font-family: Arial, sans-serif; }
        table { border-collapse: collapse; width: 80%; margin: 20px auto; }
        th, td { border: 1px solid #ddd; padding: 10px; }
        th { background-color: #4CAF50; color: white; }
        .center { text-align: center; }
    </style>
</head>
<body>
<h2 class="center">💳 Hóa đơn thanh toán</h2>

<p class="center">Cảm ơn bạn, <strong>${customer.name}</strong>, đã mua hàng!</p>

<table>
    <tr>
        <th>Tên thuốc</th>
        <th>Giá (₫)</th>
        <th>Số lượng</th>
        <th>Thành tiền</th>
    </tr>

    <c:forEach var="item" items="${cart}">
        <tr>
            <td>${item.medicine.name}</td>
            <td><fmt:formatNumber value="${item.medicine.price}" type="number" groupingUsed="true"/> ₫</td>
            <td>${item.quantity}</td>
            <td><fmt:formatNumber value="${item.medicine.price * item.quantity}" type="number" groupingUsed="true"/> ₫</td>
        </tr>
    </c:forEach>
</table>

<p class="center">
    <strong>Tổng số lượng:</strong> ${totalQuantity} <br>
    <strong>Tổng tiền:</strong> ${totalAmount} ₫
</p>

<div class="center">
    <a href="customer-view-products" style="text-decoration:none; color:#007bff;">↩ Quay lại cửa hàng</a>
</div>

</body>
</html>
