package dao;

import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    // CÁC CÂU TRUY VẤN SQL
    private static final String SELECT_ALL = "SELECT * FROM [User]";
    private static final String SELECT_BY_ID = "SELECT * FROM [User] WHERE User_id = ?";
    private static final String SELECT_BY_EMAIL = "SELECT * FROM [User] WHERE email = ?";
    private static final String SELECT_BY_EMAIL_AND_PASSWORD = "SELECT * FROM [User] WHERE email = ? AND password = ?";
    private static final String INSERT_SQL = "INSERT INTO [User] (name, email, phone, password, role, is_verified, profile_image) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_SQL = "UPDATE [User] SET name = ?, email = ?, phone = ?, role = ?, profile_image = ? WHERE User_id = ?";
    private static final String UPDATE_PASSWORD = "UPDATE [User] SET password = ? WHERE User_id = ?";
    private static final String UPDATE_VERIFIED = "UPDATE [User] SET is_verified = ? WHERE User_id = ?";
    private static final String DELETE_SQL = "DELETE FROM [User] WHERE User_id = ? AND role = 'Customer'";
    private static final String CHECK_EXISTING_EMAIL = "SELECT COUNT(*) FROM [User] WHERE email = ?";
    private static final String CHECK_EXISTING_EMAIL_EXCLUDE = "SELECT COUNT(*) FROM [User] WHERE email = ? AND User_id != ?";
    private static final String GET_ADMIN = "SELECT TOP 1 * FROM [User] WHERE role = 'Admin'";

    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("User_id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setVerified(rs.getBoolean("is_verified"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setImage(rs.getString("profile_image"));
        return user;
    }
    
    // --- AUTHENTICATION ---
    
    /**
     * Xác thực người dùng bằng email và password
     */
    public User getUserByEmailAndPassword(String email, String password) throws SQLException {
        User user = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_EMAIL_AND_PASSWORD)) {
            
            ps.setString(1, email);
            ps.setString(2, password); 
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = extractUserFromResultSet(rs);
                }
            }
        }
        return user;
    }

    /**
     * Lấy user bằng email
     */
    public User getUserByEmail(String email) throws SQLException {
        User user = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_EMAIL)) {
            
            ps.setString(1, email);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = extractUserFromResultSet(rs);
                }
            }
        }
        return user;
    }

    /**
     * Lấy tài khoản Admin
     */
    public User getAdminAccount() throws SQLException {
        User admin = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_ADMIN);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                admin = extractUserFromResultSet(rs);
            }
        }
        return admin;
    }

    // --- CRUD OPERATIONS ---
    
    /**
     * Lấy tất cả người dùng
     */
    public List<User> getAllUsers() throws SQLException {
        List<User> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = extractUserFromResultSet(rs);
                list.add(user);
            }
        }
        return list;
    }

    /**
     * Lấy user theo ID
     */
    public User getUserById(int id) throws SQLException {
        User user = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = extractUserFromResultSet(rs);
                }
            }
        }
        return user;
    }

    /**
     * Kiểm tra email có tồn tại không
     */
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

    /**
     * Kiểm tra email có tồn tại không (ngoại trừ user có ID cụ thể)
     */
    public boolean isEmailExists(String email, Integer excludeUserId) throws SQLException {
        if (email == null || email.trim().isEmpty()) return false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(CHECK_EXISTING_EMAIL_EXCLUDE)) {
            ps.setString(1, email);
            ps.setInt(2, excludeUserId != null ? excludeUserId : -1);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Thêm user mới
     */
    public int insertUser(User user) throws SQLException {
        // Kiểm tra email tồn tại
        if (isEmailExists(user.getEmail())) {
            throw new SQLException("Email đã được sử dụng");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getPassword());
            ps.setString(5, user.getRole() != null ? user.getRole() : "Customer");
            ps.setBoolean(6, user.isVerified());
            ps.setString(7, user.getImage());

            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        }
        return -1;
    }

    /**
     * Cập nhật thông tin user
     */
    public boolean updateUser(User user) throws SQLException {
        // Nếu email thay đổi, kiểm tra email mới có tồn tại không
        if (isEmailExists(user.getEmail(), user.getUserId())) {
            throw new SQLException("Email đã được sử dụng bởi tài khoản khác");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_SQL)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getImage());
            ps.setInt(6, user.getUserId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Cập nhật mật khẩu
     */
    public boolean updatePassword(int userId, String newPassword) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_PASSWORD)) {
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Cập nhật trạng thái verified
     */
    public boolean updateVerifiedStatus(int userId, boolean isVerified) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_VERIFIED)) {
            ps.setBoolean(1, isVerified);
            ps.setInt(2, userId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Xóa user (chỉ Customer)
     */
    public boolean deleteUser(int id) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_SQL)) {

            ps.setInt(1, id);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }
}
