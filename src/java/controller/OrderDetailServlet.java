package controller;

import dao.OrderDAO;
import model.Order;
import model.OrderDetail;
import model.User;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "OrderDetailServlet", urlPatterns = {"/order-details"})
public class OrderDetailServlet extends HttpServlet {
    
    private OrderDAO orderDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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
            // Debug logging to help trace admin view issues
            try {
                System.out.println("[OrderDetailServlet] Request by user: " + (currentUser != null ? currentUser.getUserId() + " (" + currentUser.getEmail() + ")" : "null"));
            } catch (Exception e) {
                // swallow logging exceptions
            }
            String orderIdStr = request.getParameter("orderId");
            
            if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "Thiếu thông tin đơn hàng");
                out.print(gson.toJson(result));
                return;
            }
            
            int orderId = Integer.parseInt(orderIdStr);
            System.out.println("[OrderDetailServlet] Requested orderId=" + orderId);
            
            // Get order
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null) {
                result.put("success", false);
                result.put("message", "Không tìm thấy đơn hàng");
                out.print(gson.toJson(result));
                return;
            }
            
            // Check if user has permission: admin OR order owner
            if (order.getUserId() != currentUser.getUserId() && !currentUser.isAdmin()) {
                System.out.println("[OrderDetailServlet] Access denied. Order.userId=" + order.getUserId() + " | currentUserId=" + currentUser.getUserId() + " | isAdmin=" + currentUser.isAdmin());
                result.put("success", false);
                result.put("message", "Bạn không có quyền xem đơn hàng này");
                out.print(gson.toJson(result));
                return;
            } else {
                System.out.println("[OrderDetailServlet] Access granted for orderId=" + order.getOrderId());
            }
            
            // Get order details
            List<OrderDetail> orderDetails = orderDAO.getOrderDetails(orderId);
            
            // Format order data
            Map<String, Object> orderData = new HashMap<>();
            orderData.put("orderId", order.getOrderId());
            orderData.put("status", order.getStatus());
            orderData.put("totalAmount", order.getTotalAmount());
            orderData.put("customerName", order.getUserName());
            orderData.put("customerEmail", order.getUserEmail());
            orderData.put("shippingAddress", order.getShippingAddress());
            
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            orderData.put("orderDate", dateFormat.format(order.getOrderDate()));
            
            // Format order items - convert BigDecimal to double for JavaScript
            List<Map<String, Object>> items = new java.util.ArrayList<>();
            for (OrderDetail detail : orderDetails) {
                Map<String, Object> item = new HashMap<>();
                item.put("medicineId", detail.getMedicineId());
                item.put("medicineName", detail.getMedicineName());
                item.put("medicineImage", detail.getMedicineImage());
                item.put("quantity", detail.getQuantity());
                item.put("unitPrice", detail.getPrice() != null ? detail.getPrice().doubleValue() : 0.0);
                item.put("subtotal", detail.getSubtotal() != null ? detail.getSubtotal().doubleValue() : 0.0);
                items.add(item);
            }
            orderData.put("items", items);
            
            result.put("success", true);
            result.put("order", orderData);
            
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
