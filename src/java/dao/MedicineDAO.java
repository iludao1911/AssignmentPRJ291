package dao;

import model.Medicine;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicineDAO {

    private static final String SELECT_ALL = "SELECT * FROM Medicine";
    private static final String SELECT_BY_ID = "SELECT * FROM Medicine WHERE Medicine_id = ?";
    private static final String INSERT_SQL = "INSERT INTO Medicine (Supplier_id, name, description, price, quantity, category, expiry_date, image_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_SQL = "UPDATE Medicine SET Supplier_id = ?, name = ?, description = ?, price = ?, quantity = ?, category = ?, expiry_date = ?, image_path = ? WHERE Medicine_id = ?";
    private static final String DELETE_SQL = "DELETE FROM Medicine WHERE Medicine_id = ?";
    private static final String UPDATE_QUANTITY_SQL = "UPDATE Medicine SET quantity = ? WHERE Medicine_id = ?";

    // Chuyển ResultSet -> Object Medicine
    private Medicine extractMedicineFromResultSet(ResultSet rs) throws SQLException {
        Medicine medicine = new Medicine();
        medicine.setMedicineId(rs.getInt("Medicine_id"));
        medicine.setSupplierId(rs.getInt("Supplier_id"));
        medicine.setName(rs.getString("name"));
        medicine.setDescription(rs.getString("description"));
        medicine.setPrice(rs.getBigDecimal("price"));
        medicine.setQuantity(rs.getInt("quantity"));
        medicine.setCategory(rs.getString("category"));
        medicine.setExpiryDate(rs.getDate("expiry_date"));
        medicine.setImagePath(rs.getString("image_path"));
        return medicine;
    }

    // --- LẤY TẤT CẢ ---
    public List<Medicine> getAllMedicines() throws SQLException {
        List<Medicine> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(extractMedicineFromResultSet(rs));
            }
        }
        return list;
    }

    // --- LẤY 1 THUỐC THEO ID ---
    public Medicine getMedicineById(int id) throws SQLException {
        Medicine medicine = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    medicine = extractMedicineFromResultSet(rs);
                }
            }
        }
        return medicine;
    }

    // --- THÊM ---
    public void insertMedicine(Medicine medicine) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {

            ps.setInt(1, medicine.getSupplierId());
            ps.setString(2, medicine.getName());
            ps.setString(3, medicine.getDescription());
            ps.setBigDecimal(4, medicine.getPrice());
            ps.setInt(5, medicine.getQuantity());
            ps.setString(6, medicine.getCategory());
            ps.setDate(7, medicine.getExpiryDate());
            ps.setString(8, medicine.getImagePath());
            ps.executeUpdate();
        }
    }

    // --- CẬP NHẬT ---
    public boolean updateMedicine(Medicine medicine) throws SQLException {
        boolean rowUpdated;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_SQL)) {

            ps.setInt(1, medicine.getSupplierId());
            ps.setString(2, medicine.getName());
            ps.setString(3, medicine.getDescription());
            ps.setBigDecimal(4, medicine.getPrice());
            ps.setInt(5, medicine.getQuantity());
            ps.setString(6, medicine.getCategory());
            ps.setDate(7, medicine.getExpiryDate());
            ps.setString(8, medicine.getImagePath());
            ps.setInt(9, medicine.getMedicineId());
            rowUpdated = ps.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    // --- XÓA ---
    public boolean deleteMedicine(int id) throws SQLException {
        boolean rowDeleted;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_SQL)) {

            ps.setInt(1, id);
            rowDeleted = ps.executeUpdate() > 0;
        }
        return rowDeleted;
    }

    // --- CẬP NHẬT SỐ LƯỢNG ---
    public boolean updateQuantity(int medicineId, int newQuantity) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_QUANTITY_SQL)) {

            ps.setInt(1, newQuantity);
            ps.setInt(2, medicineId);
            return ps.executeUpdate() > 0;
        }
    }
}
