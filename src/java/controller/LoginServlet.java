package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.EmployeeDAO;
import model.Employee;
import service.IEmployeeService;
import service.EmployeeServiceImpl;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private IEmployeeService employeeService;

    @Override
    public void init() throws ServletException {
        this.employeeService = new EmployeeServiceImpl(new EmployeeDAO());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            logout(request, response);
            return;
        }
        
        // CHUYỂN TIẾP TRỰC TIẾP VỀ FILE JSP GỐC
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        try {
            Employee employee = employeeService.validateEmployee(username, password);

            if (employee != null) {
                HttpSession session = request.getSession();
                session.setAttribute("currentEmployee", employee); 
                response.sendRedirect(request.getContextPath() + "/index.jsp"); 
            } else {
                request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng.");
                request.getRequestDispatcher("/login.jsp").forward(request, response); // Forward về JSP gốc
            }
        } catch (SQLException ex) {
            request.setAttribute("error", "Lỗi hệ thống: CSDL không thể truy vấn.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); 
        }
        response.sendRedirect("login"); 
    }
}