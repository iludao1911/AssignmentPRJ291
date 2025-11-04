package controller;

import dao.OrderDAO;
import dao.CartDAO;
import dao.MedicineDAO;
import model.User;
import model.OrderDetail;
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
            
            // Lấy danh sách OrderDetail để kiểm tra và trừ số lượng thuốc
            List<OrderDetail> orderDetails = orderDAO.getOrderDetails(pendingOrderId);
            
            // BƯỚC 1: Kiểm tra số lượng tồn kho trước khi thanh toán
            System.out.println("Checking stock for " + orderDetails.size() + " items...");
            for (OrderDetail detail : orderDetails) {
                int medicineId = detail.getMedicineId();
                int requestedQty = detail.getQuantity();
                
                System.out.println("Checking medicine ID: " + medicineId + ", Qty: " + requestedQty);
                
                // Lấy thông tin thuốc từ database
                Medicine medicine = medicineDAO.getMedicineById(medicineId);
                if (medicine == null) {
                    System.err.println("Medicine not found: " + medicineId);
                    result.put("success", false);
                    result.put("message", "Sản phẩm ID " + medicineId + " không tồn tại");
                    out.print(gson.toJson(result));
                    return;
                }
                
                // Kiểm tra số lượng
                System.out.println("Medicine: " + medicine.getName() + ", Stock: " + medicine.getQuantity());
                if (medicine.getQuantity() < requestedQty) {
                    System.err.println("Insufficient stock for: " + medicine.getName());
                    
                    // AUTO CANCEL ORDER when out of stock
                    System.out.println("Auto cancelling order due to insufficient stock...");
                    orderDAO.updateOrderStatus(pendingOrderId, "Đã hủy", "Tự động hủy: Hết hàng");
                    
                    // Clear cart and session
                    cartDAO.clearCart(currentUser.getUserId());
                    session.removeAttribute("pendingOrderId");
                    
                    result.put("success", false);
                    result.put("cancelled", true);
                    result.put("message", "Sản phẩm '" + medicine.getName() + "' chỉ còn " + medicine.getQuantity() + " (bạn đặt " + requestedQty + "). Đơn hàng đã được hủy tự động.");
                    String jsonResponse = gson.toJson(result);
                    System.out.println("Sending error response (order cancelled): " + jsonResponse);
                    out.print(jsonResponse);
                    out.flush();
                    return;
                }
            }
            
            System.out.println("Stock check passed. Decreasing quantities...");
            
            // BƯỚC 2: Tất cả đều đủ hàng, bắt đầu trừ kho
            boolean allDecreased = true;
            for (OrderDetail detail : orderDetails) {
                boolean decreased = medicineDAO.decreaseQuantity(detail.getMedicineId(), detail.getQuantity());
                if (!decreased) {
                    allDecreased = false;
                    System.err.println("CRITICAL: Failed to decrease quantity for Medicine ID: " 
                        + detail.getMedicineId() + ", Quantity: " + detail.getQuantity());
                }
            }
            
            // BƯỚC 3: Nếu trừ kho thành công, mới cập nhật order status
            if (allDecreased) {
                System.out.println("All quantities decreased. Updating order status...");
                boolean updated = orderDAO.updateOrderStatus(pendingOrderId, "Đã thanh toán", shippingAddress);
                
                if (updated) {
                    System.out.println("Order status updated. Clearing cart...");
                    // Xóa giỏ hàng sau khi thanh toán thành công
                    cartDAO.clearCart(currentUser.getUserId());

                    // Xóa pendingOrderId khỏi session
                    session.removeAttribute("pendingOrderId");

                    System.out.println("Payment confirmed successfully for order: " + pendingOrderId);
                    result.put("success", true);
                    result.put("message", "Thanh toán thành công! Đơn hàng đang chờ xác nhận.");
                    result.put("orderId", pendingOrderId);
                    result.put("redirectUrl", "payment-success.jsp?orderId=" + pendingOrderId);
                } else {
                    System.err.println("Failed to update order status");
                    result.put("success", false);
                    result.put("message", "Xác nhận thanh toán thất bại");
                }
            } else {
                System.err.println("Failed to decrease all quantities");
                result.put("success", false);
                result.put("message", "Có lỗi khi cập nhật kho hàng. Vui lòng thử lại sau.");
            }
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra: " + e.getMessage());
            e.printStackTrace();
        }
        
        String jsonResponse = gson.toJson(result);
        System.out.println("Sending final response: " + jsonResponse);
        out.print(jsonResponse);
        out.flush();
    }
}
