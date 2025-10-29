package controller;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import service.CustomerServiceImpl;
import service.ICustomerService;

import dao.CustomerDAO;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private ICustomerService customerService;

    @Override
    public void init() throws ServletException {
        this.customerService = new CustomerServiceImpl(new CustomerDAO());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirmPassword");

        if (name == null || name.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập tên và mật khẩu.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirm)) {
            request.setAttribute("error", "Mật khẩu và xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        Customer customer = new Customer();
        customer.setName(name);
        customer.setEmail(email);
        customer.setPhone(phone);
        customer.setPassword(password); // Lưu thẳng (cân nhắc băm mật khẩu)

        try {
            customerService.saveCustomer(customer);
            // Sau khi đăng ký thành công, chuyển tới trang đăng nhập khách hàng
            response.sendRedirect(request.getContextPath() + "/login.jsp?registration=success");
        } catch (SQLException | IllegalArgumentException ex) {
            request.setAttribute("error", "Đăng ký thất bại: " + ex.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
