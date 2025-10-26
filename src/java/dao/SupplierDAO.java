package dao;

import model.Supplier;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SupplierDAO {
    private static final String SELECT_ALL = "SELECT * FROM Supplier";
    private static final String SELECT_BY_ID = "SELECT * FROM Supplier WHERE Supplier_id = ?";
    private static final String INSERT_SQL = "INSERT INTO Supplier (name, address, phone, email) VALUES (?, ?, ?, ?)";
    private static final String UPDATE_SQL = "UPDATE Supplier SET name = ?, address = ?, phone = ?, email = ? WHERE Supplier_id = ?";
    private static final String DELETE_SQL = "DELETE FROM Supplier WHERE Supplier_id = ?";

    private Supplier extractSupplierFromResultSet(ResultSet rs) throws SQLException {
        Supplier supplier = new Supplier();
        supplier.setSupplierId(rs.getInt("Supplier_id"));
        supplier.setName(rs.getString("name"));
        supplier.setAddress(rs.getString("address"));
        supplier.setPhone(rs.getString("phone"));
        supplier.setEmail(rs.getString("email"));
        return supplier;
    }

    public List<Supplier> getAllSuppliers() throws SQLException {
        List<Supplier> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_ALL); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractSupplierFromResultSet(rs));
            }
        }
        return list;
    }
    
    public Supplier getSupplierById(int id) throws SQLException {
        Supplier supplier = null;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    supplier = extractSupplierFromResultSet(rs);
                }
            }
        }
        return supplier;
    }
    
    public void insertSupplier(Supplier supplier) throws SQLException {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {
            ps.setString(1, supplier.getName());
            ps.setString(2, supplier.getAddress());
            ps.setString(3, supplier.getPhone());
            ps.setString(4, supplier.getEmail());
            ps.executeUpdate();
        }
    }
    
    public boolean updateSupplier(Supplier supplier) throws SQLException {
        boolean rowUpdated;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(UPDATE_SQL)) {
            ps.setString(1, supplier.getName());
            ps.setString(2, supplier.getAddress());
            ps.setString(3, supplier.getPhone());
            ps.setString(4, supplier.getEmail());
            ps.setInt(5, supplier.getSupplierId());
            rowUpdated = ps.executeUpdate() > 0;
        }
        return rowUpdated;
    }
    
    public boolean deleteSupplier(int id) throws SQLException {
        boolean rowDeleted;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(DELETE_SQL)) {
            ps.setInt(1, id);
            rowDeleted = ps.executeUpdate() > 0;
        }
        return rowDeleted;
    }
}