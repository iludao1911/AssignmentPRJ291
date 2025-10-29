package controller;

import dao.UserDAO;
import dao.VerificationTokenDAO;
import model.VerificationToken;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private VerificationTokenDAO tokenDAO = new VerificationTokenDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        
        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Link không hợp lệ");
            request.getRequestDispatcher("auth-login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Kiểm tra token
            VerificationToken verificationToken = tokenDAO.getTokenByString(token);
            
            if (verificationToken == null) {
                request.setAttribute("error", "Link không tồn tại hoặc đã được sử dụng");
                request.getRequestDispatcher("auth-login.jsp").forward(request, response);
                return;
            }
            
            if (!VerificationToken.PASSWORD_RESET.equals(verificationToken.getTokenType())) {
                request.setAttribute("error", "Link không hợp lệ");
                request.getRequestDispatcher("auth-login.jsp").forward(request, response);
                return;
            }
            
            if (!verificationToken.isValid()) {
                if (verificationToken.isUsed()) {
                    request.setAttribute("error", "Link đã được sử dụng");
                } else if (verificationToken.isExpired()) {
                    request.setAttribute("error", "Link đã hết hạn. Vui lòng yêu cầu link mới.");
                }
                request.getRequestDispatcher("auth-login.jsp").forward(request, response);
                return;
            }
            
            // Token hợp lệ, hiển thị form reset password
            request.setAttribute("token", token);
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("auth-login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validation
        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Token không hợp lệ");
            request.getRequestDispatcher("auth-login.jsp").forward(request, response);
            return;
        }
        
        if (newPassword == null || newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            request.setAttribute("token", token);
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp");
            request.setAttribute("token", token);
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }
        
        try {
            // Kiểm tra token
            VerificationToken verificationToken = tokenDAO.getTokenByString(token);
            
            if (verificationToken == null || !verificationToken.isValid()) {
                request.setAttribute("error", "Token không hợp lệ hoặc đã hết hạn");
                request.getRequestDispatcher("auth-login.jsp").forward(request, response);
                return;
            }
            
            // Cập nhật mật khẩu
            boolean updated = userDAO.updatePassword(verificationToken.getUserId(), newPassword);
            
            if (updated) {
                // Đánh dấu token đã sử dụng
                tokenDAO.markTokenAsUsed(verificationToken.getTokenId());
                
                // Lấy user info
                User user = userDAO.getUserById(verificationToken.getUserId());
                
                request.setAttribute("success", "Mật khẩu đã được đặt lại thành công! Bạn có thể đăng nhập ngay bây giờ.");
                request.setAttribute("email", user != null ? user.getEmail() : "");
                request.getRequestDispatcher("auth-login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Không thể đặt lại mật khẩu. Vui lòng thử lại.");
                request.setAttribute("token", token);
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("auth-login.jsp").forward(request, response);
        }
    }
}
