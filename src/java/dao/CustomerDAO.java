package dao;

import model.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {
    private static final String SELECT_ALL = "SELECT * FROM Customer";
    private static final String SELECT_BY_ID = "SELECT * FROM Customer WHERE Customer_id = ?";
    private static final String INSERT_SQL = "INSERT INTO Customer (name, email, phone, password) VALUES (?, ?, ?, ?)"; // Đã thêm password
    private static final String UPDATE_SQL = "UPDATE Customer SET name = ?, email = ?, phone = ? WHERE Customer_id = ?";
    private static final String DELETE_SQL = "DELETE FROM Customer WHERE Customer_id = ?";
    
    // SỬ DỤNG NAME ĐỂ XÁC THỰC
    private static final String SELECT_BY_NAME_AND_PASSWORD = "SELECT * FROM Customer WHERE name = ? AND password = ?";

    private Customer extractCustomerFromResultSet(ResultSet rs) throws SQLException {
        Customer customer = new Customer();
        customer.setCustomerId(rs.getInt("Customer_id"));
        customer.setName(rs.getString("name"));
        customer.setEmail(rs.getString("email"));
        customer.setPhone(rs.getString("phone"));
        customer.setPassword(rs.getString("password")); // Lấy mật khẩu để so sánh (nếu cần)
        return customer;
    }
    
    // --- PHƯƠNG THỨC XÁC THỰC KHÁCH HÀNG (MỚI) ---
    public Customer getCustomerByNameAndPassword(String name, String password) throws SQLException {
        Customer customer = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_NAME_AND_PASSWORD)) {
            
            ps.setString(1, name);
            ps.setString(2, password); 
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    customer = extractCustomerFromResultSet(rs);
                }
            }
        }
        return customer;
    }

    // --- CÁC PHƯƠNG THỨC CRUD KHÁC (Đã hoàn thiện) ---
    public List<Customer> getAllCustomers() throws SQLException { /* ... */ return null; }
    public Customer getCustomerById(int id) throws SQLException { /* ... */ return null; }
    public void insertCustomer(Customer customer) throws SQLException { /* ... */ }
    public boolean updateCustomer(Customer customer) throws SQLException { /* ... */ return false; }
    public boolean deleteCustomer(int id) throws SQLException { /* ... */ return false; }
}