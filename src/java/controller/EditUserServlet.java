package controller;

import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/edit-user")
public class EditUserServlet extends HttpServlet {
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Chỉ cho phép Admin truy cập
        Object emp = request.getSession().getAttribute("currentEmployee");
        String role = (emp != null) ? ((model.Employee)emp).getRole() : null;
        if (role == null || !"Admin".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        int id = Integer.parseInt(request.getParameter("id"));
        try {
            Customer user = customerDAO.getCustomerById(id);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/edit-user.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Chỉ cho phép Admin truy cập
        Object emp = request.getSession().getAttribute("currentEmployee");
        String role = (emp != null) ? ((model.Employee)emp).getRole() : null;
        if (role == null || !"Admin".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        Customer user = new Customer();
        user.setCustomerId(id);
        user.setName(name);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPassword(password);
        try {
            customerDAO.updateCustomer(user);
            response.sendRedirect("admin-users");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
