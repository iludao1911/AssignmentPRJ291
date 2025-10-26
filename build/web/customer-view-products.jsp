<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh mục Thuốc Công Khai</title>
    <style>
        body { font-family: Arial, sans-serif; }
        table { 
            border-collapse: collapse; 
            width: 70%;
            margin-top: 20px; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        th { 
            background-color: #3f51b5;
            color: white; 
            padding: 12px 15px; 
            text-align: left;
        }
        td { 
            border: 1px solid #ddd; 
            padding: 10px 15px;
        }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .price, .date { text-align: right; }
        h1, p { margin-left: 15%; }
        .btn {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn:hover { background-color: #45a049; }
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.currentCustomer}">
        <c:redirect url="customerLogin" />
    </c:if>

    <h1>Danh mục Thuốc</h1>
    <p>Chào mừng Khách hàng <c:out value="${sessionScope.currentCustomer.name}" />!</p>
    
    <c:if test="${not empty error}">
        <p class="error">Lỗi: <c:out value="${error}" /></p>
    </c:if>

    <table style="margin-left: 15%;">
        <thead>
            <tr>
                <th>Tên Thuốc</th>
                <th class="price">Giá (VND)</th>
                <th class="date">Hạn Dùng</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="medicine" items="${requestScope.listMedicines}">
                <tr>
                    <td><c:out value="${medicine.name}" /></td>
                    <td class="price"><c:out value="${medicine.price}" /></td>
                    <td class="date"><c:out value="${medicine.expiryDate}" /></td>
                    <td>
                        <form action="cart" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="medicineId" value="${medicine.medicineId}">
                            <input type="number" name="quantity" value="1" min="1" style="width:50px;">
                            <button type="submit" class="btn">Thêm vào giỏ</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty requestScope.listMedicines}">
                 <tr><td colspan="4">Hiện tại chưa có sản phẩm nào.</td></tr>
            </c:if>
        </tbody>
    </table>

    <p style="margin-top: 20px; margin-left: 15%;">
        <a href="index.jsp">Về trang chủ</a> | 
        <a href="customerLogin?action=logout">Đăng xuất</a> | 
        <a href="cart?action=view">🛒 Xem giỏ hàng</a>
    </p>
</body>
</html>
