/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dao.SupplierDAO;
import java.util.List;
import model.Supplier;
import java.sql.SQLException;
/**
 *
 * @author khoa
 */
public class SupplierServiceImpl implements ISupplierService {
    private final SupplierDAO supplierDAO;

    public SupplierServiceImpl(SupplierDAO supplierDAO) {
        this.supplierDAO = supplierDAO;
    }

    @Override
    public List<Supplier> getAllSuppliers() throws SQLException { return supplierDAO.getAllSuppliers(); }

    @Override
    public Supplier getSupplierById(int id) throws SQLException { return supplierDAO.getSupplierById(id); }

    @Override
    public void saveSupplier(Supplier supplier) throws SQLException, IllegalArgumentException {
        if (supplier.getName() == null || supplier.getName().isEmpty()) {
            throw new IllegalArgumentException("Tên nhà cung cấp không được để trống.");
        }
        supplierDAO.insertSupplier(supplier);
    }

    @Override
    public boolean updateSupplier(Supplier supplier) throws SQLException, IllegalArgumentException {
        if (supplier.getSupplierId() <= 0) {
            throw new IllegalArgumentException("ID nhà cung cấp không hợp lệ.");
        }
        return supplierDAO.updateSupplier(supplier);
    }

    @Override
    public boolean deleteSupplier(int id) throws SQLException {
        if (id <= 0) { throw new IllegalArgumentException("ID nhà cung cấp không hợp lệ."); }
        return supplierDAO.deleteSupplier(id);
    }
}
