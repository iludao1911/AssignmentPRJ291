package dao;

import model.VerificationToken;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VerificationTokenDAO {
    
    private static final String INSERT_SQL = "INSERT INTO VerificationToken (User_id, token, token_type, expiry_date, used) VALUES (?, ?, ?, ?, ?)";
    private static final String SELECT_BY_TOKEN = "SELECT * FROM VerificationToken WHERE token = ?";
    private static final String SELECT_BY_USER_AND_TYPE = "SELECT * FROM VerificationToken WHERE User_id = ? AND token_type = ? AND used = 0 ORDER BY created_at DESC";
    private static final String UPDATE_USED = "UPDATE VerificationToken SET used = 1 WHERE Token_id = ?";
    private static final String DELETE_EXPIRED = "DELETE FROM VerificationToken WHERE expiry_date < GETDATE()";
    private static final String DELETE_BY_USER_AND_TYPE = "DELETE FROM VerificationToken WHERE User_id = ? AND token_type = ?";

    /**
     * Extract VerificationToken from ResultSet
     */
    private VerificationToken extractTokenFromResultSet(ResultSet rs) throws SQLException {
        VerificationToken token = new VerificationToken();
        token.setTokenId(rs.getInt("Token_id"));
        token.setUserId(rs.getInt("User_id"));
        token.setToken(rs.getString("token"));
        token.setTokenType(rs.getString("token_type"));
        token.setExpiryDate(rs.getTimestamp("expiry_date"));
        token.setCreatedAt(rs.getTimestamp("created_at"));
        token.setUsed(rs.getBoolean("used"));
        return token;
    }

    /**
     * Tạo token mới
     */
    public boolean createToken(VerificationToken token) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {

            ps.setInt(1, token.getUserId());
            ps.setString(2, token.getToken());
            ps.setString(3, token.getTokenType());
            ps.setTimestamp(4, new Timestamp(token.getExpiryDate().getTime()));
            ps.setBoolean(5, token.isUsed());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Lấy token bằng token string
     */
    public VerificationToken getTokenByString(String tokenString) throws SQLException {
        VerificationToken token = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_TOKEN)) {
            
            ps.setString(1, tokenString);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    token = extractTokenFromResultSet(rs);
                }
            }
        }
        return token;
    }

    /**
     * Lấy token mới nhất của user theo type
     */
    public VerificationToken getLatestTokenByUserAndType(int userId, String tokenType) throws SQLException {
        VerificationToken token = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_USER_AND_TYPE)) {
            
            ps.setInt(1, userId);
            ps.setString(2, tokenType);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    token = extractTokenFromResultSet(rs);
                }
            }
        }
        return token;
    }

    /**
     * Đánh dấu token đã sử dụng
     */
    public boolean markTokenAsUsed(int tokenId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_USED)) {
            
            ps.setInt(1, tokenId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Xóa tất cả token đã hết hạn
     */
    public int deleteExpiredTokens() throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_EXPIRED)) {
            
            return ps.executeUpdate();
        }
    }

    /**
     * Xóa tất cả token của user theo type (dùng khi tạo token mới)
     */
    public int deleteTokensByUserAndType(int userId, String tokenType) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_BY_USER_AND_TYPE)) {
            
            ps.setInt(1, userId);
            ps.setString(2, tokenType);
            
            return ps.executeUpdate();
        }
    }

    /**
     * Verify token (kiểm tra valid và chưa sử dụng)
     */
    public boolean verifyToken(String tokenString) throws SQLException {
        VerificationToken token = getTokenByString(tokenString);
        
        if (token == null) {
            return false;
        }
        
        return token.isValid();
    }
}
