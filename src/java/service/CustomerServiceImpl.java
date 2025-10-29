package service;

import dao.CustomerDAO;
import model.Customer;
import java.sql.SQLException;
import java.util.List;

public class CustomerServiceImpl implements ICustomerService {
    
    private final CustomerDAO customerDAO;

    public CustomerServiceImpl(CustomerDAO customerDAO) {
        this.customerDAO = customerDAO;
    }

    @Override
    public Customer validateCustomer(String email, String password) throws SQLException {
        if (email == null || password == null || email.isEmpty() || password.isEmpty()) {
             throw new IllegalArgumentException("Vui lòng nhập đầy đủ thông tin.");
        }
        return customerDAO.getCustomerByEmailAndPassword(email, password);
    }

    @Override
    public Customer getAdminAccount() throws SQLException {
        return customerDAO.getAdminAccount();
    }

    @Override
    public boolean isEmailExists(String email) throws SQLException {
        if (email == null || email.isEmpty()) {
            throw new IllegalArgumentException("Email không được để trống.");
        }
        return customerDAO.isEmailExists(email);
    }
    
    // --- CÁC PHƯƠNG THỨC CRUD KHÁC ---
    @Override
    public List<Customer> getAllCustomers() throws SQLException {
        return customerDAO.getAllCustomers();
    }

    @Override
    public Customer getCustomerById(int id) throws SQLException {
        return customerDAO.getCustomerById(id);
    }

    @Override
    public void saveCustomer(Customer customer) throws SQLException, IllegalArgumentException {
        if (customer == null) throw new IllegalArgumentException("Customer is null");
        
        if (customer.getName() == null || customer.getName().isEmpty()) {
            throw new IllegalArgumentException("Tên không được để trống");
        }
        
        if (customer.getEmail() == null || customer.getEmail().isEmpty()) {
            throw new IllegalArgumentException("Email không được để trống");
        }
        
        if (customer.getPassword() == null || customer.getPassword().isEmpty()) {
            throw new IllegalArgumentException("Mật khẩu không được để trống");
        }
        
        // Kiểm tra email đã tồn tại chưa
        if (isEmailExists(customer.getEmail())) {
            throw new IllegalArgumentException("Email đã được sử dụng");
        }
        
        // Set role mặc định là USER
        if (customer.getRole() == null || customer.getRole().isEmpty()) {
            customer.setRole("Customer");
        }
        if (customer.getName() == null || customer.getName().isEmpty()) {
            throw new IllegalArgumentException("Tên khách hàng không được để trống.");
        }
        if (customer.getPassword() == null || customer.getPassword().isEmpty()) {
            throw new IllegalArgumentException("Mật khẩu không được để trống.");
        }

        // Một số kiểm tra đơn giản: email/phone có thể để trống tùy yêu cầu
        customerDAO.insertCustomer(customer);
    }

    @Override
    public boolean updateCustomer(Customer customer) throws SQLException, IllegalArgumentException {
        if (customer == null || customer.getCustomerId() <= 0) throw new IllegalArgumentException("Customer không hợp lệ.");
        return customerDAO.updateCustomer(customer);
    }

    @Override
    public boolean deleteCustomer(int id) throws SQLException {
        return customerDAO.deleteCustomer(id);
    }

    // Phương thức hỗ trợ quên mật khẩu
    public Customer findByEmail(String email) throws SQLException {
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email không được để trống");
        }
        return customerDAO.findByEmail(email);
    }

    public boolean updatePassword(int customerId, String newPassword) throws SQLException {
        if (newPassword == null || newPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("Mật khẩu mới không được để trống");
        }
        return customerDAO.updatePassword(customerId, newPassword);
    }
    public Customer validateCustomerById(int id, String password) throws SQLException {
        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Mật khẩu không được để trống");
        }
        Customer c = customerDAO.getCustomerById(id);
        if (c != null && c.getPassword() != null && c.getPassword().equals(password)) {
            return c;
        }
        return null;
    }
}