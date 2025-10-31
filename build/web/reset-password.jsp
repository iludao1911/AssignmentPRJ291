<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lại Mật Khẩu - Nhà Thuốc MS</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
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
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
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
        }

        .form-group {
            margin-bottom: 20px;
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
            border-color: #0891b2;
            box-shadow: 0 0 0 4px rgba(8, 145, 178, 0.1);
        }

        .form-control.error {
            border-color: #ff4444;
        }

        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #999;
            user-select: none;
        }

        .password-strength {
            margin-top: 10px;
            height: 4px;
            background: #e0e0e0;
            border-radius: 2px;
            overflow: hidden;
        }

        .password-strength-bar {
            height: 100%;
            width: 0;
            transition: all 0.3s;
        }

        .strength-weak { 
            width: 33%; 
            background: #ff4444; 
        }

        .strength-medium { 
            width: 66%; 
            background: #ffaa00; 
        }

        .strength-strong { 
            width: 100%; 
            background: #00c851; 
        }

        .error-message {
            color: #ff4444;
            font-size: 0.8rem;
            margin-top: 5px;
            display: none;
        }

        .error-message.show {
            display: block;
        }

        .btn-primary {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            margin-top: 10px;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(8, 145, 178, 0.3);
        }

        .btn-primary:active {
            transform: translateY(0);
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

        .password-requirements {
            background: #f8f9fa;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
        }

        .password-requirements h4 {
            color: #333;
            font-size: 0.9rem;
            margin-bottom: 10px;
        }

        .password-requirements ul {
            list-style: none;
            padding: 0;
        }

        .password-requirements li {
            color: #666;
            font-size: 0.85rem;
            padding: 3px 0;
        }

        .password-requirements li i {
            width: 16px;
            margin-right: 8px;
            color: #999;
        }

        .password-requirements li.valid i {
            color: #00c851;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">
            <div class="logo-icon">
                <i class="fas fa-key"></i>
            </div>
            <div class="logo-text">Nhà Thuốc MS</div>
        </div>

        <div class="welcome-text">
            <h2>Đặt Lại Mật Khẩu</h2>
            <p>Nhập mật khẩu mới cho tài khoản của bạn</p>
        </div>

        <% String error = (String) request.getAttribute("error"); %>
        <% String token = (String) request.getAttribute("token"); %>
        
        <% if (error != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> <%= error %>
            </div>
        <% } %>

        <div class="password-requirements">
            <h4><i class="fas fa-shield-alt"></i> Yêu cầu mật khẩu:</h4>
            <ul id="requirements">
                <li id="req-length"><i class="far fa-circle"></i> Ít nhất 6 ký tự</li>
                <li id="req-upper"><i class="far fa-circle"></i> Có chữ hoa</li>
                <li id="req-lower"><i class="far fa-circle"></i> Có chữ thường</li>
                <li id="req-number"><i class="far fa-circle"></i> Có số</li>
            </ul>
        </div>

        <form action="reset-password" method="post" id="resetForm">
            <input type="hidden" name="token" value="<%= token != null ? token : "" %>">
            
            <div class="form-group">
                <label for="newPassword">Mật khẩu mới</label>
                <div class="input-wrapper">
                    <i class="fas fa-lock"></i>
                    <input type="password" id="newPassword" name="newPassword" class="form-control" 
                           placeholder="Nhập mật khẩu mới" required autofocus>
                    <span class="password-toggle" onclick="togglePassword('newPassword', 'toggleIcon1')">
                        <i class="fas fa-eye" id="toggleIcon1"></i>
                    </span>
                </div>
                <div class="password-strength">
                    <div class="password-strength-bar" id="strengthBar"></div>
                </div>
                <div class="error-message" id="passwordError">Mật khẩu phải có ít nhất 6 ký tự</div>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Xác nhận mật khẩu</label>
                <div class="input-wrapper">
                    <i class="fas fa-lock"></i>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                           placeholder="Nhập lại mật khẩu mới" required>
                    <span class="password-toggle" onclick="togglePassword('confirmPassword', 'toggleIcon2')">
                        <i class="fas fa-eye" id="toggleIcon2"></i>
                    </span>
                </div>
                <div class="error-message" id="confirmError">Mật khẩu không khớp</div>
            </div>

            <button type="submit" class="btn-primary">
                <i class="fas fa-check"></i> Đặt Lại Mật Khẩu
            </button>
        </form>
    </div>

    <script>
        const form = document.getElementById('resetForm');
        const newPassword = document.getElementById('newPassword');
        const confirmPassword = document.getElementById('confirmPassword');
        const strengthBar = document.getElementById('strengthBar');

        // Password strength checker
        newPassword.addEventListener('input', function() {
            const password = this.value;
            updatePasswordRequirements(password);
            const strength = calculatePasswordStrength(password);
            
            strengthBar.className = 'password-strength-bar';
            if (password.length === 0) {
                strengthBar.style.width = '0';
            } else if (strength < 40) {
                strengthBar.classList.add('strength-weak');
            } else if (strength < 80) {
                strengthBar.classList.add('strength-medium');
            } else {
                strengthBar.classList.add('strength-strong');
            }
        });

        function updatePasswordRequirements(password) {
            const reqLength = document.getElementById('req-length');
            const reqUpper = document.getElementById('req-upper');
            const reqLower = document.getElementById('req-lower');
            const reqNumber = document.getElementById('req-number');

            // Check length
            if (password.length >= 6) {
                reqLength.classList.add('valid');
                reqLength.querySelector('i').className = 'fas fa-check-circle';
            } else {
                reqLength.classList.remove('valid');
                reqLength.querySelector('i').className = 'far fa-circle';
            }

            // Check uppercase
            if (/[A-Z]/.test(password)) {
                reqUpper.classList.add('valid');
                reqUpper.querySelector('i').className = 'fas fa-check-circle';
            } else {
                reqUpper.classList.remove('valid');
                reqUpper.querySelector('i').className = 'far fa-circle';
            }

            // Check lowercase
            if (/[a-z]/.test(password)) {
                reqLower.classList.add('valid');
                reqLower.querySelector('i').className = 'fas fa-check-circle';
            } else {
                reqLower.classList.remove('valid');
                reqLower.querySelector('i').className = 'far fa-circle';
            }

            // Check number
            if (/\d/.test(password)) {
                reqNumber.classList.add('valid');
                reqNumber.querySelector('i').className = 'fas fa-check-circle';
            } else {
                reqNumber.classList.remove('valid');
                reqNumber.querySelector('i').className = 'far fa-circle';
            }
        }

        function calculatePasswordStrength(password) {
            let strength = 0;
            if (password.length >= 6) strength += 25;
            if (password.length >= 10) strength += 25;
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength += 25;
            if (/\d/.test(password)) strength += 15;
            if (/[^a-zA-Z\d]/.test(password)) strength += 10;
            return strength;
        }

        // Form validation
        form.addEventListener('submit', function(e) {
            let isValid = true;

            // Validate password
            if (newPassword.value.length < 6) {
                showError(newPassword, 'passwordError');
                isValid = false;
            } else {
                hideError(newPassword, 'passwordError');
            }

            // Validate confirm password
            if (confirmPassword.value !== newPassword.value) {
                showError(confirmPassword, 'confirmError');
                isValid = false;
            } else {
                hideError(confirmPassword, 'confirmError');
            }

            if (!isValid) {
                e.preventDefault();
            }
        });

        function showError(input, errorId) {
            input.classList.add('error');
            document.getElementById(errorId).classList.add('show');
        }

        function hideError(input, errorId) {
            input.classList.remove('error');
            document.getElementById(errorId).classList.remove('show');
        }

        function togglePassword(inputId, iconId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById(iconId);
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
    </script>
</body>
</html>
