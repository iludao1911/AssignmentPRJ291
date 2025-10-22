-- -----------------------------------------------------
-- Database: Project
-- -----------------------------------------------------
CREATE DATABASE Project;
GO
USE Project;
GO

-- -----------------------------------------------------
-- Table: Supplier
-- -----------------------------------------------------
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

select * from Supplier
-- -----------------------------------------------------
-- Table: Medicine
-- -----------------------------------------------------
CREATE TABLE Medicine (
    Medicine_id INT IDENTITY(1,1) PRIMARY KEY,
    Supplier_id INT NOT NULL,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    category NVARCHAR(100),
    expiry_date DATE,
    FOREIGN KEY (Supplier_id) REFERENCES Supplier(Supplier_id)
);

ALTER TABLE Medicine
ADD image_path NVARCHAR(255);

GO
-- Giả sử Supplier đã có dữ liệu (Supplier_id = 1, 2, 3)
INSERT INTO Medicine (Supplier_id, name, description, price, quantity, category, expiry_date)
VALUES 
(1, N'Paracetamol 500mg', N'Thuốc giảm đau, hạ sốt thông thường', 2500, 500, N'Giảm đau - Hạ sốt', '2026-05-20'),
(1, N'Amoxicillin 500mg', N'Kháng sinh phổ rộng nhóm penicillin', 4800, 300, N'Kháng sinh', '2025-12-10'),
(2, N'Vitamin C 1000mg', N'Tăng cường sức đề kháng, bổ sung vitamin C', 3500, 400, N'Sinh tố - Khoáng chất', '2027-03-01'),
(2, N'Loperamide 2mg', N'Điều trị tiêu chảy cấp và mãn tính', 2700, 200, N'Tiêu hóa', '2026-07-15'),
(3, N'Cefuroxime 250mg', N'Kháng sinh cephalosporin thế hệ 2', 6200, 150, N'Kháng sinh', '2025-11-25'),
(3, N'Loratadine 10mg', N'Thuốc kháng histamin, giảm dị ứng', 4100, 250, N'Dị ứng', '2027-02-14');
SELECT Medicine_id, name, description, price, quantity, category, expiry_date, image_path 
FROM Medicine;

select * from Medicine

SELECT medicine_id, image_path FROM Medicine;
SELECT medicine_id, name, image_path FROM Medicine;
UPDATE Medicine SET image_path = 'Paracetamol.png' WHERE name = 'Paracetamol 500mg';
UPDATE Medicine SET image_path = 'ricmox-500-mg.jpg' WHERE name = 'Amoxicillin 500mg';
UPDATE Medicine SET image_path = 'vitaminC.jpg' WHERE name = 'Vitamin C 1000mg';
UPDATE Medicine SET image_path = 'loperamid.jpg' WHERE name = 'Loperamide 2mg';
UPDATE Medicine SET image_path = 'Cefuroxime.jpg' WHERE name = 'Cefuroxime 250mg';
UPDATE Medicine SET image_path = 'loratadin.jpg' WHERE name = 'Loratadine 10mg';

-- -----------------------------------------------------
-- Table: Customer
-- -----------------------------------------------------
CREATE TABLE Customer (
    Customer_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    email NVARCHAR(255),
    phone VARCHAR(20)
);
GO
ALTER TABLE Customer
ADD password VARCHAR(255);
GO
INSERT INTO Customer (name, email, phone, password)
VALUES
(N'Lê Văn Khách', 'khachhang01@example.com', '0901112222', 'khach123'),
(N'Phạm Thị Hàng', 'khachhang02@example.com', '0903334444', 'hang456');
GO
select *from customer
-- -----------------------------------------------------
-- Table: Employee
-- -----------------------------------------------------
CREATE TABLE Employee (
    Employee_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name NVARCHAR(255),
    role NVARCHAR(100)
);
GO
-- INSERTs cập nhật: loại bỏ tên cá nhân khỏi full_name
INSERT INTO Employee (username, password, full_name, role)
VALUES 
('admin', '123', NULL, 'Admin');
INSERT INTO Employee (username, password, full_name, role)
VALUES 
('nhanvien', '123', NULL, 'Pharmacist'); -- tên cá nhân đã được loại bỏ
GO
-- -----------------------------------------------------
-- Table: [Order]
-- -----------------------------------------------------
CREATE TABLE [Order] (
    Order_id INT IDENTITY(1,1) PRIMARY KEY,
    Customer_id INT NOT NULL,
    Employee_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status NVARCHAR(50),
    ship_address_id INT,
    FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id),
    FOREIGN KEY (Employee_id) REFERENCES Employee(Employee_id)
);
GO

-- -----------------------------------------------------
-- Table: OrderDetail
-- -----------------------------------------------------
CREATE TABLE OrderDetail (
    Order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    Order_id INT NOT NULL,
    Medicine_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT UQ_Order_Medicine UNIQUE (Order_id, Medicine_id),
    FOREIGN KEY (Order_id) REFERENCES [Order](Order_id),
    FOREIGN KEY (Medicine_id) REFERENCES Medicine(Medicine_id)
);
GO

-- -----------------------------------------------------
-- Table: ChatLog
-- -----------------------------------------------------
CREATE TABLE ChatLog (
    ChatLog_id INT IDENTITY(1,1) PRIMARY KEY,
    Employee_id INT NOT NULL,
    Customer_id INT,
    chat_content NVARCHAR(MAX),
    [timestamp] DATETIME NOT NULL,
    FOREIGN KEY (Employee_id) REFERENCES Employee(Employee_id),
    FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id)
);
GO
