package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.CustomerDAO;
import model.Customer;
import service.ICustomerService;
import service.CustomerServiceImpl;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/customers")
public class CustomerServlet extends HttpServlet {

    private ICustomerService customerService;

    @Override
    public void init() throws ServletException {
        // Khởi tạo Service
        this.customerService = new CustomerServiceImpl(new CustomerDAO()); 
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "delete":
                    deleteCustomer(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "list":
                default:
                    listCustomers(request, response);
                    break;
            }
        } catch (SQLException ex) {
            // Xử lý lỗi CSDL chung
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + ex.getMessage());
            request.getRequestDispatcher("/customers.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        request.setCharacterEncoding("UTF-8");

        try {
            if ("insert".equals(action)) {
                insertCustomer(request, response);
            } else if ("update".equals(action)) {
                updateCustomer(request, response);
            } else {
                listCustomers(request, response);
            }
        } catch (SQLException | IllegalArgumentException ex) {
            // Xử lý lỗi nghiệp vụ hoặc lỗi nhập liệu
            request.setAttribute("error", ex.getMessage());
            request.getRequestDispatcher("/customer-form.jsp").forward(request, response);
        }
    }
    
    // --------------------------------------------------------------------------
    // PHƯƠNG THỨC HỖ TRỢ (HELPER METHODS)
    // --------------------------------------------------------------------------

    /** Trích xuất dữ liệu từ request thành đối tượng Customer. */
    private Customer extractCustomerFromRequest(HttpServletRequest request, int id) throws IllegalArgumentException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Tên khách hàng không được để trống.");
        }
        
        return new Customer(id, name, email, phone);
    }

    /** Hiển thị danh sách khách hàng. */
    private void listCustomers(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        List<Customer> listCustomers = customerService.getAllCustomers();
        request.setAttribute("listCustomers", listCustomers);
        // Sửa lỗi đường dẫn: Trỏ trực tiếp đến JSP
        request.getRequestDispatcher("/customers.jsp").forward(request, response);
    }

    /** Hiển thị form thêm khách hàng mới. */
         private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    request.setAttribute("action", "insert");
    request.setAttribute("customer", new Customer()); // Pass empty object
    
    // ACTION POINT: Verify this path and ensure the JSP file exists in the Web Pages folder.
    request.getRequestDispatcher("/customer-form.jsp").forward(request, response);
}
    /** Hiển thị form chỉnh sửa khách hàng. */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Customer existingCustomer = customerService.getCustomerById(id);
            request.setAttribute("customer", existingCustomer);
            request.setAttribute("action", "update");
            request.getRequestDispatcher("/customer-form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            throw new SQLException("ID khách hàng không hợp lệ.");
        }
    }

    /** Xử lý Insert khách hàng mới. */
    private void insertCustomer(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, IllegalArgumentException {
        Customer newCustomer = extractCustomerFromRequest(request, 0); // ID = 0 cho Insert
        customerService.saveCustomer(newCustomer);
        response.sendRedirect("customers?action=list");
    }

    /** Xử lý Update thông tin khách hàng. */
   // Trong controller/CustomerServlet.java

/** Xử lý Update thông tin khách hàng. */
private void updateCustomer(HttpServletRequest request, HttpServletResponse response) 
        throws SQLException, IOException, IllegalArgumentException {
    
    int id = Integer.parseInt(request.getParameter("id"));
    Customer customer = extractCustomerFromRequest(request, id);
    customerService.updateCustomer(customer); // Dòng 134
    response.sendRedirect("customers?action=list");
    // Dòng 136: BỎ dấu ngoặc nhọn nếu nó là dấu đóng của updateCustomer, nếu không, đây là lỗi cú pháp
}

// Xử lý Delete khách hàng. (Đã sửa lỗi khai báo throws)
private void deleteCustomer(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException, SQLException { // ĐÃ THÊM throws SQLException
    try {
        int id = Integer.parseInt(request.getParameter("id"));
        customerService.deleteCustomer(id);
        response.sendRedirect("customers?action=list");
    } catch (NumberFormatException e) {
        // Ném SQLException vì lỗi ID không thể xử lý tiếp tục
        throw new SQLException("ID khách hàng không hợp lệ khi xóa."); 
    } 
    // Nếu có lỗi khác (ví dụ: SQLException từ Service), nó sẽ được bắt ở doPost/doGet
}
}