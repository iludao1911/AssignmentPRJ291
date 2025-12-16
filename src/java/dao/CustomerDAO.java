package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Customer;

public class CustomerDAO {
    // CÁC CÂU TRUY VẤN SQL
    //abc
    private static final String SELECT_ALL = "SELECT * FROM Customer WHERE role = 'Customer'";
    private static final String SELECT_BY_ID = "SELECT * FROM Customer WHERE Customer_id = ?";
    private static final String INSERT_SQL = "INSERT INTO Customer (name, email, phone, password, role) VALUES (?, ?, ?, ?, ?)";
    private static final String UPDATE_SQL = "UPDATE Customer SET name = ?, email = ?, phone = ?, role = ? WHERE Customer_id = ?";
    private static final String DELETE_SQL = "DELETE FROM Customer WHERE Customer_id = ? AND role = 'Customer'";
    private static final String SELECT_BY_EMAIL_AND_PASSWORD = "SELECT * FROM Customer WHERE email = ? AND password = ?";
    private static final String CHECK_EXISTING_EMAIL = "SELECT COUNT(*) FROM Customer WHERE email = ?";
    private static final String CHECK_EXISTING_EMAIL_EXCLUDE = "SELECT COUNT(*) FROM Customer WHERE email = ? AND Customer_id != ?";
    private static final String UPDATE_PASSWORD = "UPDATE Customer SET password = ? WHERE Customer_id = ?";
    private static final String GET_ADMIN = "SELECT TOP 1 * FROM Customer WHERE role = 'Admin'";

    private Customer extractCustomerFromResultSet(ResultSet rs) throws SQLException {
        Customer customer = new Customer();
        customer.setCustomerId(rs.getInt("Customer_id"));
        customer.setName(rs.getString("name"));
        customer.setEmail(rs.getString("email"));
        customer.setPhone(rs.getString("phone"));
        customer.setPassword(rs.getString("password"));
        customer.setRole(rs.getString("role"));
        return customer;
    }
    
    // --- PHƯƠNG THỨC XÁC THỰC KHÁCH HÀNG (MỚI) ---
    public Customer getCustomerByEmailAndPassword(String email, String password) throws SQLException {
        Customer customer = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_EMAIL_AND_PASSWORD)) {
            
            ps.setString(1, email);
            ps.setString(2, password); 
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    customer = extractCustomerFromResultSet(rs);
                }
            }
        }
        return customer;
    }

    public Customer getAdminAccount() throws SQLException {
        Customer admin = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_ADMIN);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                admin = extractCustomerFromResultSet(rs);
            }
        }
        return admin;
    }
    // --- CÁC PHƯƠNG THỨC CRUD KHÁC ---
    public List<Customer> getAllCustomers() throws SQLException {
        List<Customer> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Customer c = extractCustomerFromResultSet(rs);
                list.add(c);
            }
        }
        return list;
    }

    public Customer getCustomerById(int id) throws SQLException {
        Customer customer = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    customer = extractCustomerFromResultSet(rs);
                }
            }
        }
        //đ
        return customer;
        //đâsf
    }

    public boolean isEmailExists(String email) throws SQLException {
        if (email == null || email.trim().isEmpty()) return false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(CHECK_EXISTING_EMAIL)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public boolean isEmailExists(String email, Integer excludeCustomerId) throws SQLException {
        if (email == null || email.trim().isEmpty()) return false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(CHECK_EXISTING_EMAIL_EXCLUDE)) {
            ps.setString(1, email);
            ps.setInt(2, excludeCustomerId != null ? excludeCustomerId : -1);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public void insertCustomer(Customer customer) throws SQLException {
        // Kiểm tra email tồn tại
        if (isEmailExists(customer.getEmail(), null)) {
            throw new SQLException("Email đã được sử dụng");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {

            ps.setString(1, customer.getName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, customer.getPhone());
            ps.setString(4, customer.getPassword());
            ps.setString(5, customer.getRole() != null ? customer.getRole() : "Customer");

            ps.executeUpdate();
        }
    }

    public boolean updateCustomer(Customer customer) throws SQLException {
        // Nếu email thay đổi, kiểm tra email mới có tồn tại không (trừ email của chính user này)
        if (isEmailExists(customer.getEmail(), customer.getCustomerId())) {
            throw new SQLException("Email đã được sử dụng bởi tài khoản khác");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_SQL)) {
            ps.setString(1, customer.getName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, customer.getPhone());
            // Kiểm tra và giữ nguyên role nếu là Admin
            Customer existingCustomer = getCustomerById(customer.getCustomerId());
            if (existingCustomer != null && "Admin".equals(existingCustomer.getRole())) {
                ps.setString(4, "Admin");
            } else {
                ps.setString(4, "Customer");
            }
            ps.setInt(5, customer.getCustomerId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteCustomer(int id) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_SQL)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // Kiểm tra mật khẩu cho customer theo id
    public boolean validatePassword(int id, String password) throws SQLException {
        Customer customer = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    customer = extractCustomerFromResultSet(rs);
                }
            }
        }
        return customer != null && customer.getPassword() != null && customer.getPassword().equals(password);
    }

    // Phương thức tìm customer theo email (hỗ trợ quên mật khẩu)
    public Customer findByEmail(String email) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM Customer WHERE email = ?")) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCustomerFromResultSet(rs);
                }
            }
        }
        return null;
    }

    public boolean updatePassword(int customerId, String newPassword) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_PASSWORD)) {
            
            ps.setString(1, newPassword);
            ps.setInt(2, customerId);
            
            return ps.executeUpdate() > 0;
        }
    }
}