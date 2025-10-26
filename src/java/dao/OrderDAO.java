/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.List;
import model.*;
import dao.DBConnection;
import java.util.ArrayList;

public class OrderDAO {
    public int createOrder(Order order) throws SQLException {
        String sql = "INSERT INTO Orders (customer_id, total_amount) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, order.getCustomerId());
            stmt.setBigDecimal(2, order.getTotalAmount());
            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        }
        return -1;
    }

    public void addOrderDetails(int orderId, List<CartItem> cartItems) throws SQLException {
        String sql = "INSERT INTO OrderDetails (order_id, medicine_id, quantity, price) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            for (CartItem item : cartItems) {
                stmt.setInt(1, orderId);
                stmt.setInt(2, item.getMedicine().getMedicineId());
                stmt.setInt(3, item.getQuantity());
                stmt.setBigDecimal(4, item.getMedicine().getPrice());
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }
    public List<Order> getOrdersByCustomerId(int customerId) {
    List<Order> list = new ArrayList<>();
    String sql = "SELECT * FROM [Order] WHERE customerId = ? ORDER BY orderDate DESC";
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, customerId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
        Order o = new Order();
        o.setOrderId(rs.getInt("orderId"));
        o.setCustomerId(rs.getInt("customerId"));
        o.setOrderDate(rs.getTimestamp("orderDate"));
        o.setTotalAmount(rs.getBigDecimal("total"));
        o.setPaymentMethod(rs.getString("paymentMethod"));
        o.setAddress(rs.getString("address"));
        list.add(o);
}

    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
    public boolean deleteOrder(int orderId) {
        String sql = "DELETE FROM Orders WHERE orderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}

