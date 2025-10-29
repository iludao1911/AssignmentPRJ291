package controller;

import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import service.CustomerServiceImpl;
import service.ICustomerService;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    
    private ICustomerService customerService;
    
    @Override
    public void init() throws ServletException {
        this.customerService = new CustomerServiceImpl(new CustomerDAO());
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("reset".equals(action)) {
                handlePasswordReset(request, response);
            } else {
                handleForgotPassword(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }
    
    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");

    Customer customer = customerService.findByEmail(email);

        if (customer != null && customer.getName() != null && customer.getName().equalsIgnoreCase(name)) {
            // Lưu ID vào session để dùng khi reset
            HttpSession session = request.getSession();
            session.setAttribute("resetCustomerId", customer.getCustomerId());
            
            // Chuyển đến trang đặt lại mật khẩu
            request.setAttribute("customerId", customer.getCustomerId());
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Không tìm thấy tài khoản với thông tin này");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }
    
    private void handlePasswordReset(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("resetCustomerId") == null) {
            response.sendRedirect("forgot-password");
            return;
        }
        
        int customerId = (Integer) session.getAttribute("resetCustomerId");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp");
            request.setAttribute("customerId", customerId);
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }
        
        // Cập nhật mật khẩu
        boolean updated = ((CustomerServiceImpl)customerService).updatePassword(customerId, newPassword);
        
        if (updated) {
            // Xóa session để không thể dùng lại link reset
            session.removeAttribute("resetCustomerId");
            
            // Thông báo thành công và chuyển về trang đăng nhập
            request.setAttribute("success", "Đặt lại mật khẩu thành công. Vui lòng đăng nhập lại.");
            request.getRequestDispatcher("/customerLogin").forward(request, response);
        } else {
            request.setAttribute("error", "Không thể cập nhật mật khẩu");
            request.setAttribute("customerId", customerId);
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
        }
    }
}