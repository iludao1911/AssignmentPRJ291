package dao;

import model.Employee;
import java.sql.*;

public class EmployeeDAO { 
    private static final String SELECT_BY_USERNAME = "SELECT * FROM Employee WHERE username = ?";
    private static final String INSERT_SQL = "INSERT INTO Employee (username, password, full_name, role) VALUES (?, ?, ?, ?)";
    
    private Employee extractEmployeeFromResultSet(ResultSet rs) throws SQLException {
        Employee employee = new Employee();
        employee.setEmployeeId(rs.getInt("Employee_id"));
        employee.setUsername(rs.getString("username"));
        employee.setPassword(rs.getString("password"));
        employee.setFullName(rs.getString("full_name"));
        employee.setRole(rs.getString("role"));
        return employee;
    }

    public Employee getEmployeeByUsername(String username) throws SQLException {
        Employee employee = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_USERNAME)) {
            
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    employee = extractEmployeeFromResultSet(rs);
                }
            }
        }
        return employee;
    }

    public void insertEmployee(Employee employee) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {
            
            ps.setString(1, employee.getUsername());
            // LƯU Ý BẢO MẬT: Mật khẩu nên được băm (hash) trước khi insert.
            ps.setString(2, employee.getPassword()); 
            ps.setString(3, employee.getFullName());
            ps.setString(4, employee.getRole());
            ps.executeUpdate();
        }
    }
}