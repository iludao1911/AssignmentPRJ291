package controller;



import dao.EmployeeDAO;
import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Employee;
import model.Customer;
import service.IEmployeeService;
import service.ICustomerService;
import service.EmployeeServiceImpl;
import service.CustomerServiceImpl;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private IEmployeeService employeeService;
    private ICustomerService customerService; // Cần khởi tạo Service cho Customer

    @Override
    public void init() throws ServletException {
        // Khởi tạo cả hai Service
        this.employeeService = new EmployeeServiceImpl(new EmployeeDAO());
        this.customerService = new CustomerServiceImpl(new CustomerDAO());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            logout(request, response);
            return;
        }
        
        // Hiển thị form đăng nhập hợp nhất
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        
        // Giả định trường input là 'username' và 'password' (Dùng cho cả Employee và Customer)
        String inputId = request.getParameter("username"); 
        String password = request.getParameter("password");
        
        if (inputId == null || inputId.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ tên/mã và mật khẩu.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            // 1. CỐ GẮNG XÁC THỰC LÀ EMPLOYEE (Quản lý)
            Employee employee = employeeService.validateEmployee(inputId, password);

            if (employee != null) {
                // Đăng nhập thành công là EMPLOYEE
                HttpSession session = request.getSession();
                session.setAttribute("currentEmployee", employee); 
                response.sendRedirect(request.getContextPath() + "/index.jsp"); // Chuyển đến trang quản lý
                return;
            }
            
            // 2. CỐ GẮNG XÁC THỰC LÀ CUSTOMER (Khách hàng)
            // (Giả định Khách hàng đăng nhập bằng Tên Khách hàng)
            Customer customer = customerService.validateCustomer(inputId, password); 

            if (customer != null) {
                // Đăng nhập thành công là CUSTOMER
                HttpSession session = request.getSession();
                session.setAttribute("currentCustomer", customer); 
                response.sendRedirect(request.getContextPath() + "/customers"); // Chuyển đến trang xem thuốc
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
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Hủy session cho cả Employee và Customer
        }
        response.sendRedirect("login"); 
    }
}