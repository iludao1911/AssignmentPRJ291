<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Access Denied</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            text-align: center;
            padding: 50px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #d9534f;
            font-size: 48px;
        }
        p {
            font-size: 18px;
        }
        a {
            color: #007bff;
            text-decoration: none;
            font-weight: bold;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>403</h1>
        <h2>Truy cập bị từ chối</h2>
        <p>Bạn không có quyền truy cập vào trang này.</p>
        <p>Vui lòng <a href="${pageContext.request.contextPath}/login">đăng nhập</a> với tài khoản có quyền hạn hoặc quay trở lại <a href="${pageContext.request.contextPath}/">trang chủ</a>.</p>
    </div>
</body>
</html>
