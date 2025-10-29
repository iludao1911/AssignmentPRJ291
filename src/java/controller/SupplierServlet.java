package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.SupplierDAO;
import model.Supplier;
import service.ISupplierService;
import service.SupplierServiceImpl;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/suppliers")
public class SupplierServlet extends HttpServlet {

    private ISupplierService supplierService;

    @Override
    public void init() throws ServletException {
        this.supplierService = new SupplierServiceImpl(new SupplierDAO()); 
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            if ("new".equals(action)) showNewForm(request, response);
            else if ("delete".equals(action)) deleteSupplier(request, response);
            else if ("edit".equals(action)) showEditForm(request, response);
            else listSuppliers(request, response);
        } catch (SQLException ex) {
            request.setAttribute("error", "Lỗi CSDL: " + ex.getMessage());
            request.getRequestDispatcher("/suppliers.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        request.setCharacterEncoding("UTF-8"); 

        try {
            if ("insert".equals(action)) insertSupplier(request, response);
            else if ("update".equals(action)) updateSupplier(request, response);
            else listSuppliers(request, response);
        } catch (SQLException | IllegalArgumentException ex) {
            request.setAttribute("error", ex.getMessage());
            request.getRequestDispatcher("/suppliers.jsp").forward(request, response); 
        }
    }

    // --- Phương thức Helper (extract, list, showForm, insert, update, delete) ---
    private Supplier extractSupplierFromRequest(HttpServletRequest request, int id) throws IllegalArgumentException {
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        return new Supplier(id, name, address, phone, email);
    }
    
    private void listSuppliers(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        // CHUYỂN HƯỚNG NẾU KHÔNG ĐĂNG NHẬP (Cho phép Employee hoặc Customer xem)
        if (request.getSession().getAttribute("currentCustomer") == null
                && request.getSession().getAttribute("currentEmployee") == null) {
            response.sendRedirect("customerLogin");
            return;
        }

        List<Supplier> listSuppliers = supplierService.getAllSuppliers();
        request.setAttribute("listSuppliers", listSuppliers);
        request.getRequestDispatcher("/suppliers.jsp").forward(request, response);
    }
    
// Trong SupplierServlet.java
private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    request.setAttribute("action", "insert"); 
    request.setAttribute("supplier", new Supplier()); 
    // Dòng lỗi tiềm ẩn:
    request.getRequestDispatcher("/supplier-form.jsp").forward(request, response); 
}
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Supplier existingSupplier = supplierService.getSupplierById(id);
        request.setAttribute("supplier", existingSupplier);
        request.setAttribute("action", "update");
        request.getRequestDispatcher("/supplier-form.jsp").forward(request, response);
    }

    private void insertSupplier(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, IllegalArgumentException {
        Supplier newSupplier = extractSupplierFromRequest(request, 0); 
        supplierService.saveSupplier(newSupplier); 
        response.sendRedirect(request.getContextPath() + "/suppliers?action=list");
    }

    private void updateSupplier(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, IllegalArgumentException {
        int id = Integer.parseInt(request.getParameter("id"));
        Supplier supplier = extractSupplierFromRequest(request, id); 
        supplierService.updateSupplier(supplier); 
        response.sendRedirect(request.getContextPath() + "/suppliers?action=list");
    }

    private void deleteSupplier(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        supplierService.deleteSupplier(id);
        response.sendRedirect(request.getContextPath() + "/suppliers?action=list");
    }
}