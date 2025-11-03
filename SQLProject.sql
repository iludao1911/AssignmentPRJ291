-- =====================================================
-- Script: Xóa và Tạo lại Database Project
-- Mục đích: Quản lý Nhà Thuốc MS
-- =====================================================
--
-- HƯỚNG DẪN CHẠY SCRIPT:
-- 
-- Cách 1: Sử dụng PowerShell (KHUYÊN DÙNG - Hỗ trợ UTF-8 tốt):
--   Invoke-Sqlcmd -ServerInstance "localhost" -Username "sa" -Password "123456" -InputFile "SQLProject.sql"
--
-- Cách 2: Sử dụng SQL Server Management Studio (SSMS):
--   1. Mở file này trong SSMS
--   2. Đảm bảo encoding là UTF-8
--   3. Nhấn F5 để thực thi
--
-- Cách 3: Sử dụng sqlcmd (KHÔNG KHUYÊN DÙNG - Có thể lỗi tiếng Việt):
--   sqlcmd -S localhost -U sa -P 123456 -i "SQLProject.sql"
--
-- LƯU Ý:
-- - File này phải được lưu với encoding UTF-8 (hoặc UTF-8 with BOM)
-- - Thay đổi thông tin kết nối (server, username, password) nếu cần
-- - Script sẽ XÓA database cũ và tạo database mới hoàn toàn
-- =====================================================

-- -----------------------------------------------------
-- BƯỚC 1: Xóa Database an toàn
-- -----------------------------------------------------
USE master;
GO

IF DB_ID('Project') IS NOT NULL
BEGIN
    PRINT 'Đang xóa database Project...';
    
    -- 1. Đóng tất cả kết nối đang hoạt động
    DECLARE @kill varchar(8000) = '';
    SELECT @kill = @kill + 'KILL ' + CONVERT(varchar(5), session_id) + ';'
    FROM sys.dm_exec_sessions
    WHERE database_id = DB_ID('Project');
    
    IF LEN(@kill) > 0
    BEGIN
        EXEC(@kill);
        PRINT 'Đã đóng tất cả kết nối.';
    END
    
    -- 2. Chuyển sang chế độ SINGLE_USER
    ALTER DATABASE Project SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    
    -- 3. Xóa database
    DROP DATABASE Project;
    PRINT 'Database Project đã được xóa thành công!';
END
ELSE
BEGIN
    PRINT 'Database Project không tồn tại.';
END
GO

-- -----------------------------------------------------
-- BƯỚC 2: Tạo Database mới
-- -----------------------------------------------------
CREATE DATABASE Project;
GO
PRINT 'Database Project đã được tạo mới!';
GO

USE Project;
GO

-- -----------------------------------------------------
-- Table: Supplier (Nhà cung cấp)
-- -----------------------------------------------------
PRINT 'Đang tạo bảng Supplier...';
GO

CREATE TABLE Supplier (
    Supplier_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    address NVARCHAR(255),
    phone VARCHAR(20),
    email NVARCHAR(255)
);
GO

INSERT INTO Supplier (name, address, phone, email)
VALUES
(N'Công ty Dược Trung Ương', N'Hà Nội', '0123456789', 'contact@duoc1.vn'),
(N'Công ty Dược Mekophar', N'TP. Hồ Chí Minh', '0987654321', 'info@mekophar.vn'),
(N'Công ty Dược Traphaco', N'Hà Nội', '0909123456', 'support@traphaco.com');
GO

PRINT 'Bảng Supplier đã được tạo với 3 nhà cung cấp.';
GO

-- -----------------------------------------------------
-- Table: Medicine (Thuốc)
-- -----------------------------------------------------
PRINT 'Đang tạo bảng Medicine...';
GO

CREATE TABLE Medicine (
    Medicine_id INT IDENTITY(1,1) PRIMARY KEY,
    Supplier_id INT NULL,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    category NVARCHAR(100),
    expiry_date DATE,
    image_path NVARCHAR(255),
    sale_price DECIMAL(10, 2) NULL,
    FOREIGN KEY (Supplier_id) REFERENCES Supplier(Supplier_id)
);
GO

INSERT INTO Medicine (Supplier_id, name, description, price, quantity, category, expiry_date, image_path, sale_price)
VALUES 
-- Giảm Đau - Hạ Sốt
(1, N'Paracetamol 500mg', N'Thuốc giảm đau, hạ sốt thông thường', 2500.00, 500, N'Giảm Đau - Hạ Sốt', '2026-05-20', 'Paracetamol 650.jpg', NULL),

