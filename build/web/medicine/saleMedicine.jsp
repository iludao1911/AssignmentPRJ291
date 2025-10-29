<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chỉnh Sửa Giá Sale</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #e8f5e9;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 420px;
            margin: 50px auto;
            background-color: #a5d6a7;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 3px 3px 10px rgba(0,0,0,0.2);
        }
        h2 {
            text-align: center;
            color: #1b5e20;
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-top: 12px;
            color: #2e7d32;
            font-weight: bold;
        }
        input[type="number"] {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border-radius: 5px;
            border: 1px solid #388e3c;
        }
        .button-group {
            display: flex;
            justify-content: space-between;
            margin-top: 25px;
        }
        button {
            font-size: 16px;
            padding: 10px 22px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-submit {
            background-color: #43a047;
            color: white;
            box-shadow: 2px 3px 5px rgba(0,0,0,0.2);
        }
        .btn-submit:hover {
            background-color: #2e7d32;
            transform: translateY(-2px);
        }
        .btn-cancel {
            background-color: #c8e6c9;
            color: #2e7d32;
            border: 1px solid #2e7d32;
        }
        .btn-cancel:hover {
            background-color: #81c784;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Chỉnh Sửa Giá Sale cho ${medicine.name}</h2>

        <form action="${pageContext.request.contextPath}/medicines?action=updateSale" 
              method="post">
            
            <input type="hidden" name="id" value="${medicine.medicineId}">

            <label for="price">Giá gốc:</label>
            <input type="number" id="price" name="price" value="${medicine.price}" readonly step="0.01"><br>

            <label for="salePrice">Giá Sale:</label>
            <input type="number" id="salePrice" name="salePrice" value="${medicine.salePrice}" required step="0.01"><br>

            <div class="button-group">
                <button type="submit" class="btn-submit">Cập Nhật Giá Sale</button>
                <button type="button" class="btn-cancel" onclick="window.location.href='${pageContext.request.contextPath}/medicines'">Quay lại</button>
            </div>
        </form>
    </div>
</body>
</html>