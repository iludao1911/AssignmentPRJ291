package controller;

import dao.CartDAO;
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
 * Servlet xử lý thêm sản phẩm vào giỏ hàng
 */
@WebServlet("/add-to-cart")
public class AddToCartServlet extends HttpServlet {

    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"Vui lòng đăng nhập để thêm vào giỏ hàng\"}");
            return;
        }
        
        try {
            // Lấy thông tin từ request
            String medicineIdStr = request.getParameter("medicineId");
            String quantityStr = request.getParameter("quantity");
            
            if (medicineIdStr == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Thiếu thông tin sản phẩm\"}");
                return;
            }
            
            int medicineId = Integer.parseInt(medicineIdStr);
            int quantity = (quantityStr != null) ? Integer.parseInt(quantityStr) : 1;
            
            if (quantity <= 0) {
                response.getWriter().write("{\"success\": false, \"message\": \"Số lượng phải lớn hơn 0\"}");
                return;
            }
            
            // Thêm vào cart
            boolean success = cartDAO.addToCart(currentUser.getUserId(), medicineId, quantity);
            
            if (success) {
                // Lấy số lượng items trong cart
                int cartCount = cartDAO.getCartCount(currentUser.getUserId());
                response.getWriter().write("{\"success\": true, \"message\": \"Đã thêm vào giỏ hàng\", \"cartCount\": " + cartCount + "}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra, vui lòng thử lại\"}");
            }
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Dữ liệu không hợp lệ\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi database: \" + e.getMessage() + \"}");
        }
    }
}
