package service;

import model.Medicine;
import java.util.List;
import java.sql.SQLException;

public interface IMedicineService {
    List<Medicine> getAllMedicines() throws SQLException;
    Medicine getMedicineById(int id) throws SQLException;
    void saveMedicine(Medicine medicine) throws SQLException, IllegalArgumentException; 
    boolean updateMedicine(Medicine medicine) throws SQLException, IllegalArgumentException; 
    boolean deleteMedicine(int id) throws SQLException;
    List<Medicine> searchMedicines(String keyword) throws SQLException;
    void checkExpiryDate();
}