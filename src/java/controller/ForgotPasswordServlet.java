package controller;

import dao.UserDAO;
import dao.VerificationTokenDAO;
import model.User;
import model.VerificationToken;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.UUID;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private VerificationTokenDAO tokenDAO = new VerificationTokenDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        
        // Validation
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ email");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }
        
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            request.setAttribute("error", "Địa chỉ email không hợp lệ");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }
        
        try {
            // Kiểm tra email có tồn tại không
            User user = userDAO.getUserByEmail(email);
            
            if (user == null) {
                // Không tìm thấy user nhưng vẫn hiển thị success để tránh leak thông tin
                request.setAttribute("success", "Nếu email tồn tại trong hệ thống, chúng tôi đã gửi link đặt lại mật khẩu đến email của bạn. Vui lòng kiểm tra hộp thư.");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                return;
            }
            
            // Xóa các token reset password cũ
            tokenDAO.deleteTokensByUserAndType(user.getUserId(), VerificationToken.PASSWORD_RESET);
            
            // Tạo token mới
            String token = UUID.randomUUID().toString();
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.HOUR, 1); // Token có hiệu lực 1 giờ
            
            VerificationToken resetToken = new VerificationToken(
                user.getUserId(),
                token,
                VerificationToken.PASSWORD_RESET,
                calendar.getTime()
            );
            
            boolean tokenCreated = tokenDAO.createToken(resetToken);
            
            if (tokenCreated) {
                // Gửi email
                boolean emailSent = service.EmailService.sendPasswordResetEmail(
                    user.getEmail(),
                    user.getName(),
                    token
                );
                
                if (emailSent) {
                    request.setAttribute("success", "Link đặt lại mật khẩu đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư.");
                } else {
                    request.setAttribute("error", "Không thể gửi email. Vui lòng thử lại sau.");
                }
            } else {
                request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại.");
            }
            
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        }
    }
}
