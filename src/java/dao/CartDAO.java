package dao;

import model.Cart;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class để xử lý các thao tác với bảng Cart
 */
public class CartDAO {
    
    // SQL QUERIES
    private static final String SELECT_BY_USER = 
        "SELECT c.*, m.name as medicine_name, m.image_path as medicine_image, " +
        "m.price as medicine_price, m.sale_price as medicine_sale_price " +
        "FROM Cart c " +
        "INNER JOIN Medicine m ON c.Medicine_id = m.Medicine_id " +
        "WHERE c.User_id = ? " +
        "ORDER BY c.added_at DESC";
    
    private static final String INSERT_CART = 
        "INSERT INTO Cart (User_id, Medicine_id, quantity) VALUES (?, ?, ?)";
    
    private static final String UPDATE_QUANTITY = 
        "UPDATE Cart SET quantity = ? WHERE User_id = ? AND Medicine_id = ?";
    
    private static final String DELETE_ITEM = 
        "DELETE FROM Cart WHERE User_id = ? AND Medicine_id = ?";
    
    private static final String CLEAR_CART = 
        "DELETE FROM Cart WHERE User_id = ?";
    
    private static final String CHECK_EXISTS = 
        "SELECT quantity FROM Cart WHERE User_id = ? AND Medicine_id = ?";
    
    private static final String GET_CART_COUNT = 
        "SELECT COUNT(*) as count FROM Cart WHERE User_id = ?";

    /**
     * Extract Cart object from ResultSet
     */
    private Cart extractCartFromResultSet(ResultSet rs) throws SQLException {
        Cart cart = new Cart();
        cart.setCartId(rs.getInt("Cart_id"));
        cart.setUserId(rs.getInt("User_id"));
        cart.setMedicineId(rs.getInt("Medicine_id"));
        cart.setQuantity(rs.getInt("quantity"));
        cart.setAddedAt(rs.getTimestamp("added_at"));
        
        // Medicine info
        cart.setMedicineName(rs.getString("medicine_name"));
        cart.setMedicineImage(rs.getString("medicine_image"));
        cart.setMedicinePrice(rs.getBigDecimal("medicine_price").doubleValue());
        
        java.math.BigDecimal salePrice = rs.getBigDecimal("medicine_sale_price");
        if (salePrice != null) {
            cart.setMedicineSalePrice(salePrice.doubleValue());
        }
        
        return cart;
    }

    /**
     * Lấy tất cả items trong cart của user
     */
    public List<Cart> getCartByUserId(int userId) throws SQLException {
        List<Cart> cartItems = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_USER)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    cartItems.add(extractCartFromResultSet(rs));
                }
            }
        }
        
        return cartItems;
    }

    /**
     * Thêm item vào cart (hoặc tăng quantity nếu đã tồn tại)
     */
    public boolean addToCart(int userId, int medicineId, int quantity) throws SQLException {
        // Kiểm tra xem item đã tồn tại chưa
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psCheck = conn.prepareStatement(CHECK_EXISTS)) {
            
            psCheck.setInt(1, userId);
            psCheck.setInt(2, medicineId);
            
            try (ResultSet rs = psCheck.executeQuery()) {
                if (rs.next()) {
                    // Đã tồn tại -> tăng quantity
                    int currentQty = rs.getInt("quantity");
                    return updateQuantity(userId, medicineId, currentQty + quantity);
                }
            }
        }
        
        // Chưa tồn tại -> insert mới
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_CART)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, medicineId);
            ps.setInt(3, quantity);
            
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật quantity của item
     */
    public boolean updateQuantity(int userId, int medicineId, int quantity) throws SQLException {
        if (quantity <= 0) {
            return removeFromCart(userId, medicineId);
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_QUANTITY)) {
            
            ps.setInt(1, quantity);
            ps.setInt(2, userId);
            ps.setInt(3, medicineId);
            
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Xóa item khỏi cart
     */
    public boolean removeFromCart(int userId, int medicineId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_ITEM)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, medicineId);
            
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Xóa toàn bộ cart của user
     */
    public boolean clearCart(int userId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(CLEAR_CART)) {
            
            ps.setInt(1, userId);
            
            return ps.executeUpdate() >= 0;
        }
    }

    /**
     * Đếm số items trong cart
     */
    public int getCartCount(int userId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_CART_COUNT)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        }
        
        return 0;
    }

    /**
     * Cập nhật số lượng sản phẩm theo userId và medicineId
     */
    public boolean updateQuantityByUserAndMedicine(int userId, int medicineId, int quantity) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_QUANTITY)) {
            
            ps.setInt(1, quantity);
            ps.setInt(2, userId);
            ps.setInt(3, medicineId);
            
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Xóa sản phẩm theo userId và medicineId
     */
    public boolean removeItemByUserAndMedicine(int userId, int medicineId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_ITEM)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, medicineId);
            
            return ps.executeUpdate() > 0;
        }
    }
}
