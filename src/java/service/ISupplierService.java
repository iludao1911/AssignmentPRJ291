package service;

import dao.SupplierDAO;
import model.Supplier;
import java.sql.SQLException;
import java.util.List;

public interface ISupplierService {
    List<Supplier> getAllSuppliers() throws SQLException;
    Supplier getSupplierById(int id) throws SQLException;
    void saveSupplier(Supplier supplier) throws SQLException, IllegalArgumentException;
    boolean updateSupplier(Supplier supplier) throws SQLException, IllegalArgumentException;
    boolean deleteSupplier(int id) throws SQLException;
}