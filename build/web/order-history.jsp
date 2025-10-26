<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Lịch sử đơn hàng</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial;
            background-color: #f0f2f5;
            margin: 40px;
        }
        h2 {
            color: #007bff;
            text-align: center;
            margin-bottom: 20px;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            background: #fff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            text-align: center;
        }
        th {
            background: #007bff;
            color: white;
        }
        tr:hover {
            background-color: #f1f9ff;
        }
        .btn-delete {
            background: #dc3545;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-delete:hover {
            background: #c82333;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #007bff;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<h2>🧾 Lịch sử đơn hàng của bạn</h2>

<table>
    <tr>
        <th>Mã đơn</th>
        <th>Ngày đặt</th>
        <th>Tổng tiền</th>
        <th>Phương thức thanh toán</th>
        <th>Địa chỉ</th>
        <th>Thao tác</th>
    </tr>

    <c:forEach var="o" items="${orderList}">
        <tr>
            <td>${o.orderId}</td>
            <td>${o.orderDate}</td>
            <td>${o.total} đ</td>
            <td>${o.paymentMethod}</td>
            <td>${o.address}</td>
            <td>
                <form action="order" method="post" onsubmit="return confirm('Bạn có chắc muốn xóa đơn hàng này?');">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="orderId" value="${o.orderId}">
            <button type="submit" class="btn-delete">🗑 Xóa</button>
                </form>
            </td>
        </tr>
    </c:forEach>
</table>

<a href="customer-view-products.jsp" class="back-link">← Quay lại trang sản phẩm</a>

</body>
</html>
