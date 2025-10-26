package controller;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.MedicineDAO;
import model.Medicine;
import service.IMedicineService;
import service.MedicineServiceImpl;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/medicines")
public class MedicineServlet extends HttpServlet {

    private IMedicineService medicineService;

    @Override
    public void init() throws ServletException {
        this.medicineService = new MedicineServiceImpl(new MedicineDAO());
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            if ("new".equals(action)) showNewForm(request, response);
            else if ("delete".equals(action)) deleteMedicine(request, response);
            else if ("edit".equals(action)) showEditForm(request, response);
            else listMedicines(request, response);
        } catch (SQLException ex) {
            request.setAttribute("error", "Lỗi CSDL: " + ex.getMessage());
            request.getRequestDispatcher("/products.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        request.setCharacterEncoding("UTF-8"); 

        try {
            if ("insert".equals(action)) insertMedicine(request, response);
            else if ("update".equals(action)) updateMedicine(request, response);
            else listMedicines(request, response);
        } catch (SQLException | IllegalArgumentException ex) {
            request.setAttribute("error", ex.getMessage());
            request.getRequestDispatcher("/product-form.jsp").forward(request, response); // Forward về form để sửa
        }
    }

    // --- Phương thức Helper (extract, list, showForm, insert, update, delete) ---
    private Medicine extractMedicineFromRequest(HttpServletRequest request, int id) throws IllegalArgumentException {
        try {
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String category = request.getParameter("category");
            Date expiryDate = Date.valueOf(request.getParameter("expiryDate"));
            String imagePath = request.getParameter("imagePath");
            return new Medicine(id, supplierId, name, description, price, quantity, category, expiryDate, imagePath);
        } catch (Exception e) {
            throw new IllegalArgumentException("Lỗi nhập dữ liệu: Giá trị số hoặc ngày không hợp lệ.");
        }
    }
    
    private void listMedicines(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        List<Medicine> listMedicines = medicineService.getAllMedicines();
        request.setAttribute("listMedicines", listMedicines);
        request.getRequestDispatcher("/products.jsp").forward(request, response);
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("action", "insert");
        request.setAttribute("medicine", new Medicine());
        request.getRequestDispatcher("/product-form.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Medicine existingMedicine = medicineService.getMedicineById(id);
        request.setAttribute("medicine", existingMedicine);
        request.setAttribute("action", "update");
        request.getRequestDispatcher("/product-form.jsp").forward(request, response);
    }

    private void insertMedicine(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, IllegalArgumentException {
        Medicine newMedicine = extractMedicineFromRequest(request, 0); 
        medicineService.saveMedicine(newMedicine); 
        response.sendRedirect("medicines?action=list");
    }

    private void updateMedicine(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, IllegalArgumentException {
        int id = Integer.parseInt(request.getParameter("id"));
        Medicine medicine = extractMedicineFromRequest(request, id); 
        medicineService.updateMedicine(medicine); 
        response.sendRedirect("medicines?action=list");
    }

    private void deleteMedicine(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        medicineService.deleteMedicine(id);
        response.sendRedirect("medicines?action=list");
    }
}