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
    
    // SỬ DỤNG NAME ĐỂ XÁC THỰC
    Customer validateCustomer(String name, String password) throws SQLException; 
}