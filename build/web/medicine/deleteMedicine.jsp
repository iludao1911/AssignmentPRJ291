<%-- 
    Document   : deleteMedicine
    Created on : Oct 24, 2025, 3:28:43 PM
    Author     : ASUS
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Medicine" %>
<%
    Medicine product = (Medicine) request.getAttribute("medicine");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xóa Sản Phẩm</title>
    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f3f4f6;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 420px;
            margin: 80px auto;
        }
        .card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .card-header {
            background-color: #e63946;
            color: white;
            font-size: 22px;
            font-weight: bold;
            text-align: center;
            padding: 15px 0;
            letter-spacing: 0.5px;
        }
        .card-body {
            padding: 25px;
            text-align: center;
        }
        .card-body h5 {
            color: #666;
            margin-bottom: 20px;
        }
        .info-box {
            background-color: #f9fafb;
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 25px;
            text-align: left;
        }
        .info-box p {
            margin: 8px 0;
            font-size: 15px;
        }
        .info-box strong {
            color: #333;
        }
        .btn {
            border: none;
            padding: 10px 25px;
            font-size: 15px;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.3s;
            margin: 0 6px;
        }
        .btn-delete {
            background-color: #e63946;
            color: white;
        }
        .btn-delete:hover {
            background-color: #c82333;
        }
        .btn-cancel {
            background-color: #6c757d;
            color: white;
        }
        .btn-cancel:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="card">
        <div class="card-header">
            Xác Nhận Xóa Sản Phẩm
        </div>
        <div class="card-body">
            <h5>Bạn có chắc chắn muốn xóa sản phẩm này không?</h5>
            <div class="info-box">
                <p><strong>ID:</strong> <%= product.getMedicineId() %></p>
                <p><strong>Tên sản phẩm:</strong> <%= product.getName() %></p>
                <p><strong>Mô tả:</strong> <%= product.getDescription() %></p>
                <p><strong>Giá:</strong> <%= product.getPrice() %> VND</p>
                <p><strong>Số lượng tồn:</strong> <%= product.getQuantity() %></p>
                <p><strong>Ngày nhập:</strong> <%= product.getExpiryDate() %></p>
            </div>

            <form action="<%= request.getContextPath() %>/medicine" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="<%= product.getMedicineId() %>">
                <button type="submit" class="btn btn-delete">🗑 Xóa</button>
                <a href="<%= request.getContextPath() %>/medicine" class="btn btn-cancel">❌ Hủy</a>
            </form>
        </div>
    </div>
</div>
</body>
</html>

