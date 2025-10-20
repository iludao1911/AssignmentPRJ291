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
    public List<Customer> getAllCustomers() throws SQLException {
        return customerDAO.getAllCustomers();
    }

    @Override
    public Customer getCustomerById(int id) throws SQLException {
        return customerDAO.getCustomerById(id);
    }

    @Override
    public void saveCustomer(Customer customer) throws SQLException, IllegalArgumentException {
        if (customer.getName() == null || customer.getName().isEmpty()) {
            throw new IllegalArgumentException("Tên khách hàng không được để trống.");
        }
        // Thêm các validation khác cho email, phone nếu cần
        customerDAO.insertCustomer(customer);
    }
    
    @Override
    public boolean updateCustomer(Customer customer) throws SQLException, IllegalArgumentException {
        if (customer.getCustomerId() <= 0) {
            throw new IllegalArgumentException("ID khách hàng không hợp lệ cho việc cập nhật.");
        }
        if (customer.getName() == null || customer.getName().isEmpty()) {
            throw new IllegalArgumentException("Tên khách hàng không được để trống.");
        }
        return customerDAO.updateCustomer(customer);
    }

    @Override
    public boolean deleteCustomer(int id) throws SQLException {
        if (id <= 0) {
            throw new IllegalArgumentException("ID khách hàng không hợp lệ cho việc xóa.");
        }
        // Bạn có thể thêm logic kiểm tra rằng buộc khóa ngoại (ví dụ: khách hàng có đơn hàng không) tại đây.
        return customerDAO.deleteCustomer(id);
    }
}