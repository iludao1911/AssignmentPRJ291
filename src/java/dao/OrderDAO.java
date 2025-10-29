package dao;

import model.Order;
import model.Cart;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class để xử lý các thao tác với bảng Order và OrderDetail
 */
public class OrderDAO {
    
    // SQL QUERIES
    private static final String INSERT_ORDER = 
        "INSERT INTO [Order] (User_id, total_amount, status, shipping_address) " +
        "VALUES (?, ?, ?, ?)";
    
    private static final String INSERT_ORDER_DETAIL = 
        "INSERT INTO OrderDetail (Order_id, Medicine_id, quantity, unit_price, subtotal) " +
        "VALUES (?, ?, ?, ?, ?)";
    
    private static final String UPDATE_ORDER_STATUS = 
        "UPDATE [Order] SET status = ?, shipping_address = ? WHERE Order_id = ?";
    
    private static final String SELECT_ORDER_BY_ID = 
        "SELECT o.*, u.name as user_name, u.email as user_email " +
        "FROM [Order] o " +
        "INNER JOIN [User] u ON o.User_id = u.User_id " +
        "WHERE o.Order_id = ?";
    
    private static final String SELECT_ORDERS_BY_USER = 
        "SELECT o.*, u.name as user_name, u.email as user_email " +
        "FROM [Order] o " +
        "INNER JOIN [User] u ON o.User_id = u.User_id " +
        "WHERE o.User_id = ? " +
        "ORDER BY o.order_date DESC";
    
    /**
     * Tạo Order mới kèm OrderDetail từ Cart
     * Transaction: Tạo Order -> Tạo OrderDetail -> Return Order_id
     */
    public int createOrderWithDetails(Order order, List<Cart> cartItems) throws SQLException {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // 1. Insert Order
            psOrder = conn.prepareStatement(INSERT_ORDER, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, order.getUserId());
            psOrder.setDouble(2, order.getTotalAmount());
            psOrder.setString(3, order.getStatus());
            psOrder.setString(4, order.getShippingAddress());
            
            int affectedRows = psOrder.executeUpdate();
            
            if (affectedRows == 0) {
                conn.rollback();
                return 0;
            }
            
            // Get generated Order_id
            rs = psOrder.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }
            
            if (orderId == 0) {
                conn.rollback();
                return 0;
            }
            
            // 2. Insert OrderDetails
            psDetail = conn.prepareStatement(INSERT_ORDER_DETAIL);
            
            for (Cart item : cartItems) {
                double unitPrice = item.getEffectivePrice();
                double subtotal = unitPrice * item.getQuantity();
                
                psDetail.setInt(1, orderId);
                psDetail.setInt(2, item.getMedicineId());
                psDetail.setInt(3, item.getQuantity());
                psDetail.setDouble(4, unitPrice);
                psDetail.setDouble(5, subtotal);
                
                psDetail.addBatch();
            }
            
            psDetail.executeBatch();
            
            conn.commit(); // Commit transaction
            return orderId;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (psOrder != null) psOrder.close();
            if (psDetail != null) psDetail.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }
    
    /**
     * Cập nhật trạng thái Order
     */
    public boolean updateOrderStatus(int orderId, String status, String shippingAddress) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_ORDER_STATUS)) {
            
            ps.setString(1, status);
            ps.setString(2, shippingAddress);
            ps.setInt(3, orderId);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Lấy Order theo ID
     */
    public Order getOrderById(int orderId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ORDER_BY_ID)) {
            
            ps.setInt(1, orderId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractOrderFromResultSet(rs);
                }
            }
        }
        
        return null;
    }
    
    /**
     * Lấy danh sách Order của user
     */
    public List<Order> getOrdersByUserId(int userId) throws SQLException {
        List<Order> orders = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ORDERS_BY_USER)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(extractOrderFromResultSet(rs));
                }
            }
        }
        
        return orders;
    }
    
    /**
     * Lấy danh sách Order theo status
     */
    public List<Order> getOrdersByUserIdAndStatus(int userId, String... statuses) throws SQLException {
        List<Order> orders = new ArrayList<>();
        
        if (statuses == null || statuses.length == 0) {
            return orders;
        }
        
        StringBuilder sql = new StringBuilder(
            "SELECT o.*, u.name as user_name, u.email as user_email " +
            "FROM [Order] o " +
            "INNER JOIN [User] u ON o.User_id = u.User_id " +
            "WHERE o.User_id = ? AND o.status IN ("
        );
        
        for (int i = 0; i < statuses.length; i++) {
            sql.append("?");
            if (i < statuses.length - 1) {
                sql.append(", ");
            }
        }
        
        sql.append(") ORDER BY o.order_date DESC");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            ps.setInt(1, userId);
            for (int i = 0; i < statuses.length; i++) {
                ps.setString(i + 2, statuses[i]);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(extractOrderFromResultSet(rs));
                }
            }
        }
        
        return orders;
    }
    
    /**
     * Cập nhật chỉ status của Order
     */
    public boolean updateOrderStatusOnly(int orderId, String status) throws SQLException {
        String sql = "UPDATE [Order] SET status = ? WHERE Order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, orderId);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Extract Order object from ResultSet
     */
    private Order extractOrderFromResultSet(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("Order_id"));
        order.setUserId(rs.getInt("User_id"));
        order.setOrderDate(rs.getTimestamp("order_date"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setUserName(rs.getString("user_name"));
        order.setUserEmail(rs.getString("user_email"));
        
        return order;
    }
}
