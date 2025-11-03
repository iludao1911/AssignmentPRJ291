package dao;

import model.Review;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class để xử lý các thao tác với bảng Review
 */
public class ReviewDAO {
    
    // CÁC CÂU TRUY VẤN SQL
    private static final String SELECT_BY_MEDICINE = 
        "SELECT r.*, u.name as userName, u.profile_image as userImage " +
        "FROM Review r " +
        "INNER JOIN [User] u ON r.User_id = u.User_id " +
        "WHERE r.Medicine_id = ? " +
        "ORDER BY r.created_at DESC";
    
    private static final String GET_AVG_RATING = 
        "SELECT AVG(CAST(rating AS FLOAT)) as avgRating FROM Review WHERE Medicine_id = ?";
    
    private static final String COUNT_REVIEWS = 
        "SELECT COUNT(*) as count FROM Review WHERE Medicine_id = ?";
    
    private static final String INSERT_REVIEW = 
        "INSERT INTO Review (Medicine_id, User_id, rating, comment) VALUES (?, ?, ?, ?)";
    
    private static final String CHECK_USER_REVIEWED = 
        "SELECT COUNT(*) as count FROM Review WHERE Medicine_id = ? AND User_id = ?";
    
    private static final String DELETE_REVIEW = 
        "DELETE FROM Review WHERE Review_id = ? AND User_id = ?";

    /**
     * Extract Review object từ ResultSet
     */
    private Review extractReviewFromResultSet(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setReviewId(rs.getInt("Review_id"));
        review.setMedicineId(rs.getInt("Medicine_id"));
        review.setUserId(rs.getInt("User_id"));
        review.setRating(rs.getInt("rating"));
        review.setComment(rs.getString("comment"));
        review.setCreatedAt(rs.getTimestamp("created_at"));
        
        // Thông tin user từ join
        review.setUserName(rs.getString("userName"));
        review.setUserImage(rs.getString("userImage"));
        
        return review;
    }

    /**
     * Lấy tất cả reviews của một thuốc
     */
    public List<Review> getReviewsByMedicineId(int medicineId) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_MEDICINE)) {
            
            ps.setInt(1, medicineId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reviews.add(extractReviewFromResultSet(rs));
                }
            }
        }
        
        return reviews;
    }

    /**
     * Lấy rating trung bình của một thuốc
     */
    public double getAverageRating(int medicineId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_AVG_RATING)) {
            
            ps.setInt(1, medicineId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("avgRating");
                }
            }
        }
        
        return 0.0;
    }

    /**
     * Đếm số lượng reviews của một thuốc
     */
    public int getReviewCount(int medicineId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_REVIEWS)) {
            
            ps.setInt(1, medicineId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        }
        
        return 0;
    }

    /**
     * Thêm review mới
     */
    public boolean addReview(Review review) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_REVIEW)) {
            
            ps.setInt(1, review.getMedicineId());
            ps.setInt(2, review.getUserId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
            
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Kiểm tra user đã review thuốc này chưa
     */
    public boolean hasUserReviewed(int medicineId, int userId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(CHECK_USER_REVIEWED)) {
            
            ps.setInt(1, medicineId);
            ps.setInt(2, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }
        }
        
        return false;
    }

    /**
     * Xóa review (chỉ user tạo review mới xóa được)
     */
    public boolean deleteReview(int reviewId, int userId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_REVIEW)) {
            
            ps.setInt(1, reviewId);
            ps.setInt(2, userId);
            
            return ps.executeUpdate() > 0;
        }
    }
}
