package controller;

import dao.CartDAO;
import dao.MedicineDAO;
import model.User;
import model.Medicine;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "CartUpdateServlet", urlPatterns = {"/cart-update"})
public class CartUpdateServlet extends HttpServlet {
    
    private CartDAO cartDAO;
    private MedicineDAO medicineDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        medicineDAO = new MedicineDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Check login
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("currentUser") == null) {
                result.put("success", false);
                result.put("message", "Vui lòng đăng nhập");
                out.print(gson.toJson(result));
                return;
            }
            
            User currentUser = (User) session.getAttribute("currentUser");
            int userId = currentUser.getUserId();
            
            String action = request.getParameter("action");
            String medicineIdStr = request.getParameter("medicineId");
            
            if (medicineIdStr == null || medicineIdStr.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "Thiếu thông tin sản phẩm");
                out.print(gson.toJson(result));
                return;
            }
            
            int medicineId = Integer.parseInt(medicineIdStr);
            
            if ("update".equals(action)) {
                String quantityStr = request.getParameter("quantity");
                if (quantityStr == null || quantityStr.trim().isEmpty()) {
                    result.put("success", false);
                    result.put("message", "Thiếu số lượng");
                    out.print(gson.toJson(result));
                    return;
                }
                
                int quantity = Integer.parseInt(quantityStr);
                if (quantity <= 0) {
                    result.put("success", false);
                    result.put("message", "Số lượng phải lớn hơn 0");
                    out.print(gson.toJson(result));
                    return;
                }
                
                // Kiểm tra số lượng tồn kho
                Medicine medicine = medicineDAO.getMedicineById(medicineId);
                if (medicine == null) {
                    result.put("success", false);
                    result.put("message", "Sản phẩm không tồn tại");
                    out.print(gson.toJson(result));
                    return;
                }
                
                if (quantity > medicine.getQuantity()) {
                    result.put("success", false);
                    result.put("message", "Chỉ còn " + medicine.getQuantity() + " sản phẩm trong kho");
                    out.print(gson.toJson(result));
                    return;
                }
                
                // Update quantity in cart
                boolean updated = cartDAO.updateQuantityByUserAndMedicine(userId, medicineId, quantity);

                if (updated) {
                    int cartCount = cartDAO.getCartCount(userId);
                    result.put("success", true);
                    result.put("message", "Cập nhật thành công");
                    result.put("cartCount", cartCount);
                } else {
                    result.put("success", false);
                    result.put("message", "Cập nhật thất bại");
                }
                
            } else if ("remove".equals(action)) {
                // Remove item from cart
                boolean removed = cartDAO.removeItemByUserAndMedicine(userId, medicineId);

                if (removed) {
                    int cartCount = cartDAO.getCartCount(userId);
                    result.put("success", true);
                    result.put("message", "Đã xóa sản phẩm");
                    result.put("cartCount", cartCount);
                } else {
                    result.put("success", false);
                    result.put("message", "Xóa thất bại");
                }
                
            } else {
                result.put("success", false);
                result.put("message", "Action không hợp lệ");
            }
            
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Dữ liệu không hợp lệ");
            e.printStackTrace();
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra: " + e.getMessage());
            e.printStackTrace();
        }
        
        out.print(gson.toJson(result));
    }
}
