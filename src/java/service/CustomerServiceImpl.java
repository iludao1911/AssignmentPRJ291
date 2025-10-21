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

    // --- PHƯƠNG THỨC XÁC THỰC (MỚI) ---
    @Override
    public Customer validateCustomer(String name, String password) throws SQLException {
        if (name == null || password == null || name.isEmpty() || password.isEmpty()) {
             throw new IllegalArgumentException("Vui lòng nhập đầy đủ thông tin.");
        }
        return customerDAO.getCustomerByNameAndPassword(name, password); 
    }
    
    // --- CÁC PHƯƠNG THỨC CRUD KHÁC (Giữ nguyên logic) ---
    @Override public List<Customer> getAllCustomers() throws SQLException { /* ... */ return null; }
    @Override public Customer getCustomerById(int id) throws SQLException { /* ... */ return null; }
    @Override public void saveCustomer(Customer customer) throws SQLException, IllegalArgumentException { /* ... */ }
    @Override public boolean updateCustomer(Customer customer) throws SQLException, IllegalArgumentException { /* ... */ return false; }
    @Override public boolean deleteCustomer(int id) throws SQLException { /* ... */ return false; }
}