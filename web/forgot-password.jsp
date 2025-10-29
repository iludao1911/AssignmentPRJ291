<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên Mật Khẩu - Nhà Thuốc MS</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .container {
            max-width: 500px;
            width: 100%;
            background: white;
            border-radius: 20px;
            padding: 50px 40px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            position: relative;
        }

        .logo {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 30px;
        }

        .logo-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
        }

        .logo-icon i {
            color: white;
            font-size: 2rem;
        }

        .logo-text {
            font-size: 1.5rem;
            font-weight: 700;
            color: #333;
        }

        .welcome-text {
            text-align: center;
            margin-bottom: 40px;
        }

        .welcome-text h2 {
            font-size: 2rem;
            color: #333;
            margin-bottom: 10px;
        }

        .welcome-text p {
            color: #666;
            font-size: 0.95rem;
            line-height: 1.6;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
            font-size: 0.9rem;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
        }

        .form-control {
            width: 100%;
            padding: 14px 45px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 0.95rem;
            transition: all 0.3s;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }

        .btn-primary {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .back-link {
            text-align: center;
            margin-top: 25px;
            color: #666;
            font-size: 0.9rem;
        }

        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }

        .back-link a:hover {
            text-decoration: underline;
        }

        .alert {
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 0.9rem;
        }

        .alert-error {
            background: #fee;
            color: #c33;
            border-left: 4px solid #c33;
        }

        .alert-success {
            background: #efe;
            color: #3c3;
            border-left: 4px solid #3c3;
        }

        .info-box {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
        }

        .info-box i {
            color: #2196f3;
            margin-right: 10px;
        }

        .info-box p {
            color: #1565c0;
            font-size: 0.9rem;
            margin: 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">
            <div class="logo-icon">
                <i class="fas fa-lock"></i>
            </div>
            <div class="logo-text">Nhà Thuốc MS</div>
        </div>

        <div class="welcome-text">
            <h2>Quên Mật Khẩu?</h2>
            <p>Nhập email của bạn và chúng tôi sẽ gửi link đặt lại mật khẩu</p>
        </div>

        <% String error = (String) request.getAttribute("error"); %>
        <% String success = (String) request.getAttribute("success"); %>
        
        <% if (error != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> <%= error %>
            </div>
        <% } %>
        
        <% if (success != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> <%= success %>
            </div>
        <% } %>

        <div class="info-box">
            <i class="fas fa-info-circle"></i>
            <p>Link đặt lại mật khẩu sẽ có hiệu lực trong <strong>1 giờ</strong></p>
        </div>

        <form action="forgot-password" method="post">
            <div class="form-group">
                <label for="email">Địa chỉ Email</label>
                <div class="input-wrapper">
                    <i class="fas fa-envelope"></i>
                    <input type="email" id="email" name="email" class="form-control" 
                           placeholder="Nhập email đã đăng ký" required autofocus>
                </div>
            </div>

            <button type="submit" class="btn-primary">
                <i class="fas fa-paper-plane"></i> Gửi Link Đặt Lại
            </button>
        </form>

        <div class="back-link">
            Nhớ mật khẩu rồi? <a href="auth-login.jsp">Đăng nhập ngay</a>
        </div>
    </div>
</body>
</html>
