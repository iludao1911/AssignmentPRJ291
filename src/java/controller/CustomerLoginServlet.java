package controller;



import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
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
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute("currentCustomer"); // Logout khách hàng
            }
            response.sendRedirect("index.jsp"); 
            return;
        }
        
        request.getRequestDispatcher("/customer-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name"); // Lấy tên khách hàng
        String password = request.getParameter("password");

        try {
            Customer customer = customerService.validateCustomer(name, password);

            if (customer != null) {
                HttpSession session = request.getSession();
                session.setAttribute("currentCustomer", customer); 
                
                // Chuyển hướng Khách hàng đến trang xem thuốc
                response.sendRedirect(request.getContextPath() + "/customers"); 
            } else {
                request.setAttribute("error", "Tên khách hàng hoặc mật khẩu không đúng.");
                request.getRequestDispatcher("/customer-login.jsp").forward(request, response);
            }
        } catch (Exception ex) {
            request.setAttribute("error", "Lỗi: " + ex.getMessage());
            request.getRequestDispatcher("/customer-login.jsp").forward(request, response);
        }
    }
}