-- Kháng Sinh
(1, N'Amoxicillin 500mg', N'Kháng sinh phổ rộng nhóm penicillin', 4800.00, 300, N'Kháng Sinh', '2025-12-10', 'Amoxicillin 250.jpg', NULL),
(3, N'Cefuroxime 250mg', N'Kháng sinh cephalosporin thế hệ 2', 4500.00, 150, N'Kháng Sinh', '2025-11-25', '6.tv_cefuroxime_500mg.png', 3375.00),
(3, N'Azithromycin 500mg', N'Kháng sinh nhóm macrolide điều trị nhiễm khuẩn đường hô hấp', 6500.00, 200, N'Kháng Sinh', '2026-08-15', 'Azithromycin 500.jpg', NULL),

-- Sinh Tố - Khoáng Chất
(2, N'Vitamin C 1000mg', N'Tăng cường sức đề kháng, bổ sung vitamin C', 3500.00, 400, N'Sinh Tố - Khoáng Chất', '2027-03-01', 'Vitamin C 1000.jpg', 2625.00),
(2, N'Vitamin D3 500IU', N'Bổ sung vitamin D3, tốt cho xương và răng', 5200.00, 300, N'Sinh Tố - Khoáng Chất', '2027-06-20', 'Vitamin D3 500.jpg', NULL),

-- Tiêu Hóa
(2, N'Loperamide 2mg', N'Điều trị tiêu chảy cấp và mãn tính', 2700.00, 200, N'Tiêu Hóa', '2026-07-15', 'loperamide-1.jpg', NULL),

-- Dị Ứng
(3, N'Loratadine 10mg', N'Thuốc kháng histamin, giảm dị ứng', 4100.00, 250, N'Dị Ứng', '2027-02-14', 'Loratadine 10.jpg', 3075.00),
(3, N'Loratadine 5mg', N'Thuốc kháng histamin dạng siro cho trẻ em', 3800.00, 180, N'Dị Ứng', '2027-01-10', 'Loratadine 5.jpg', NULL),
(3, N'Cefalexin 250mg', N'Kháng sinh cephalosporin điều trị nhiễm khuẩn da', 4200.00, 220, N'Kháng Sinh', '2026-03-25', 'Cefalexin 250.jpg', NULL),

-- Kháng Viêm
(1, N'Diclofenac 75mg', N'Thuốc kháng viêm giảm đau', 3500.00, 280, N'Kháng Viêm', '2026-09-10', 'Diclofenac 75.jpg', NULL),

-- Tiểu Đường
(2, N'Metformin 850mg', N'Thuốc điều trị đái tháo đường type 2', 5500.00, 350, N'Tiểu Đường', '2026-11-30', 'Metformin 850.jpg', NULL),

-- Chăm Sóc Cá Nhân  
(1, N'Ranitidine 300mg', N'Thuốc điều trị viêm loét dạ dày', 4400.00, 190, N'Tiêu Hóa', '2026-04-18', 'Ranitidine 300.jpg', NULL);
GO

PRINT 'Bảng Medicine đã được tạo với 13 loại thuốc.';
GO

-- -----------------------------------------------------
-- Table: User (Người dùng: Admin & Customer)
-- -----------------------------------------------------
PRINT 'Đang tạo bảng User...';
GO

