package controller;

import dao.OrderDAO;
import dao.CartDAO;
import dao.MedicineDAO;
import model.User;
import model.OrderDetail;
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
import java.util.List;
import java.util.Map;

@WebServlet(name = "ConfirmPaymentServlet", urlPatterns = {"/confirm-payment"})
public class ConfirmPaymentServlet extends HttpServlet {
    
    private OrderDAO orderDAO;
    private CartDAO cartDAO;
    private MedicineDAO medicineDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
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
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("currentUser") == null) {
                result.put("success", false);
                result.put("message", "Vui lòng đăng nhập");
                out.print(gson.toJson(result));
                return;
            }
            
            User currentUser = (User) session.getAttribute("currentUser");
            Integer pendingOrderId = (Integer) session.getAttribute("pendingOrderId");
            
            if (pendingOrderId == null) {
                result.put("success", false);
                result.put("message", "Không tìm thấy đơn hàng");
                out.print(gson.toJson(result));
                return;
            }
            
            String shippingAddress = request.getParameter("shippingAddress");
            String paymentMethod = request.getParameter("paymentMethod");
            
            if (shippingAddress == null || shippingAddress.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "Vui lòng nhập địa chỉ giao hàng");
                out.print(gson.toJson(result));
                return;
            }
            
            // Lấy danh sách OrderDetail để trừ số lượng thuốc
            List<OrderDetail> orderDetails = orderDAO.getOrderDetails(pendingOrderId);
            
            // Cập nhật Order: status = Đã thanh toán (chờ admin xác nhận vận chuyển), shipping address
            boolean updated = orderDAO.updateOrderStatus(pendingOrderId, "Đã thanh toán", shippingAddress);

            if (updated) {
                // Trừ số lượng thuốc trong kho
                for (OrderDetail detail : orderDetails) {
                    boolean decreased = medicineDAO.decreaseQuantity(detail.getMedicineId(), detail.getQuantity());
                    if (!decreased) {
                        // Log cảnh báo nếu không trừ được (có thể do hết hàng)
                        System.err.println("WARNING: Could not decrease quantity for Medicine ID: " 
                            + detail.getMedicineId() + ", Quantity: " + detail.getQuantity());
                    }
                }
                
                // Xóa giỏ hàng sau khi thanh toán thành công
                cartDAO.clearCart(currentUser.getUserId());

                // Xóa pendingOrderId khỏi session
                session.removeAttribute("pendingOrderId");

                result.put("success", true);
                result.put("message", "Thanh toán thành công! Đơn hàng đang chờ xác nhận.");
                result.put("orderId", pendingOrderId);
            } else {
                result.put("success", false);
                result.put("message", "Xác nhận thanh toán thất bại");
            }
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra: " + e.getMessage());
            e.printStackTrace();
        }
        
        out.print(gson.toJson(result));
    }
}
