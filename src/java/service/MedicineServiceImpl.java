package service;

import dao.MedicineDAO;
import model.Medicine;
import java.sql.SQLException;
import java.util.List;

public class MedicineServiceImpl implements IMedicineService {

    private final MedicineDAO medicineDAO;

    public MedicineServiceImpl(MedicineDAO medicineDAO) {
        this.medicineDAO = medicineDAO;
    }

    @Override
    public List<Medicine> getAllMedicines() throws SQLException { return medicineDAO.getAllMedicines(); }

    @Override
    public List<Medicine> getMedicines(int offset, int limit, String sortOrder) throws SQLException {
        return medicineDAO.getMedicines(offset, limit, sortOrder);
    }

    @Override
    public int getTotalMedicineCount() throws SQLException {
        return medicineDAO.getTotalMedicineCount();
    }

    @Override
    public Medicine getMedicineById(int id) throws SQLException { return medicineDAO.getMedicineById(id); }
    
    @Override
    public void saveMedicine(Medicine medicine) throws SQLException, IllegalArgumentException {
        if (medicine.getPrice() == null || medicine.getPrice().signum() <= 0 || medicine.getQuantity() < 0) {
            throw new IllegalArgumentException("Giá hoặc số lượng không hợp lệ."); 
        }
        medicineDAO.insertMedicine(medicine);
    }

    @Override
    public boolean updateMedicine(Medicine medicine) throws SQLException, IllegalArgumentException {
        if (medicine.getMedicineId() <= 0) {
            throw new IllegalArgumentException("ID thuốc không hợp lệ cho việc cập nhật.");
        }
        if (medicine.getPrice() == null || medicine.getPrice().signum() <= 0 || medicine.getQuantity() < 0) {
            throw new IllegalArgumentException("Giá hoặc số lượng không hợp lệ.");
        }
        return medicineDAO.updateMedicine(medicine);
    }

    @Override
    public boolean deleteMedicine(int id) throws SQLException { return medicineDAO.deleteMedicine(id); }

    @Override
    public List<Medicine> searchMedicines(String keyword, int offset, int limit, String sortOrder) throws SQLException {
        return medicineDAO.searchMedicinesByName(keyword, offset, limit, sortOrder);
    }

    @Override
    public int getSearchTotalCount(String keyword) throws SQLException {
        return medicineDAO.getSearchTotalCount(keyword);
    }

    @Override
    public void checkExpiryDate() { /* Logic nghiệp vụ kiểm tra ngày hết hạn */ }

    @Override
    public List<String> getDistinctCategories() throws SQLException {
        return medicineDAO.getDistinctCategories();
    }

    @Override
    public List<Medicine> getMedicinesByCategory(String category, int offset, int limit, String sortOrder) throws SQLException {
        return medicineDAO.getMedicinesByCategory(category, offset, limit, sortOrder);
    }

    @Override
    public int getTotalCountByCategory(String category) throws SQLException {
        return medicineDAO.getTotalCountByCategory(category);
    }
}