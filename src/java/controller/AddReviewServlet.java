package controller;

import dao.ReviewDAO;
import model.Review;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Servlet xử lý thêm review
 */
@WebServlet("/add-review")
public class AddReviewServlet extends HttpServlet {

    private ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\": false, \"message\": \"Phương thức GET không được hỗ trợ. Vui lòng dùng POST\"}");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("===== AddReviewServlet doPost called =====");
        System.out.println("Request method: " + request.getMethod());
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"Vui lòng đăng nhập để đánh giá\"}");
            return;
        }
        
        try {
            // Lấy thông tin từ request
            String medicineIdStr = request.getParameter("medicineId");
            String ratingStr = request.getParameter("rating");
            String comment = request.getParameter("comment");
            
            // Debug logging
            System.out.println("AddReviewServlet - medicineIdStr: " + medicineIdStr);
            System.out.println("AddReviewServlet - ratingStr: " + ratingStr);
            System.out.println("AddReviewServlet - comment: " + comment);
            
            if (medicineIdStr == null || ratingStr == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Thiếu thông tin bắt buộc\"}");
                return;
            }
            
            int medicineId = Integer.parseInt(medicineIdStr);
            int rating = Integer.parseInt(ratingStr);
            
            // Validate rating
            if (rating < 1 || rating > 5) {
                response.getWriter().write("{\"success\": false, \"message\": \"Đánh giá phải từ 1-5 sao\"}");
                return;
            }
            
            // Kiểm tra đã review chưa
            if (reviewDAO.hasUserReviewed(medicineId, currentUser.getUserId())) {
                response.getWriter().write("{\"success\": false, \"message\": \"Bạn đã đánh giá thuốc này rồi\"}");
                return;
            }
            
            // Tạo review mới
            Review review = new Review();
            review.setMedicineId(medicineId);
            review.setUserId(currentUser.getUserId());
            review.setRating(rating);
            review.setComment(comment);
            
            // Thêm vào database
            boolean success = reviewDAO.addReview(review);
            
            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Đánh giá thành công!\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra, vui lòng thử lại\"}");
            }
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Dữ liệu không hợp lệ: \" + e.getMessage() + \"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi database: \" + e.getMessage() + \"}");
        }
    }
}
