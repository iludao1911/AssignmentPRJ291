package dao;

import model.Medicine;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicineDAO { 
    private static final String SELECT_ALL = "SELECT * FROM Medicine";
    private static final String SELECT_BY_ID = "SELECT * FROM Medicine WHERE Medicine_id = ?";
    private static final String INSERT_SQL = "INSERT INTO Medicine (Supplier_id, name, description, price, quantity, category, expiry_date, image_path, sale_price) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_SQL = "UPDATE Medicine SET Supplier_id = ?, name = ?, description = ?, price = ?, quantity = ?, category = ?, expiry_date = ?, image_path = ?, sale_price = ? WHERE Medicine_id = ?";
    private static final String DELETE_SQL = "DELETE FROM Medicine WHERE Medicine_id = ?";
    private static final String UPDATE_QUANTITY_SQL = "UPDATE Medicine SET quantity = ? WHERE Medicine_id = ?";

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
        try {
            medicine.setSalePrice(rs.getBigDecimal("sale_price"));
        } catch (SQLException e) {
            medicine.setSalePrice(null);
        }
        return medicine;
    }

    // --- NON-TRANSACTIONAL CRUD ---
    public List<Medicine> getAllMedicines() throws SQLException {
        List<Medicine> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_ALL); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractMedicineFromResultSet(rs));
            }
        }
        return list;
    }

    private String getOrderByClause(String sortOrder) {
        if (sortOrder == null) {
            return " ORDER BY Medicine_id";
        }
        switch (sortOrder) {
            case "price_asc":
                return " ORDER BY price ASC";
            case "price_desc":
                return " ORDER BY price DESC";
            default:
                return " ORDER BY Medicine_id";
        }
    }

    public List<Medicine> getMedicines(int offset, int limit, String sortOrder) throws SQLException {
        List<Medicine> list = new ArrayList<>();
        String sql = SELECT_ALL + getOrderByClause(sortOrder) + " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractMedicineFromResultSet(rs));
                }
            }
        }
        return list;
    }

    public int getTotalMedicineCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Medicine";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<Medicine> searchMedicinesByName(String name, int offset, int limit, String sortOrder) throws SQLException {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT * FROM Medicine WHERE name LIKE ?" + getOrderByClause(sortOrder) + " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + name + "%");
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractMedicineFromResultSet(rs));
                }
            }
        }
        return list;
    }

    public int getSearchTotalCount(String name) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Medicine WHERE name LIKE ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + name + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public List<String> getDistinctCategories() throws SQLException {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM Medicine WHERE category IS NOT NULL AND category != '' ORDER BY category";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                categories.add(rs.getString("category"));
            }
        }
        return categories;
    }

    public List<Medicine> getMedicinesByCategory(String category, int offset, int limit, String sortOrder) throws SQLException {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT * FROM Medicine WHERE category = ?" + getOrderByClause(sortOrder) + " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractMedicineFromResultSet(rs));
                }
            }
        }
        return list;
    }

    public int getTotalCountByCategory(String category) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Medicine WHERE category = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    public Medicine getMedicineById(int id) throws SQLException {
        return getMedicineById(DBConnection.getConnection(), id); // Dùng phiên bản transactional cho tính nhất quán
    }
    
    public void insertMedicine(Medicine medicine) throws SQLException {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {
            ps.setInt(1, medicine.getSupplierId());
            ps.setString(2, medicine.getName());
            ps.setString(3, medicine.getDescription());
            ps.setBigDecimal(4, medicine.getPrice());
            ps.setInt(5, medicine.getQuantity());
            ps.setString(6, medicine.getCategory());
            ps.setDate(7, medicine.getExpiryDate());
            ps.setString(8, medicine.getImagePath());
            ps.setBigDecimal(9, medicine.getSalePrice());
            ps.executeUpdate();
        }
    }
    
    public boolean updateMedicine(Medicine medicine) throws SQLException {
        boolean rowUpdated;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(UPDATE_SQL)) {
            ps.setInt(1, medicine.getSupplierId());
            ps.setString(2, medicine.getName());
            ps.setString(3, medicine.getDescription());
            ps.setBigDecimal(4, medicine.getPrice());
            ps.setInt(5, medicine.getQuantity());
            ps.setString(6, medicine.getCategory());
            ps.setDate(7, medicine.getExpiryDate());
            ps.setString(8, medicine.getImagePath());
            ps.setBigDecimal(9, medicine.getSalePrice());
            ps.setInt(10, medicine.getMedicineId());
            rowUpdated = ps.executeUpdate() > 0;
        }
        return rowUpdated;
    }
    
    public boolean deleteMedicine(int id) throws SQLException {
        boolean rowDeleted;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(DELETE_SQL)) {
            ps.setInt(1, id);
            rowDeleted = ps.executeUpdate() > 0;
        }
        return rowDeleted;
    }
    
    // --- TRANSACTIONAL METHODS (Dùng cho Order Service) ---
    public Medicine getMedicineById(Connection conn, int id) throws SQLException {
        Medicine medicine = null;
        try (PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    medicine = extractMedicineFromResultSet(rs);
                }
            }
        }
        return medicine;
    }

    public boolean updateQuantity(Connection conn, int medicineId, int newQuantity) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(UPDATE_QUANTITY_SQL)) {
            ps.setInt(1, newQuantity);
            ps.setInt(2, medicineId);
            return ps.executeUpdate() > 0;
        }
    }
}