<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chỉnh Sửa Thuốc</title>
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
        input[type="text"],
        input[type="number"],
        input[type="date"],
        textarea,
        input[type="file"] {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border-radius: 5px;
            border: 1px solid #388e3c;
        }
        textarea {
            resize: none;
            height: 70px;
        }
        .current-image {
            margin-top: 10px;
        }
        .current-image img {
            max-width: 150px;
            border-radius: 5px;
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
        .error {
            color: red;
            text-align: center;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Chỉnh Sửa Thuốc</h2>

        <c:if test="${not empty errorMsg}">
            <p class="error">${errorMsg}</p>
        </c:if>

        <form action="${pageContext.request.contextPath}/medicines?action=update" 
              method="post" enctype="multipart/form-data">
            
            <input type="hidden" name="id" value="${medicine.medicineId}">

            <label for="supplierId">Mã nhà cung cấp:</label>
            <input type="number" id="supplierId" name="supplierId" value="${medicine.supplierId}" required><br>

            <label for="name">Tên thuốc:</label>
            <input type="text" id="name" name="name" value="${medicine.name}" required><br>

            <label for="description">Mô tả:</label>
            <textarea id="description" name="description">${medicine.description}</textarea><br>

            <label for="price">Giá:</label>
            <input type="number" id="price" name="price" value="${medicine.price}" required step="0.01"><br>

            <label for="quantity">Số lượng:</label>
            <input type="number" id="quantity" name="quantity" value="${medicine.quantity}" required><br>

            <label for="category">Loại:</label>
            <input type="text" id="category" name="category" value="${medicine.category}"><br>

            <label for="expiryDate">Hạn sử dụng:</label>
            <input type="date" id="expiryDate" name="expiryDate" value="${medicine.expiryDate}" required><br>

            <label for="image">Ảnh thuốc:</label>
            <p>Để trống nếu không muốn thay đổi ảnh hiện tại.</p>
            <input type="file" id="image" name="image" accept="image/*"><br>
            
            <div class="current-image">
                <label>Ảnh hiện tại:</label>
                <c:if test="${not empty medicine.imagePath}">
                    <img src="${pageContext.request.contextPath}/image/${medicine.imagePath}" alt="Current Image">
                </c:if>
                <c:if test="${empty medicine.imagePath}">
                    <p>Chưa có ảnh.</p>
                </c:if>
            </div>

            <div class="button-group">
                <button type="submit" class="btn-submit">Cập Nhật</button>
                <button type="button" class="btn-cancel" onclick="window.location.href='${pageContext.request.contextPath}/medicines'">Quay lại</button>
            </div>
        </form>
    </div>
</body>
</html>
