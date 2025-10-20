package service;

import dao.CustomerDAO;
import model.Customer;
import java.sql.SQLException;
import java.util.List;

public interface ICustomerService {
    List<Customer> getAllCustomers() throws SQLException;
    Customer getCustomerById(int id) throws SQLException;
    void saveCustomer(Customer customer) throws SQLException, IllegalArgumentException;
    boolean updateCustomer(Customer customer) throws SQLException, IllegalArgumentException; // Phương thức cập nhật
    boolean deleteCustomer(int id) throws SQLException; // Phương thức xóa
}