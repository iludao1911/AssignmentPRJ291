package service;

import model.Medicine;
import java.util.List;
import java.sql.SQLException;

public interface IMedicineService {
    List<Medicine> getAllMedicines() throws SQLException;
    List<Medicine> getMedicines(int offset, int limit, String sortOrder) throws SQLException;
    int getTotalMedicineCount() throws SQLException;
    Medicine getMedicineById(int id) throws SQLException;
    void saveMedicine(Medicine medicine) throws SQLException, IllegalArgumentException; 
    boolean updateMedicine(Medicine medicine) throws SQLException, IllegalArgumentException; 
    boolean deleteMedicine(int id) throws SQLException;
    List<Medicine> searchMedicines(String keyword, int offset, int limit, String sortOrder) throws SQLException;
    int getSearchTotalCount(String keyword) throws SQLException;
    void checkExpiryDate();
    List<String> getDistinctCategories() throws SQLException;
    List<Medicine> getMedicinesByCategory(String category, int offset, int limit, String sortOrder) throws SQLException;
    int getTotalCountByCategory(String category) throws SQLException;
}