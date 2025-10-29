package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {
    "/customers/*",  // Bảo vệ trang khách hàng xem thuốc
    "/suppliers/*",  // Bảo vệ trang xem nhà cung cấp
    "/medicines/*"   // Bảo vệ trang xem thuốc (nếu có)
})
public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Không cần khởi tạo gì
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Kiểm tra xem người dùng đã đăng nhập chưa (là Customer hoặc Employee)
        boolean isLoggedIn = session != null && 
                           (session.getAttribute("currentCustomer") != null || 
                            session.getAttribute("currentEmployee") != null);
        
        if (isLoggedIn) {
            // Người dùng đã đăng nhập, cho phép tiếp tục
            chain.doFilter(request, response);
        } else {
            // Chưa đăng nhập, chuyển hướng về trang đăng nhập
            String contextPath = httpRequest.getContextPath();
            httpResponse.sendRedirect(contextPath + "/customerLogin");
        }
    }
    
    @Override
    public void destroy() {
        // Không cần dọn dẹp gì
    }
}