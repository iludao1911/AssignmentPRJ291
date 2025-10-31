# HỆ THỐNG QUẢN LÝ NHÀ THUỐC MS - TÀI LIỆU THUYẾT TRÌNH

## 📋 MỤC LỤC
1. [Tổng quan hệ thống](#tổng-quan-hệ-thống)
2. [Công nghệ sử dụng](#công-nghệ-sử-dụng)
3. [Chức năng người dùng](#chức-năng-người-dùng)
4. [Chức năng quản trị viên](#chức-năng-quản-trị-viên)
5. [Tính năng đặc biệt - AI Chatbot](#tính-năng-đặc-biệt---ai-chatbot)
6. [Kiến trúc hệ thống](#kiến-trúc-hệ-thống)
7. [Bảo mật](#bảo-mật)
8. [Demo Flow](#demo-flow)

---

## 🎯 TỔNG QUAN HỆ THỐNG

**Tên dự án:** Hệ thống Quản lý Nhà Thuốc MS
**Mục đích:** Xây dựng nền tảng thương mại điện tử cho phép người dùng mua thuốc trực tuyến và quản trị viên quản lý toàn bộ hoạt động kinh doanh.

### Đối tượng sử dụng
- **Khách hàng:** Người dùng muốn mua thuốc trực tuyến
- **Quản trị viên:** Nhân viên nhà thuốc quản lý sản phẩm, đơn hàng, người dùng

---

## 💻 CÔNG NGHỆ SỬ DỤNG

### Backend
- **Java Servlet & JSP** - Framework web chính
- **SQL Server** - Hệ quản trị cơ sở dữ liệu
- **Apache Ant** - Build tool
- **JDBC** - Kết nối database

### Frontend
- **HTML5/CSS3** - Giao diện người dùng
- **JavaScript** - Tương tác client-side
- **Font Awesome** - Icons
- **Responsive Design** - Tương thích mobile

### AI Integration
- **OpenRouter API** - AI Gateway
- **Google Gemini 2.5 Flash** - AI Model
- **RESTful API** - Giao tiếp với AI

### Pattern & Architecture
- **DAO Pattern** - Data Access Object
- **MVC Pattern** - Model-View-Controller
- **Session Management** - Quản lý phiên người dùng
- **Event Listeners** - Giám sát lifecycle

---

## 👤 CHỨC NĂNG NGƯỜI DÙNG

### 1. 🔐 Xác thực & Quản lý tài khoản

#### Đăng ký tài khoản
- **Servlet:** `AuthRegisterServlet.java`
- **Chức năng:**
  - Đăng ký tài khoản mới với email, tên, mật khẩu
  - Validation dữ liệu đầu vào
  - Kiểm tra email trùng lặp
  - Mã hóa mật khẩu (nếu có)
- **File:** `register.jsp`

#### Đăng nhập
- **Servlet:** `AuthLoginServlet.java`
- **Chức năng:**
  - Xác thực email và mật khẩu
  - Tạo session cho người dùng
  - Session timeout: 120 phút
  - Phân quyền Admin/User
- **File:** `login.jsp`

#### Đăng xuất
- **Servlet:** `AuthLogoutServlet.java`
- **Chức năng:**
  - Hủy session hiện tại
  - Redirect về trang chủ
  - Clear authentication data

#### Quản lý hồ sơ
- **Servlet:** `ProfileServlet.java`
- **Chức năng:**
  - Xem thông tin cá nhân
  - Cập nhật tên, số điện thoại, địa chỉ
  - Thay đổi mật khẩu
  - Upload avatar (nếu có)
- **File:** `profile.jsp`

---

### 2. 🛒 Mua sắm

#### Trang chủ
- **File:** `home.jsp`
- **Chức năng:**
  - Hiển thị danh sách thuốc
  - Banner quảng cáo
  - Phân loại theo danh mục
  - Search và filter sản phẩm
  - Sắp xếp theo giá, tên

#### Chi tiết sản phẩm
- **Servlet:** `MedicineDetailServlet.java`
- **File:** `medicine-detail.jsp`
- **Chức năng:**
  - Thông tin chi tiết thuốc (tên, giá, mô tả, thành phần)
  - Hình ảnh sản phẩm
  - **Chọn số lượng với quantity selector**
  - Thêm vào giỏ hàng với số lượng tùy chỉnh
  - Đánh giá và review từ khách hàng khác
  - Điểm rating trung bình

#### Giỏ hàng
- **Servlet:** `CartServlet.java`, `CartUpdateServlet.java`
- **File:** `cart-view.jsp`
- **Chức năng:**
  - Xem danh sách sản phẩm trong giỏ
  - **Thay đổi số lượng trực tiếp với quantity selector**
  - Xóa sản phẩm khỏi giỏ
  - Tự động cập nhật tổng tiền
  - Áp dụng mã giảm giá (nếu có)
  - Nút "Tiến hành thanh toán"

**Lưu ý:** Quantity selector có validation:
- Tối thiểu: 1
- Tối đa: Stock available
- Cập nhật real-time qua AJAX

---

### 3. 💳 Thanh toán & Đơn hàng

#### Checkout
- **Servlet:** `CheckoutServlet.java`
- **File:** `check-out.jsp`
- **Chức năng:**
  - Xác nhận thông tin đơn hàng
  - Nhập địa chỉ giao hàng
  - Chọn phương thức thanh toán
  - Xem tổng tiền và chi tiết sản phẩm
  - Tạo đơn hàng với trạng thái "Pending"

#### Xác nhận thanh toán
- **Servlet:** `ConfirmPaymentServlet.java`
- **Chức năng:**
  - Xử lý thanh toán
  - Cập nhật trạng thái đơn hàng: Pending → Paid
  - Gửi email xác nhận (nếu có)
  - Trừ số lượng tồn kho

#### Lịch sử đơn hàng
- **Servlet:** `OrderHistoryServlet.java`
- **File:** `order-history.jsp`
- **Chức năng:**
  - Xem tất cả đơn hàng đã đặt
  - **Filter theo trạng thái:**
    - **Tất cả:** Hiển thị tất cả đơn hàng
    - **Chờ thanh toán (Pending):** Đơn hàng chưa thanh toán
    - **Đã thanh toán (Paid):** Đơn hàng đã thanh toán, chờ giao
    - **Đang giao (Shipping):** Đơn hàng đang được vận chuyển
    - **Hoàn thành (Done):** Đơn hàng đã giao thành công
  - **Tiếp tục thanh toán:** Đối với đơn hàng Pending
  - Xem chi tiết từng đơn hàng
  - Tracking trạng thái vận chuyển

**Quy trình trạng thái đơn hàng:**
```
Pending → Paid → Shipping → Done
   ↑        ↓
   └────────┘ (Tiếp tục thanh toán)
```

---

### 4. 💬 Đánh giá sản phẩm

#### Review thuốc
- **Servlet:** `ReviewServlet.java`
- **Chức năng:**
  - Viết đánh giá cho thuốc đã mua
  - Rating từ 1-5 sao
  - Nội dung nhận xét
  - Chỉ người dùng đã mua mới được review
- **Hiển thị:** Trên trang `medicine-detail.jsp`

---

## 👨‍💼 CHỨC NĂNG QUẢN TRỊ VIÊN

### 1. 📊 Thống kê & Dashboard

#### Trang thống kê
- **Servlet:** `AdminStatisticsServlet.java`
- **File:** `admin-dashboard.jsp` (nếu có)
- **API Endpoints:**

##### `/api/statistics/overview`
```json
{
  "totalUsers": 150,
  "totalOrders": 320,
  "totalRevenue": 45000000,
  "totalMedicines": 89
}
```

##### `/api/statistics/revenue?days=30`
- Doanh thu theo ngày trong N ngày gần nhất
- Chỉ tính đơn hàng: Paid, Shipping, Done
```json
[
  {"date": "2025-01-01", "revenue": 1500000},
  {"date": "2025-01-02", "revenue": 2300000}
]
```

##### `/api/statistics/top-medicines?limit=10`
- Top thuốc bán chạy nhất
```json
[
  {
    "medicineId": 5,
    "name": "Paracetamol 500mg",
    "totalSold": 250
  }
]
```

##### `/api/statistics/orders-by-status`
- Số lượng đơn hàng theo trạng thái
```json
{
  "Pending": 15,
  "Paid": 25,
  "Shipping": 30,
  "Done": 250
}
```

##### `/api/statistics/recent-orders?limit=10`
- Đơn hàng gần nhất
```json
[
  {
    "orderId": 123,
    "userName": "Nguyễn Văn A",
    "totalAmount": 350000,
    "status": "Paid",
    "orderDate": "2025-01-15 14:30:00"
  }
]
```

**Công nghệ:**
- SQL Server syntax: `TOP (?)`, `CAST()`, `DATEADD()`, `GETDATE()`
- Sử dụng `DBConnection.getConnection()` pattern
- REST API trả về JSON

---

### 2. 👥 Quản lý người dùng

#### Danh sách người dùng
- **File:** `admin-users.jsp`
- **DAO:** `UserDAO.java`
- **Chức năng:**
  - Hiển thị tất cả người dùng
  - **Thông tin hiển thị:**
    - ID người dùng
    - Avatar (chữ cái đầu tên)
    - Tên đầy đủ
    - Email
    - Số điện thoại
    - Địa chỉ
    - Vai trò (Admin/Khách hàng)
    - Trạng thái xác thực
  - **Tìm kiếm theo:**
    - Tên
    - Email
    - Số điện thoại
  - **Chức năng quản lý:**
    - Xem chi tiết
    - Chỉnh sửa thông tin
    - Vô hiệu hóa tài khoản
    - Phân quyền Admin

**Giao diện:**
- Table view với badge màu cho vai trò
- Search box real-time
- Responsive design

---

### 3. 💊 Quản lý thuốc

#### CRUD Thuốc
- **Servlet:** `MedicineServlet.java` (dự kiến)
- **File:** `admin-medicines.jsp` (đã đề cập, cần hoàn thiện)
- **Chức năng:**
  - **Thêm thuốc mới:**
    - Tên, mô tả, giá
    - Danh mục (Category)
    - Thành phần hoạt chất
    - Số lượng tồn kho
    - Hình ảnh sản phẩm
    - Hạn sử dụng
  - **Sửa thông tin thuốc**
  - **Xóa thuốc** (soft delete hoặc hard delete)
  - **Quản lý tồn kho:**
    - Cập nhật số lượng
    - Cảnh báo sắp hết hàng
    - Import/Export inventory

---

### 4. 📦 Quản lý đơn hàng

#### Quản lý đơn hàng
- **Servlet:** `AdminOrderServlet.java` (dự kiến)
- **File:** `admin-orders.jsp` (đã đề cập, cần hoàn thiện)
- **Chức năng:**
  - **Xem tất cả đơn hàng**
  - **Filter theo:**
    - Trạng thái (Pending, Paid, Shipping, Done)
    - Ngày đặt hàng
    - Khách hàng
    - Khoảng giá
  - **Cập nhật trạng thái:**
    - Xác nhận thanh toán (Pending → Paid)
    - Bắt đầu giao hàng (Paid → Shipping)
    - Hoàn thành đơn (Shipping → Done)
    - Hủy đơn hàng (nếu có lý do)
  - **Xem chi tiết đơn hàng:**
    - Thông tin khách hàng
    - Danh sách sản phẩm
    - Địa chỉ giao hàng
    - Phương thức thanh toán
    - Lịch sử thay đổi trạng thái
  - **In hóa đơn**
  - **Xuất báo cáo**

---

## 🤖 TÍNH NĂNG ĐẶC BIỆT - AI CHATBOT

### Tổng quan
Hệ thống tích hợp AI Chatbot sử dụng Google Gemini 2.5 Flash qua OpenRouter API để tư vấn thuốc và trả lời câu hỏi của khách hàng.

### Công nghệ
- **AI Provider:** OpenRouter
- **Model:** Google Gemini 2.5 Flash
- **Configuration:** External config file (bảo mật)
- **Integration:** RESTful API

### Cấu hình
**File:** `src/java/resources/config.properties`
```properties
# OpenRouter Configuration
openrouter.api.key=sk-xxx...
openrouter.base.url=https://ai.121628.xyz/v1/chat/completions
openrouter.model=gemini-2.5-flash

# Chatbot Settings
chatbot.max.medicines=10
chatbot.temperature=0.7
chatbot.max.tokens=500
```

**Class:** `ChatbotConfig.java`
- Load cấu hình từ properties file
- Throw exception nếu API key không được config
- Cung cấp methods an toàn để truy xuất config

### Servlet
**File:** `ChatbotServlet.java`

#### Xử lý request
```java
@WebServlet("/chatbot")
public class ChatbotServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        String userMessage = request.getParameter("message");
        String context = buildContext(userMessage);
        String aiResponse = callOpenRouterAPI(userMessage, context);
        // Return JSON response
    }
}
```

#### Context Building
Chatbot có context về:
- Thông tin nhà thuốc MS
- Danh sách thuốc trong database (tối đa 10 sản phẩm)
- Giá và mô tả sản phẩm
- **Format đặc biệt:** `[Tên thuốc](medicine-id)` để tạo link

### Giao diện
**File:** `chatbot-widget.jsp`

#### Thiết kế
- **Vị trí:** Fixed bottom-right corner
- **Style:** Modern gradient UI (Purple theme)
- **Responsive:** Tương thích mobile
- **Animation:** Smooth slide-up, typing indicator

#### Các thành phần
1. **Toggle Button:**
   - Icon: Comments bubble
   - Floating action button
   - Active state indicator

2. **Chat Window:**
   - Header với avatar bot và nút đóng
   - Messages area (scrollable)
   - Input area với send button

3. **Welcome Message:**
   - Lời chào từ bot
   - **Quick question buttons:**
     - "Giới thiệu về nhà thuốc"
     - "Thuốc giảm đau"
     - "Giá thuốc"

4. **Message Bubbles:**
   - Bot messages: Trắng, bên trái
   - User messages: Gradient purple, bên phải
   - Avatar icons
   - Timestamp (nếu có)

5. **Typing Indicator:**
   - 3 dots animation
   - Hiển thị khi bot đang "suy nghĩ"

#### Tính năng
- **Real-time chat:** AJAX không reload trang
- **Link parsing:** Auto-convert `[Medicine](id)` thành clickable link
- **URL detection:** Auto-linkify URLs
- **Keyboard support:** Enter để gửi tin nhắn
- **Input validation:** Không gửi tin nhắn rỗng
- **Error handling:** Hiển thị message khi API lỗi
- **No history storage:** Không lưu lịch sử (tránh AI warning)

#### CSS Highlights
```css
.chatbot-window {
    width: 380px;
    height: 550px;
    border-radius: 20px;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
}

.quick-question-btn {
    background: #f0f2ff;
    border: 1px solid #667eea;
    white-space: nowrap;
}

.quick-question-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
}
```

### Workflow
```
User → Input question → ChatbotServlet
    ↓
Build context from Database
    ↓
Call OpenRouter API (Gemini)
    ↓
Parse response & convert links
    ↓
Return JSON to frontend
    ↓
Display in chat bubble
```

### Ví dụ tương tác
```
User: "Có thuốc giảm đau gì?"

Bot: "Nhà thuốc MS có các loại thuốc giảm đau sau:
1. [Paracetamol 500mg](5) - Giá: 25,000đ
2. [Ibuprofen 400mg](12) - Giá: 35,000đ

Bạn đang bị đau loại nào để tôi tư vấn phù hợp hơn?"
```
→ Khi click vào tên thuốc sẽ mở trang chi tiết sản phẩm

### Bảo mật
- ✅ API key lưu trong config file (không commit)
- ✅ Config file nằm ngoài webroot
- ✅ Validation input để tránh injection
- ✅ Rate limiting (nếu cần thêm)
- ✅ CORS policy

---

## 🏗️ KIẾN TRÚC HỆ THỐNG

### Database Schema

#### Bảng User
```sql
[User] (
    User_id INT PRIMARY KEY,
    name NVARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    phone VARCHAR(20),
    address NVARCHAR(255),
    is_admin BIT,
    is_verified BIT,
    created_at DATETIME
)
```

#### Bảng Medicine
```sql
Medicine (
    Medicine_id INT PRIMARY KEY,
    name NVARCHAR(255),
    description NVARCHAR(MAX),
    price DECIMAL(10,2),
    category_id INT,
    stock INT,
    image VARCHAR(255),
    created_at DATETIME
)
```

#### Bảng Order
```sql
[Order] (
    Order_id INT PRIMARY KEY,
    User_id INT FOREIGN KEY,
    total_amount DECIMAL(10,2),
    status NVARCHAR(20), -- Pending, Paid, Shipping, Done
    order_date DATETIME,
    shipping_address NVARCHAR(255),
    payment_method NVARCHAR(50)
)
```

#### Bảng OrderDetail
```sql
OrderDetail (
    Order_detail_id INT PRIMARY KEY,
    Order_id INT FOREIGN KEY,
    Medicine_id INT FOREIGN KEY,
    quantity INT,
    price DECIMAL(10,2)
)
```

#### Bảng Review
```sql
Review (
    Review_id INT PRIMARY KEY,
    User_id INT FOREIGN KEY,
    Medicine_id INT FOREIGN KEY,
    rating INT, -- 1-5
    comment NVARCHAR(MAX),
    created_at DATETIME
)
```

#### Bảng Cart
```sql
Cart (
    Cart_id INT PRIMARY KEY,
    User_id INT FOREIGN KEY,
    Medicine_id INT FOREIGN KEY,
    quantity INT,
    added_at DATETIME
)
```

### Servlet Mapping
```
/home → HomeServlet
/login → AuthLoginServlet
/register → AuthRegisterServlet
/logout → AuthLogoutServlet
/profile → ProfileServlet
/medicine-detail → MedicineDetailServlet
/cart → CartServlet
/cart-update → CartUpdateServlet
/checkout → CheckoutServlet
/confirm-payment → ConfirmPaymentServlet
/order-history → OrderHistoryServlet
/review → ReviewServlet
/chatbot → ChatbotServlet
/admin/statistics → AdminStatisticsServlet
```

### Event Listeners

#### 1. AppContextListener
**File:** `listener/AppContextListener.java`
- **Lifecycle:** Application start/stop
- **Chức năng:**
  - Track application start time
  - Initialize global counters (visitors, online users)
  - Load configuration
  - Log application events

#### 2. SessionListener
**File:** `listener/SessionListener.java`
- **Lifecycle:** Session created/destroyed
- **Chức năng:**
  - Track current online users
  - Count total visitors
  - Log session creation/destruction
  - Cleanup session resources

#### 3. SessionAttributeListener
**File:** `listener/SessionAttributeListener.java`
- **Lifecycle:** Session attributes added/removed/replaced
- **Chức năng:**
  - Monitor user login/logout
  - Track security events
  - Log attribute changes
  - Audit trail

#### 4. RequestListener
**File:** `listener/RequestListener.java`
- **Lifecycle:** Request received/destroyed
- **Chức năng:**
  - Performance monitoring
  - Slow request detection (>1000ms)
  - Log request URI and method
  - Calculate request duration
  - Filter static resources (CSS, JS, images)

### DAO Pattern

#### UserDAO
- `getAllUsers()` - Lấy tất cả người dùng
- `getUserById(int id)` - Lấy user theo ID
- `getUserByEmail(String email)` - Lấy user theo email
- `createUser(User user)` - Tạo user mới
- `updateUser(User user)` - Cập nhật user
- `deleteUser(int id)` - Xóa user

#### MedicineDAO
- `getAllMedicines()` - Lấy tất cả thuốc
- `getMedicineById(int id)` - Lấy thuốc theo ID
- `searchMedicines(String keyword)` - Tìm kiếm thuốc
- `getMedicinesByCategory(int categoryId)` - Lọc theo danh mục
- `createMedicine(Medicine medicine)` - Thêm thuốc mới
- `updateMedicine(Medicine medicine)` - Cập nhật thuốc
- `updateStock(int medicineId, int quantity)` - Cập nhật tồn kho

#### OrderDAO
- `getAllOrders()` - Lấy tất cả đơn hàng
- `getOrdersByUser(int userId)` - Lấy đơn hàng của user
- `getOrderById(int orderId)` - Lấy đơn hàng theo ID
- `createOrder(Order order)` - Tạo đơn hàng mới
- `updateOrderStatus(int orderId, String status)` - Cập nhật trạng thái
- `getOrderDetails(int orderId)` - Lấy chi tiết đơn hàng

#### CartDAO
- `getCartByUser(int userId)` - Lấy giỏ hàng của user
- `addToCart(int userId, int medicineId, int quantity)` - Thêm vào giỏ
- `updateCartQuantity(int cartId, int quantity)` - Cập nhật số lượng
- `removeFromCart(int cartId)` - Xóa khỏi giỏ
- `clearCart(int userId)` - Xóa toàn bộ giỏ hàng

---

## 🔒 BẢO MẬT

### Authentication & Authorization
- **Session-based authentication:** Sử dụng HttpSession
- **Session timeout:** 120 phút
- **Role-based access control:** Admin vs User
- **Protected routes:** Check login trước khi truy cập

### Password Security
- Mã hóa password (khuyến nghị: BCrypt, SHA-256)
- Không lưu plain text password
- Password reset qua email (nếu có)

### SQL Injection Prevention
- **Prepared Statements:** Sử dụng `PreparedStatement` thay vì `Statement`
- **Input validation:** Validate tất cả input từ user
- **Parameterized queries**

### XSS Prevention
- **Output encoding:** Escape HTML trong JSP
- **Content Security Policy**
- **Input sanitization**

### Configuration Security
- **API key:** Lưu trong config file ngoài source code
- **Environment variables:** Sử dụng cho sensitive data
- **Git ignore:** `.gitignore` chứa `config.properties`
- **Example file:** `config.properties.example` cho setup

### HTTPS
- Sử dụng HTTPS cho production
- Secure cookie flags
- HSTS headers

---

## 🎬 DEMO FLOW

### Flow 1: Khách hàng mua hàng
```
1. Truy cập trang chủ (home.jsp)
2. Duyệt danh sách thuốc
3. Nhấn vào thuốc muốn mua
4. Xem chi tiết sản phẩm
5. Chọn số lượng (quantity selector)
6. Thêm vào giỏ hàng
7. Xem giỏ hàng (cart-view.jsp)
8. Điều chỉnh số lượng nếu cần
9. Nhấn "Thanh toán"
10. Điền thông tin giao hàng (check-out.jsp)
11. Xác nhận thanh toán
12. Đơn hàng được tạo với status "Pending"
13. Xác nhận thanh toán → Status "Paid"
14. Xem lịch sử đơn hàng (order-history.jsp)
```

### Flow 2: Sử dụng AI Chatbot
```
1. Click vào nút chatbot (góc dưới phải)
2. Cửa sổ chat hiện lên với lời chào
3. Nhấn quick question hoặc nhập câu hỏi
4. Bot hiển thị typing indicator
5. Bot trả lời với link đến sản phẩm
6. Click vào link thuốc
7. Mở trang chi tiết sản phẩm
8. Tiếp tục mua hàng
```

### Flow 3: Admin quản lý
```
1. Login với tài khoản Admin
2. Truy cập trang thống kê (/admin/statistics)
3. Xem overview: users, orders, revenue
4. Xem biểu đồ doanh thu 30 ngày
5. Xem top 10 thuốc bán chạy
6. Truy cập quản lý người dùng (admin-users.jsp)
7. Tìm kiếm user theo tên/email
8. Xem thông tin chi tiết, chỉnh sửa
9. Truy cập quản lý đơn hàng
10. Filter đơn hàng theo status
11. Cập nhật status: Paid → Shipping → Done
12. In hóa đơn hoặc xuất báo cáo
```

### Flow 4: Tiếp tục thanh toán đơn Pending
```
1. Truy cập Lịch sử đơn hàng
2. Nhấn tab "Chờ thanh toán"
3. Tìm đơn hàng Pending
4. Nhấn nút "Tiếp tục thanh toán"
5. Redirect về trang checkout
6. Thông tin đơn hàng được load
7. Xác nhận và thanh toán
8. Status chuyển thành "Paid"
```

---

## 📊 ĐIỂM NỔI BẬT

### 1. Quantity Selector
- Tích hợp ở cả trang chi tiết và giỏ hàng
- Validation real-time
- Cập nhật tổng tiền tự động
- UX tốt, dễ sử dụng

### 2. Order Status Management
- Quy trình rõ ràng: Pending → Paid → Shipping → Done
- Cho phép tiếp tục thanh toán đơn Pending
- Filter đơn hàng theo trạng thái
- Tab navigation trực quan

### 3. AI Chatbot Integration
- Sử dụng AI tiên tiến (Gemini 2.5 Flash)
- Context-aware: Biết sản phẩm trong database
- Smart linking: Tự động tạo link đến sản phẩm
- Modern UI với animation
- Bảo mật: API key external config

### 4. Admin Statistics
- API RESTful trả về JSON
- Nhiều endpoint cho dashboard
- SQL Server optimized queries
- Real-time data

### 5. Session Management
- Session timeout 120 phút
- Event listeners monitoring
- Performance tracking
- Security logging

### 6. Responsive Design
- Mobile-friendly
- Chatbot responsive
- Table overflow handling
- Touch-friendly buttons

---

## 🚀 HƯỚNG PHÁT TRIỂN

### Tính năng có thể mở rộng
1. **Payment Gateway:** Tích hợp VNPay, MoMo, ZaloPay
2. **Email Notification:** Gửi email xác nhận đơn hàng
3. **SMS Notification:** Thông báo qua SMS
4. **Advanced Search:** Full-text search, filters
5. **Recommendation System:** Gợi ý thuốc dựa trên lịch sử
6. **Loyalty Program:** Điểm tích lũy, voucher
7. **Multi-language:** Hỗ trợ tiếng Anh
8. **Export Reports:** Excel, PDF reports
9. **Image Upload:** Cho thuốc và avatar
10. **Real-time Chat:** WebSocket cho chatbot

### Cải thiện bảo mật
1. **Two-factor Authentication (2FA)**
2. **CAPTCHA:** Chống bot
3. **Rate Limiting:** Chống DDoS
4. **Audit Logs:** Chi tiết hơn
5. **Encryption:** Mã hóa dữ liệu nhạy cảm

---

## 📝 KẾT LUẬN

Hệ thống Quản lý Nhà Thuốc MS là một ứng dụng web hoàn chỉnh với đầy đủ chức năng:
- ✅ Quản lý người dùng và phân quyền
- ✅ Mua sắm trực tuyến với giỏ hàng và thanh toán
- ✅ Quản lý đơn hàng với workflow rõ ràng
- ✅ Thống kê và báo cáo cho admin
- ✅ AI Chatbot tư vấn thông minh
- ✅ Bảo mật và performance tốt
- ✅ Responsive và user-friendly

Dự án áp dụng các pattern và best practices trong phát triển web Java, đảm bảo code maintainable và scalable.

---

**Người thực hiện:** [Tên của bạn]
**Ngày hoàn thành:** [Ngày tháng năm]
**Công nghệ:** Java Servlet/JSP, SQL Server, AI Integration
**Liên hệ:** [Email/Phone]
