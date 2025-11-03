package filter;

import dao.CustomerDAO;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import service.CustomerServiceImpl;
import service.ICustomerService;

import java.io.IOException;
import java.sql.SQLException;

 @WebFilter("/*") 
 
public class AutoLoginFilter implements Filter {
    
    private ICustomerService customerService;
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        this.customerService = new CustomerServiceImpl(new CustomerDAO());
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, 
            FilterChain chain) throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Nếu chưa có session và không phải là request logout
    if (session == null || session.getAttribute("currentCustomer") == null) {
            
            // Kiểm tra cookie
            Cookie[] cookies = httpRequest.getCookies();
            if (cookies != null) {
                String savedCustomerId = null;
                String savedPassword = null;
                
                for (Cookie cookie : cookies) {
                    if ("customerId".equals(cookie.getName())) {
                        savedCustomerId = cookie.getValue();
                    }
                    if ("customerPass".equals(cookie.getName())) {
                        savedPassword = cookie.getValue();
                    }
                }
                
                // Nếu có cả customerId và password trong cookie
                if (savedCustomerId != null && savedPassword != null) {
                    try {
                        int customerId = Integer.parseInt(savedCustomerId);
                        // Lấy customer theo id rồi so sánh password
                        Customer customer = customerService.getCustomerById(customerId);

                        if (customer != null && customer.getPassword() != null && customer.getPassword().equals(savedPassword)) {
                            // Tạo session mới và lưu thông tin customer.
                            session = httpRequest.getSession();
                            session.setAttribute("currentCustomer", customer);
                            session.setAttribute("role", customer.getRole());

                            // Thêm logic chuyển hướng dựa trên vai trò
                            String targetUrl;
                            if ("Admin".equals(customer.getRole())) {
                                targetUrl = httpRequest.getContextPath() + "/admin/action/dashboard";
                            } else {
                                targetUrl = httpRequest.getContextPath() + "/customers";
                            }
                            httpResponse.sendRedirect(targetUrl);
                            return; // Dừng chuỗi filter sau khi chuyển hướng
                        } else {
                            // Nếu không hợp lệ, xóa cookie
                            Cookie customerIdCookie = new Cookie("customerId", "");
                            Cookie passwordCookie = new Cookie("customerPass", "");
                            customerIdCookie.setMaxAge(0);
                            passwordCookie.setMaxAge(0);
                            customerIdCookie.setPath("/");
                            passwordCookie.setPath("/");
                            httpResponse.addCookie(customerIdCookie);
                            httpResponse.addCookie(passwordCookie);
                        }
                    } catch (SQLException | NumberFormatException e) {
                        // Log error và xóa cookie nếu có lỗi
                        e.printStackTrace();
                        Cookie customerIdCookie = new Cookie("customerId", "");
                        Cookie passwordCookie = new Cookie("customerPass", "");
                        customerIdCookie.setMaxAge(0);
                        passwordCookie.setMaxAge(0);
                        customerIdCookie.setPath("/");
                        passwordCookie.setPath("/");
                        httpResponse.addCookie(customerIdCookie);
                        httpResponse.addCookie(passwordCookie);
                    }
                }
            }
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Không cần làm gì
    }
}