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
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private ICustomerService customerService;

    @Override
    public void init() throws ServletException {
        this.customerService = new CustomerServiceImpl(new CustomerDAO());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        System.out.println("\n=== LoginServlet.doGet ===");
        System.out.println("URI: " + request.getRequestURI());
        System.out.println("Action: " + action);
        
        if ("logout".equals(action)) {
            logout(request, response);
            return;
        }
        
        HttpSession session = request.getSession(false);
        System.out.println("Has session: " + (session != null));
        
        // Nếu đã đăng nhập thì chuyển hướng tới trang phù hợp thay vì hiển thị form
        if (session != null && session.getAttribute("currentCustomer") != null) {
            Customer current = (Customer) session.getAttribute("currentCustomer");
            System.out.println("Current customer: " + current);
            System.out.println("Role: " + current.getRole());
            
            String targetUrl;
            if ("Admin".equals(current.getRole())) {
                targetUrl = request.getContextPath() + "/admin/action/dashboard";
            } else {
                targetUrl = request.getContextPath() + "/customers";
            }
            System.out.println("Redirecting to: " + targetUrl);
            response.sendRedirect(targetUrl);
            return;
        }

        // Hiển thị form đăng nhập hợp nhất
        System.out.println("Forwarding to login.jsp");
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        
        // Giả định trường input là 'username' và 'password' (Dùng cho cả Employee và Customer)
        String inputId = request.getParameter("username"); 
        String password = request.getParameter("password");
        
        String email = request.getParameter("email");
        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ email và mật khẩu.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            Customer customer = customerService.validateCustomer(email, password); 

            if (customer != null) {
                // Đăng nhập thành công
                HttpSession session = request.getSession();
                session.setAttribute("currentCustomer", customer);
                session.setAttribute("role", customer.getRole());

                // Kiểm tra có tích "Ghi nhớ đăng nhập" không (lưu cookie trước khi redirect)
                String remember = request.getParameter("remember");
                if ("true".equals(remember)) {
                    // Tạo cookie lưu trong 15 ngày
                    Cookie customerIdCookie = new Cookie("customerId", String.valueOf(customer.getCustomerId()));
                    Cookie passwordCookie = new Cookie("customerPass", customer.getPassword());
                    int maxAge = 60 * 60 * 24 * 15; // 15 ngày
                    customerIdCookie.setMaxAge(maxAge);
                    passwordCookie.setMaxAge(maxAge);
                    customerIdCookie.setPath("/");
                    passwordCookie.setPath("/");
                    response.addCookie(customerIdCookie);
                    response.addCookie(passwordCookie);
                } else {
                    // Nếu người dùng không chọn "Ghi nhớ", hãy xóa cookie cũ (nếu có)
                    System.out.println("ATTEMPTING TO DELETE COOKIES FOR CUSTOMER");
                    Cookie customerIdCookie = new Cookie("customerId", "");
                    Cookie passwordCookie = new Cookie("customerPass", "");
                    customerIdCookie.setMaxAge(0);
                    passwordCookie.setMaxAge(0);
                    customerIdCookie.setPath("/");
                    passwordCookie.setPath("/");
                    response.addCookie(customerIdCookie);
                    response.addCookie(passwordCookie);
                }

                // Chuyển hướng dựa trên role (chỉ redirect một lần)
                if ("Admin".equals(customer.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/admin/action/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/customers");
                }
                return;
            }

            // 3. XÁC THỰC THẤT BẠI
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            
        } catch (SQLException ex) {
            request.setAttribute("error", "Lỗi hệ thống: CSDL không thể truy vấn.");
            ex.printStackTrace();
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Xóa session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Hủy session cho cả Employee và Customer
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

        response.sendRedirect("login"); 
    }
}