-- =====================================================
-- Script: Xóa và Tạo lại Database Project
-- Mục đích: Quản lý Nhà Thuốc MS
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
(1, N'Paracetamol 500mg', N'Thuốc giảm đau, hạ sốt thông thường', 2500.00, 500, N'Giảm đau - Hạ sốt', '2026-05-20', 'Paracetamol.png', NULL),
(1, N'Amoxicillin 500mg', N'Kháng sinh phổ rộng nhóm penicillin', 4800.00, 300, N'Kháng sinh', '2025-12-10', 'ricmox-500-mg.jpg', 4000.00),
(2, N'Vitamin C 1000mg', N'Tăng cường sức đề kháng, bổ sung vitamin C', 3500.00, 400, N'Sinh tố - Khoáng chất', '2027-03-01', 'vitaminC.jpg', NULL),
(2, N'Loperamide 2mg', N'Điều trị tiêu chảy cấp và mãn tính', 2700.00, 200, N'Tiêu hóa', '2026-07-15', 'loperamid.jpg', NULL),
(3, N'Cefuroxime 250mg', N'Kháng sinh cephalosporin thế hệ 2', 6200.00, 150, N'Kháng sinh', '2025-11-25', 'Cefuroxime.jpg', 5500.00),
(3, N'Loratadine 10mg', N'Thuốc kháng histamin, giảm dị ứng', 4100.00, 250, N'Dị ứng', '2027-02-14', 'loratadin.jpg', NULL);
GO

PRINT 'Bảng Medicine đã được tạo với 6 loại thuốc.';
GO

-- -----------------------------------------------------
-- Table: Customer (Khách hàng & Admin)
-- -----------------------------------------------------
PRINT 'Đang tạo bảng Customer...';
GO

CREATE TABLE Customer (
    Customer_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    email NVARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    role NVARCHAR(50) NOT NULL CHECK (role IN ('Admin', 'Customer')) DEFAULT 'Customer',
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- Thêm tài khoản Admin
INSERT INTO Customer (name, email, phone, password, role)
VALUES (N'Admin System', 'admin@email.com', '0123456789', 'admin123', 'Admin');
GO

-- Thêm khách hàng mẫu
INSERT INTO Customer (name, email, phone, password, role)
VALUES 
(N'Nguyễn Văn A', 'nguyenvana@email.com', '0123456789', '123456', 'Customer'),
(N'Trần Thị B', 'tranthib@email.com', '0987654321', '123456', 'Customer'),
(N'Lê Văn C', 'levanc@email.com', '0912345678', '123456', 'Customer');
GO

PRINT 'Bảng Customer đã được tạo với 1 Admin và 3 Customer.';
GO

-- -----------------------------------------------------
-- Table: [Order] (Đơn hàng)
-- -----------------------------------------------------
PRINT 'Đang tạo bảng Order...';
GO

CREATE TABLE [Order] (
    Order_id INT IDENTITY(1,1) PRIMARY KEY,
    Customer_id INT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT GETDATE(),
    total_amount DECIMAL(10, 2) NOT NULL,
    status NVARCHAR(50) NOT NULL DEFAULT N'Chờ xử lý',
    shipping_address NVARCHAR(500),
    FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id)
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
-- Table: ResetPassword (Reset mật khẩu)
-- -----------------------------------------------------
PRINT 'Đang tạo bảng ResetPassword...';
GO

CREATE TABLE ResetPassword (
    Reset_id INT IDENTITY(1,1) PRIMARY KEY,
    Customer_id INT NOT NULL,
    reset_token VARCHAR(100) NOT NULL UNIQUE,
    expiry_date DATETIME NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    used BIT DEFAULT 0,
    FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id)
);
GO

PRINT 'Bảng ResetPassword đã được tạo.';
GO

-- -----------------------------------------------------
-- Indexes (Chỉ mục để tối ưu hóa truy vấn)
-- -----------------------------------------------------
PRINT 'Đang tạo các chỉ mục...';
GO

CREATE INDEX IX_Customer_Email ON Customer(email);
CREATE INDEX IX_Customer_Phone ON Customer(phone);
CREATE INDEX IX_Medicine_Name ON Medicine(name);
CREATE INDEX IX_Medicine_Category ON Medicine(category);
CREATE INDEX IX_Order_CustomerID ON [Order](Customer_id);
CREATE INDEX IX_Order_Date ON [Order](order_date);
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
SELECT 'Customer', COUNT(*) FROM Customer
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
