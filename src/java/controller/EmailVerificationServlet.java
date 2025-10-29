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

@WebServlet("/verify-email")
public class EmailVerificationServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private VerificationTokenDAO tokenDAO = new VerificationTokenDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        
        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Token không hợp lệ");
            request.getRequestDispatcher("auth-login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Lấy token từ database
            VerificationToken verificationToken = tokenDAO.getTokenByString(token);
            
            if (verificationToken == null) {
                request.setAttribute("error", "Token không tồn tại hoặc đã được sử dụng");
                request.getRequestDispatcher("auth-login.jsp").forward(request, response);
                return;
            }
            
            // Kiểm tra token type
            if (!VerificationToken.EMAIL_VERIFICATION.equals(verificationToken.getTokenType())) {
                request.setAttribute("error", "Token không hợp lệ cho xác thực email");
                request.getRequestDispatcher("auth-login.jsp").forward(request, response);
                return;
            }
            
            // Kiểm tra token có hợp lệ không (chưa dùng và chưa hết hạn)
            if (!verificationToken.isValid()) {
                if (verificationToken.isUsed()) {
                    request.setAttribute("error", "Token đã được sử dụng");
                } else if (verificationToken.isExpired()) {
                    request.setAttribute("error", "Token đã hết hạn. Vui lòng đăng ký lại");
                }
                request.getRequestDispatcher("auth-login.jsp").forward(request, response);
                return;
            }
            
            // Cập nhật user thành verified
            boolean updated = userDAO.updateVerifiedStatus(verificationToken.getUserId(), true);
            
            if (updated) {
                // Đánh dấu token đã sử dụng
                tokenDAO.markTokenAsUsed(verificationToken.getTokenId());
                
                // Lấy thông tin user để hiển thị
                User user = userDAO.getUserById(verificationToken.getUserId());
                
                request.setAttribute("success", "Xác thực email thành công! Bạn có thể đăng nhập ngay bây giờ.");
                request.setAttribute("verifiedEmail", user != null ? user.getEmail() : "");
                request.getRequestDispatcher("auth-login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Không thể xác thực email. Vui lòng thử lại");
                request.getRequestDispatcher("auth-login.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("auth-login.jsp").forward(request, response);
        }
    }
}