CREATE TABLE [User] (
    User_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    email NVARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    role NVARCHAR(50) NOT NULL CHECK (role IN ('Admin', 'Customer')) DEFAULT 'Customer',
    is_verified BIT DEFAULT 0,
    profile_image NVARCHAR(500),
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- Thêm tài khoản Admin (đã verified)
INSERT INTO [User] (name, email, phone, password, role, is_verified)
VALUES (N'Admin System', 'admin@email.com', '0123456789', 'admin123', 'Admin', 1);
GO

-- Thêm khách hàng mẫu (đã verified)
INSERT INTO [User] (name, email, phone, password, role, is_verified)
VALUES 
(N'Nguyễn Văn A', 'nguyenvana@email.com', '0123456789', '123456', 'Customer', 1),
(N'Trần Thị B', 'tranthib@email.com', '0987654321', '123456', 'Customer', 1),
(N'Lê Văn C', 'levanc@email.com', '0912345678', '123456', 'Customer', 1);
GO

PRINT 'Bảng User đã được tạo với 1 Admin và 3 Customer.';
GO

-- -----------------------------------------------------
-- Table: [Order] (Đơn hàng)
-- -----------------------------------------------------
PRINT 'Đang tạo bảng Order...';
GO

CREATE TABLE [Order] (
    Order_id INT IDENTITY(1,1) PRIMARY KEY,
    User_id INT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT GETDATE(),
    total_amount DECIMAL(10, 2) NOT NULL,
    status NVARCHAR(50) NOT NULL DEFAULT N'Chờ xử lý',
    shipping_address NVARCHAR(500),
    FOREIGN KEY (User_id) REFERENCES [User](User_id)
);
GO

PRINT 'Bảng Order đã được tạo.';
GO

-- -----------------------------------------------------
-- Table: OrderDetail (Chi tiết đơn hàng)
-- -----------------------------------------------------
PRINT 'Đang tạo bảng OrderDetail...';
GO

CREATE TABLE OrderDetail (
    OrderDetail_id INT IDENTITY(1,1) PRIMARY KEY,
    Order_id INT NOT NULL,
    Medicine_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (Order_id) REFERENCES [Order](Order_id) ON DELETE CASCADE,
    FOREIGN KEY (Medicine_id) REFERENCES Medicine(Medicine_id)
);
GO

PRINT 'Bảng OrderDetail đã được tạo.';
GO

-- -----------------------------------------------------
-- Table: VerificationToken (Xác thực Email & Reset Password)
-- -----------------------------------------------------
PRINT 'Đang tạo bảng VerificationToken...';
GO

CREATE TABLE VerificationToken (
    Token_id INT IDENTITY(1,1) PRIMARY KEY,
    User_id INT NOT NULL,
    token VARCHAR(100) NOT NULL UNIQUE,
    token_type NVARCHAR(50) NOT NULL CHECK (token_type IN ('EMAIL_VERIFICATION', 'PASSWORD_RESET')),
    expiry_date DATETIME NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    used BIT DEFAULT 0,
    FOREIGN KEY (User_id) REFERENCES [User](User_id)
);
GO

PRINT 'Bảng VerificationToken đã được tạo.';
GO

-- -----------------------------------------------------
-- Table: Review (Đánh giá thuốc)
-- -----------------------------------------------------
PRINT 'Đang tạo bảng Review...';
GO

CREATE TABLE Review (
    Review_id INT IDENTITY(1,1) PRIMARY KEY,
    Medicine_id INT NOT NULL,
    User_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (Medicine_id) REFERENCES Medicine(Medicine_id),
    FOREIGN KEY (User_id) REFERENCES [User](User_id)
);
GO

-- Thêm một số review mẫu
INSERT INTO Review (Medicine_id, User_id, rating, comment, created_at)
VALUES
-- Reviews cho Paracetamol (Medicine_id = 1)
(1, 2, 5, N'Thuốc rất hiệu quả, hạ sốt nhanh cho cả gia đình', DATEADD(day, -5, GETDATE())),
(1, 3, 4, N'Giá tốt, chất lượng ổn định', DATEADD(day, -3, GETDATE())),

-- Reviews cho Amoxicillin (Medicine_id = 2)
(2, 2, 5, N'Kháng sinh tốt, điều trị nhiễm khuẩn hiệu quả', DATEADD(day, -7, GETDATE())),
(2, 3, 4, N'Dùng theo chỉ định bác sĩ, không bị tác dụng phụ', DATEADD(day, -4, GETDATE())),

-- Reviews cho Cefuroxime (Medicine_id = 3)
(3, 2, 4, N'Thuốc tốt nhưng hơi đắt', DATEADD(day, -6, GETDATE())),

-- Reviews cho Azithromycin (Medicine_id = 4)
(4, 3, 5, N'Điều trị viêm họng rất tốt', DATEADD(day, -2, GETDATE())),

-- Reviews cho Vitamin C (Medicine_id = 5)
(5, 2, 5, N'Tăng sức đề kháng hiệu quả, cả nhà đều dùng', DATEADD(day, -10, GETDATE())),
(5, 3, 4, N'Bổ sung vitamin C hàng ngày, giá hợp lý', DATEADD(day, -8, GETDATE())),

-- Reviews cho Vitamin D3 (Medicine_id = 6)
(6, 2, 4, N'Bổ sung vitamin D tốt cho xương', DATEADD(day, -9, GETDATE())),

-- Reviews cho Loperamide (Medicine_id = 7)
(7, 3, 5, N'Chữa tiêu chảy rất nhanh', DATEADD(day, -1, GETDATE())),

-- Reviews cho Loratadine (Medicine_id = 8)
(8, 2, 4, N'Thuốc dị ứng hiệu quả, không gây buồn ngủ nhiều', DATEADD(day, -12, GETDATE())),

-- Reviews cho Loratadine 5mg (Medicine_id = 9)
(9, 3, 4, N'Liều dành cho trẻ em an toàn', DATEADD(day, -11, GETDATE())),

-- Reviews cho Cefalexin (Medicine_id = 10)
(10, 2, 4, N'Kháng sinh tốt cho nhiễm khuẩn da', DATEADD(day, -15, GETDATE())),

-- Reviews cho Diclofenac (Medicine_id = 11)
(11, 3, 5, N'Giảm đau khớp rất hiệu quả', DATEADD(day, -14, GETDATE())),

-- Reviews cho Metformin (Medicine_id = 12)
(12, 2, 4, N'Kiểm soát đường huyết tốt', DATEADD(day, -13, GETDATE())),

-- Reviews cho Ranitidine (Medicine_id = 13)
(13, 3, 5, N'Chữa đau dạ dày hiệu quả', DATEADD(day, -16, GETDATE()));
GO

PRINT 'Bảng Review đã được tạo với 15 đánh giá mẫu.';
GO

-- -----------------------------------------------------
-- Table: Cart (Giỏ hàng)
-- -----------------------------------------------------
PRINT 'Đang tạo bảng Cart...';
GO

CREATE TABLE Cart (
    Cart_id INT IDENTITY(1,1) PRIMARY KEY,
    User_id INT NOT NULL,
    Medicine_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    added_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (User_id) REFERENCES [User](User_id) ON DELETE CASCADE,
    FOREIGN KEY (Medicine_id) REFERENCES Medicine(Medicine_id) ON DELETE CASCADE,
    UNIQUE(User_id, Medicine_id) -- Mỗi user chỉ có 1 dòng cho 1 medicine
);
GO

-- Tạo index cho Cart
CREATE INDEX IX_Cart_UserID ON Cart(User_id);
CREATE INDEX IX_Cart_MedicineID ON Cart(Medicine_id);
GO

PRINT 'Bảng Cart đã được tạo.';
GO

-- -----------------------------------------------------
-- Indexes (Chỉ mục để tối ưu hóa truy vấn)
-- -----------------------------------------------------
PRINT 'Đang tạo các chỉ mục...';
GO

CREATE INDEX IX_User_Email ON [User](email);
CREATE INDEX IX_User_Phone ON [User](phone);
CREATE INDEX IX_Medicine_Name ON Medicine(name);
CREATE INDEX IX_Medicine_Category ON Medicine(category);
CREATE INDEX IX_Order_UserID ON [Order](User_id);
CREATE INDEX IX_Order_Date ON [Order](order_date);
CREATE INDEX IX_VerificationToken_Token ON VerificationToken(token);
CREATE INDEX IX_VerificationToken_UserID ON VerificationToken(User_id);
CREATE INDEX IX_Review_MedicineID ON Review(Medicine_id);
CREATE INDEX IX_Review_UserID ON Review(User_id);
CREATE INDEX IX_Review_CreatedAt ON Review(created_at);
GO

PRINT 'Các chỉ mục đã được tạo.';
GO

-- -----------------------------------------------------
-- Kiểm tra kết quả
-- -----------------------------------------------------
PRINT '=================================================';
PRINT 'HOÀN THÀNH! Database đã được tạo thành công!';
PRINT '=================================================';
PRINT '';
PRINT 'Thống kê:';
SELECT 'Supplier' AS [Table], COUNT(*) AS [Records] FROM Supplier
UNION ALL
SELECT 'Medicine', COUNT(*) FROM Medicine
UNION ALL
SELECT 'User', COUNT(*) FROM [User]
UNION ALL
SELECT 'Order', COUNT(*) FROM [Order]
UNION ALL
SELECT 'OrderDetail', COUNT(*) FROM OrderDetail;
GO

PRINT '';
PRINT 'Tài khoản đăng nhập:';
PRINT '- Admin: admin@email.com / admin123';
PRINT '- Customer: nguyenvana@email.com / 123456';
GO
