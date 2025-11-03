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
import java.util.Date;
import java.util.UUID;

@WebServlet("/auth-register")
public class AuthRegisterServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private VerificationTokenDAO tokenDAO = new VerificationTokenDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("auth-register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validation
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập họ tên đầy đủ");
            request.getRequestDispatcher("auth-register.jsp").forward(request, response);
            return;
        }

        if (email == null || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            request.setAttribute("error", "Vui lòng nhập email hợp lệ");
            request.getRequestDispatcher("auth-register.jsp").forward(request, response);
            return;
        }

        if (phone == null || !phone.matches("^[0-9]{10,11}$")) {
            request.setAttribute("error", "Vui lòng nhập số điện thoại hợp lệ (10-11 số)");
            request.getRequestDispatcher("auth-register.jsp").forward(request, response);
            return;
        }

        if (password == null || password.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            request.getRequestDispatcher("auth-register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp");
            request.getRequestDispatcher("auth-register.jsp").forward(request, response);
            return;
        }

        try {
            // Check if email already exists
            if (userDAO.isEmailExists(email)) {
                request.setAttribute("error", "Email đã được đăng ký. Vui lòng sử dụng email khác hoặc đăng nhập.");
                request.getRequestDispatcher("auth-register.jsp").forward(request, response);
                return;
            }

            // Create new user (not verified yet)
            User newUser = new User();
            newUser.setName(fullName);
            newUser.setEmail(email);
            newUser.setPhone(phone);
            newUser.setPassword(password);
            newUser.setRole("Customer");
            newUser.setVerified(false); // Chưa verify

            int userId = userDAO.insertUser(newUser);

            if (userId > 0) {
                // Tạo verification token
                String token = UUID.randomUUID().toString();
                Calendar calendar = Calendar.getInstance();
                calendar.add(Calendar.HOUR, 24); // Token có hiệu lực 24 giờ
                
                VerificationToken verificationToken = new VerificationToken(
                    userId, 
                    token, 
                    VerificationToken.EMAIL_VERIFICATION, 
                    calendar.getTime()
                );
                
                tokenDAO.createToken(verificationToken);
                
                // Gửi email verification
                service.EmailService.sendVerificationEmail(email, fullName, token);
                
                request.setAttribute("success", "Đăng ký thành công! Vui lòng kiểm tra email để xác thực tài khoản.");
                request.getRequestDispatcher("auth-login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại.");
                request.getRequestDispatcher("auth-register.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("auth-register.jsp").forward(request, response);
        }
    }
}
