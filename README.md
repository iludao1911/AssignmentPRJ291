# Nhà Thuốc MS - Hệ Thống Quản Lý Nhà Thuốc

## Mô tả
Hệ thống quản lý nhà thuốc trực tuyến với các tính năng:
- Quản lý thuốc, nhà cung cấp, đơn hàng
- Xác thực email và quên mật khẩu
- Phân quyền Admin/Customer
- Giao diện hiện đại với Bootstrap và Font Awesome

## Cài đặt Database

### Yêu cầu
- SQL Server 2019 trở lên
- PowerShell (Windows) hoặc SQL Server Management Studio

### Chạy Script Database

**Khuyên dùng - PowerShell:**
```powershell
Invoke-Sqlcmd -ServerInstance "localhost" -Username "sa" -Password "123456" -InputFile "SQLProject.sql"
```

**Hoặc sử dụng SSMS:**
1. Mở file `SQLProject.sql` trong SQL Server Management Studio
2. Đảm bảo encoding là UTF-8
3. Nhấn F5 để chạy script

### Thông tin đăng nhập mặc định
- **Admin**: admin@email.com / admin123
- **Customer**: nguyenvana@email.com / 123456

## Cấu hình Email
Chỉnh sửa `config.properties`:
```properties
mail.smtp.host=smtp.gmail.com
mail.smtp.port=587
mail.username=your-email@gmail.com
mail.password=your-app-password
```

## Công nghệ sử dụng
- **Backend**: Java Servlets (Jakarta EE 9+)
- **Database**: SQL Server với JDBC Driver
- **Frontend**: JSP, HTML5, CSS3, JavaScript
- **Email**: JavaMail API với Gmail SMTP
- **Build Tool**: Apache Ant

## Cấu trúc Database
- `User` - Người dùng (Admin/Customer) với xác thực email
- `Medicine` - Danh sách thuốc với hình ảnh và giá sale
- `Supplier` - Nhà cung cấp
- `Order` & `OrderDetail` - Đơn hàng và chi tiết
- `VerificationToken` - Token cho email verification và password reset

## Lưu ý quan trọng
⚠️ **Encoding UTF-8**: 
- File `SQLProject.sql` phải được lưu với encoding UTF-8
- Connection string trong `DBConnection.java` đã có `characterEncoding=UTF-8`
- Tất cả JSP files sử dụng `pageEncoding="UTF-8"`

## Liên hệ
Project được phát triển cho môn PRJ291 - FPT University