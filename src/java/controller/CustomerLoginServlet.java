package controller;



import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import service.ICustomerService;
import service.CustomerServiceImpl;

import java.io.IOException;

@WebServlet("/customerLogin")
public class CustomerLoginServlet extends HttpServlet {

    private ICustomerService customerService;

    @Override
    public void init() throws ServletException {
        this.customerService = new CustomerServiceImpl(new CustomerDAO());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            // Xóa session
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute("currentCustomer"); // Logout khách hàng
            }
            
            // Xóa cookie khi đăng xuất
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("customerId".equals(cookie.getName()) || "customerPass".equals(cookie.getName())) {
                        cookie.setValue("");
                        cookie.setPath("/");
                        cookie.setMaxAge(0);
                        response.addCookie(cookie);
                    }
                }
            }
            
            response.sendRedirect("index.jsp"); 
            return;
        }
        
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email"); // Lấy email khách hàng
        String password = request.getParameter("password");

        try {
            Customer customer = customerService.validateCustomer(email, password);

            if (customer != null) {
                HttpSession session = request.getSession();
                session.setAttribute("currentCustomer", customer); 

                // Kiểm tra có tích "Ghi nhớ đăng nhập" không
                String remember = request.getParameter("remember");
                if ("true".equals(remember)) {
                    // Tạo cookie lưu trong 15 ngày
                    Cookie customerIdCookie = new Cookie("customerId", 
                        String.valueOf(customer.getCustomerId()));
                    Cookie passwordCookie = new Cookie("customerPass", 
                        customer.getPassword());
                    
                    int maxAge = 60 * 60 * 24 * 15; // 15 ngày
                    customerIdCookie.setMaxAge(maxAge);
                    passwordCookie.setMaxAge(maxAge);
                    
                    customerIdCookie.setPath("/");
                    passwordCookie.setPath("/");
                    
                    response.addCookie(customerIdCookie);
                    response.addCookie(passwordCookie);
                } else {
                    // Nếu người dùng không chọn "Ghi nhớ", hãy xóa cookie cũ (nếu có)
                    Cookie customerIdCookie = new Cookie("customerId", "");
                    Cookie passwordCookie = new Cookie("customerPass", "");
                    customerIdCookie.setMaxAge(0);
                    passwordCookie.setMaxAge(0);
                    customerIdCookie.setPath("/");
                    passwordCookie.setPath("/");
                    response.addCookie(customerIdCookie);
                    response.addCookie(passwordCookie);
                }
                
                // Chuyển hướng Khách hàng đến trang xem thuốc
                response.sendRedirect(request.getContextPath() + "/customers"); 
            } else {
                request.setAttribute("error", "Tên khách hàng hoặc mật khẩu không đúng.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception ex) {
            request.setAttribute("error", "Lỗi: " + ex.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}