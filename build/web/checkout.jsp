<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán - Pharmacy Shop</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #cce5ff, #f8f9fa);
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 420px;
            margin: 80px auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            padding: 35px;
        }

        h2 {
            text-align: center;
            color: #007bff;
            margin-bottom: 30px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        input[type="text"], select {
            width: 100%;
            padding: 10px 12px;
            border-radius: 10px;
            border: 1px solid #ccc;
            margin-bottom: 20px;
            font-size: 14px;
            transition: all 0.2s ease;
        }

        input[type="text"]:focus, select:focus {
            border-color: #007bff;
            box-shadow: 0 0 6px rgba(0,123,255,0.3);
            outline: none;
        }

        button {
            width: 100%;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 12px;
            padding: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        button:hover {
            background-color: #0056b3;
            transform: scale(1.02);
        }

        .note {
            text-align: center;
            font-size: 13px;
            color: #555;
            margin-top: 10px;
        }

        .back-link {
            display: inline-block;
            margin-top: 15px;
            text-decoration: none;
            color: #007bff;
            font-size: 14px;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Thông tin thanh toán</h2>

    <form action="checkout" method="post">
        
        <label for="name">Nhập tên :</label>
        <input type="text" id="name" name="name" placeholder="Nhập tên ..." required>
        
        <label for="phone">Nhập số điện thoại:</label>
        <input type="text" id="phone" name="phone" placeholder="Nhập số điện thoại..." required>
        
        <label for="email">Nhập email:</label>
        <input type="text" id="email" name="email" placeholder="Nhập email..." required>
        
        <label for="address">Địa chỉ nhận hàng:</label>
        <input type="text" id="address" name="address" placeholder="Nhập địa chỉ giao hàng..." required>
        

        <label for="paymentMethod">Phương thức thanh toán:</label>
        <select id="paymentMethod" name="paymentMethod" required>
            <option value="COD">Thanh toán khi nhận hàng (COD)</option>
            <option value="BANKING">Chuyển khoản ngân hàng</option>
            <option value="MOMO">Ví MoMo</option>
        </select>

        <button type="submit">💳 Xác nhận thanh toán</button>
    </form>

    <div class="note">
        Đảm bảo thông tin của bạn chính xác để đơn hàng được giao đúng hạn.
    </div>

    <div style="text-align:center;">
        <a href="cart-view.jsp" class="back-link">← Quay lại giỏ hàng</a>
    </div>
</div>
</body>
</html>
