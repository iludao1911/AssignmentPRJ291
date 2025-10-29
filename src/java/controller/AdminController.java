package controller;

import dao.CustomerDAO;
import dao.MedicineDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import model.Medicine;
import service.CustomerServiceImpl;
import service.ICustomerService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Front controller for all admin-related actions.
 * Mapped to /admin/* and uses path info to route to specific methods.
 */
@WebServlet("/admin/action/*")
public class AdminController extends HttpServlet {

    private ICustomerService customerService;
    private MedicineDAO medicineDAO;

    @Override
    public void init() {
        customerService = new CustomerServiceImpl(new CustomerDAO());
        medicineDAO = new MedicineDAO(); // Assuming MedicineDAO has a default constructor
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getPathInfo();
        if (action == null) {
            action = "/dashboard"; // Default action
        }

        try {
            switch (action) {
                case "/users":
                    listUsers(request, response);
                    break;
                case "/users/edit":
                    showEditUserForm(request, response);
                    break;
                case "/products":
                    request.getRequestDispatcher("/medicines").forward(request, response);
                    break;
                case "/products/new":
                    request.getRequestDispatcher("/medicines?action=new").forward(request, response);
                    break;
                case "/suppliers":
                    request.getRequestDispatcher("/suppliers").forward(request, response);
                    break;
                case "/orders":
                    request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
                    break;
                case "/dashboard":
                default: // Default to dashboard
                    showDashboard(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException("Database error in AdminController", ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getPathInfo();
        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            return;
        }

        try {
            switch (action) {
                case "/users/delete":
                    deleteUser(request, response);
                    break;
                case "/users/update":
                    updateUser(request, response);
                    break;
                // Add other POST actions here (e.g., /users/add, /users/update)
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException("Database error in AdminController", ex);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        // Fetch data for dashboard (example counts)
        List<Medicine> medicines = medicineDAO.getAllMedicines();
        List<Customer> customers = customerService.getAllCustomers();
        
        request.setAttribute("totalProducts", medicines.size());
        request.setAttribute("totalUsers", customers.size());
        // You can add more attributes like new orders etc.
        request.setAttribute("newOrders", 0); // Placeholder

        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/dashboard.jsp");
        dispatcher.forward(request, response);
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        List<Customer> userList = customerService.getAllCustomers();
        request.setAttribute("users", userList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/users.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditUserForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            Customer existingUser = customerService.getCustomerById(userId);
            if (existingUser != null) {
                request.setAttribute("user", existingUser);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/edit-user.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/action/users?error=UserNotFound");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/action/users?error=InvalidUserId");
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            customerService.deleteCustomer(userId);
            // Redirect back to the user list after deletion
            response.sendRedirect(request.getContextPath() + "/admin/action/users?deleteSuccess=true");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/action/users?deleteError=true");
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");
            
            Customer existingUser = customerService.getCustomerById(id);
            if (existingUser == null) {
                response.sendRedirect(request.getContextPath() + "/admin/action/users?error=UserNotFound");
                return;
            }
            
            // If password field is empty, keep the old password
            if (password == null || password.trim().isEmpty()) {
                password = existingUser.getPassword();
            }

            String role = existingUser.getRole(); // Preserve the original role

            // Use setters instead of constructor
            Customer user = new Customer();
            user.setCustomerId(id);
            user.setName(name);
            user.setEmail(email);
            user.setPhone(phone);
            user.setPassword(password);
            user.setRole(role);

            customerService.updateCustomer(user);
            response.sendRedirect(request.getContextPath() + "/admin/action/users?updateSuccess=true");
        } catch (NumberFormatException e) {
            e.printStackTrace(); 
            String userId = request.getParameter("id");
            response.sendRedirect(request.getContextPath() + "/admin/action/users/edit?id=" + userId + "&error=UpdateFailed");
        } catch (SQLException e) {
            e.printStackTrace(); 
            String userId = request.getParameter("id");
            response.sendRedirect(request.getContextPath() + "/admin/action/users/edit?id=" + userId + "&error=UpdateFailed");
        } catch (IllegalArgumentException e) {
            e.printStackTrace(); 
            String userId = request.getParameter("id");
            response.sendRedirect(request.getContextPath() + "/admin/action/users/edit?id=" + userId + "&error=UpdateFailed");
        }
    }
}
