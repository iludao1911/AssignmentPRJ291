package service;

import model.Customer;
import java.sql.SQLException;
import java.util.List;

public interface ICustomerService {
    List<Customer> getAllCustomers() throws SQLException;
    Customer getCustomerById(int id) throws SQLException;
    void saveCustomer(Customer customer) throws SQLException, IllegalArgumentException;
    boolean updateCustomer(Customer customer) throws SQLException, IllegalArgumentException;
    boolean deleteCustomer(int id) throws SQLException;
    
    // PHƯƠNG THỨC XÁC THỰC VÀ PHÂN QUYỀN
    Customer validateCustomer(String email, String password) throws SQLException;
    Customer getAdminAccount() throws SQLException;
    boolean isEmailExists(String email) throws SQLException;
    Customer findByEmail(String email) throws SQLException;
}