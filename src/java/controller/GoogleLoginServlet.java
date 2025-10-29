package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.UserDAO;
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
 * Servlet xử lý Google OAuth Login
 */
@WebServlet("/google-login")
public class GoogleLoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Đọc Google user info từ request body
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            
            Gson gson = new Gson();
            JsonObject googleUser = gson.fromJson(sb.toString(), JsonObject.class);
            
            String email = googleUser.get("email").getAsString();
            String name = googleUser.get("name").getAsString();
            String picture = googleUser.has("picture") ? googleUser.get("picture").getAsString() : null;
            
            // Kiểm tra user đã tồn tại chưa
            User user = userDAO.getUserByEmail(email);
            
            if (user == null) {
                // Tạo user mới từ Google data
                user = new User();
                user.setName(name);
                user.setEmail(email);
                user.setPassword(""); // Google login không cần password
                user.setRole("Customer");
                user.setVerified(true); // Google đã verify email
                user.setImage(picture);
                
                int userId = userDAO.insertUser(user);
                if (userId > 0) {
                    user.setUserId(userId);
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("{\"success\": false, \"message\": \"Không thể tạo tài khoản\"}");
                    return;
                }
            } else {
                // Cập nhật avatar nếu chưa có
                if (user.getImage() == null && picture != null) {
                    user.setImage(picture);
                    userDAO.updateUser(user);
                }
            }
            
            // Lưu user vào session
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userRole", user.getRole());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            
            // Trả về success
            response.getWriter().write("{\"success\": true, \"redirectUrl\": \"home.jsp\"}");
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi database: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi xử lý: " + e.getMessage() + "\"}");
        }
    }
}
