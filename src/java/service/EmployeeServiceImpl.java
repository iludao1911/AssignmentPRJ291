package service;


import dao.EmployeeDAO; 


import model.Employee; 

import java.sql.SQLException;


public class EmployeeServiceImpl implements IEmployeeService {
    private final EmployeeDAO employeeDAO;

    public EmployeeServiceImpl(EmployeeDAO employeeDAO) {
        this.employeeDAO = employeeDAO;
    }

    @Override
    public Employee validateEmployee(String username, String password) throws SQLException {
        Employee employee = employeeDAO.getEmployeeByUsername(username);
        
        // CẢNH BÁO BẢO MẬT: So sánh Plain Text - Cần dùng Hashing!
        if (employee != null && employee.getPassword().equals(password)) {
            return employee;
        }
        return null;
    }

    @Override
    public void registerEmployee(Employee employee) throws SQLException, IllegalArgumentException {
        if (employee.getUsername() == null || employee.getUsername().isEmpty()) {
            throw new IllegalArgumentException("Tên đăng nhập không được để trống.");
        }
        if (employeeDAO.getEmployeeByUsername(employee.getUsername()) != null) {
            throw new IllegalArgumentException("Tên đăng nhập đã tồn tại.");
        }
        employeeDAO.insertEmployee(employee);
    }
}