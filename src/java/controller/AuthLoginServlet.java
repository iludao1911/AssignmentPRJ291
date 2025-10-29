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
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.UUID;

@WebServlet("/auth-login")
public class AuthLoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private VerificationTokenDAO tokenDAO = new VerificationTokenDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("auth-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username"); // Email hoặc phone
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        try {
            // Login bằng email
            User user = userDAO.getUserByEmailAndPassword(username, password);
            
            if (user != null) {
                // Kiểm tra email đã verify chưa (chỉ với Customer, Admin không cần)
                if (!user.isVerified() && user.isCustomer()) {
                    // Gửi lại email verification
                    try {
                        // Xóa các token cũ
                        tokenDAO.deleteTokensByUserAndType(user.getUserId(), VerificationToken.EMAIL_VERIFICATION);
                        
                        // Tạo token mới
                        String token = UUID.randomUUID().toString();
                        Calendar calendar = Calendar.getInstance();
                        calendar.add(Calendar.HOUR, 24);
                        
                        VerificationToken verificationToken = new VerificationToken(
                            user.getUserId(),
                            token,
                            VerificationToken.EMAIL_VERIFICATION,
                            calendar.getTime()
                        );
                        
                        tokenDAO.createToken(verificationToken);
                        
                        // Gửi email
                        service.EmailService.sendVerificationEmail(user.getEmail(), user.getName(), token);
                        
                        request.setAttribute("error", "Tài khoản chưa được xác thực. Email xác thực mới đã được gửi đến " + user.getEmail());
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("error", "Tài khoản chưa được xác thực. Vui lòng kiểm tra email hoặc đăng ký lại.");
                    }
                    request.getRequestDispatcher("auth-login.jsp").forward(request, response);
                    return;
                }
                
                // Tạo session
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("userRole", user.getRole());
                
                // Set session timeout
                if ("on".equals(remember)) {
                    session.setMaxInactiveInterval(30 * 24 * 60 * 60); // 30 days
                } else {
                    session.setMaxInactiveInterval(30 * 60); // 30 minutes
                }
                
                // Redirect dựa vào role
                if (user.isAdmin()) {
                    response.sendRedirect("admin-dashboard.jsp");
                } else {
                    response.sendRedirect("home.jsp");
                }
                return;
            }

            // Login failed
            request.setAttribute("error", "Email hoặc mật khẩu không đúng. Vui lòng thử lại.");
            request.getRequestDispatcher("auth-login.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("auth-login.jsp").forward(request, response);
        }
    }
}
