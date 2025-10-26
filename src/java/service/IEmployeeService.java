package service;

import model.Employee;
import java.sql.SQLException;

public interface IEmployeeService {
    Employee validateEmployee(String username, String password) throws SQLException;
    void registerEmployee(Employee employee) throws SQLException, IllegalArgumentException;
}