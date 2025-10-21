package controller;



import dao.MedicineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Medicine;
import service.IMedicineService;
import service.MedicineServiceImpl;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/customers")
public class CustomerServlet extends HttpServlet {

    private IMedicineService medicineService; 

    @Override
    public void init() throws ServletException {
        this.medicineService = new MedicineServiceImpl(new MedicineDAO()); 
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // KIỂM TRA PHÂN QUYỀN VÀ BẢO VỆ: Chỉ cho phép truy cập nếu là KHÁCH HÀNG đã đăng nhập
        if (request.getSession().getAttribute("currentCustomer") == null) {
            // Nếu session KHÔNG có Khách hàng, chuyển hướng đến trang đăng nhập Khách hàng.
            response.sendRedirect("customerLogin"); 
            return; // Dừng xử lý
        }
        
        try {
            // Khách hàng đăng nhập thành công: HIỂN THỊ DANH SÁCH THUỐC
            List<Medicine> listMedicines = medicineService.getAllMedicines();
            request.setAttribute("listMedicines", listMedicines);
            
            // CHUYỂN TIẾP (FORWARD) đến JSP để hiển thị, KHÔNG DÙNG REDIRECT
            request.getRequestDispatcher("/customer-view-products.jsp").forward(request, response); 
            
        } catch (SQLException ex) {
            request.setAttribute("error", "Không thể tải danh sách thuốc: " + ex.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    // KHÔNG CÓ doPost (Không có CRUD)
}