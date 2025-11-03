package controller;

import dao.OrderDAO;
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

@WebServlet(name = "UpdateOrderStatusServlet", urlPatterns = {"/update-order-status"})
public class UpdateOrderStatusServlet extends HttpServlet {
    
    private OrderDAO orderDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
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
            
            String action = request.getParameter("action");
            String orderIdStr = request.getParameter("orderId");
            
            if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "Thiếu thông tin đơn hàng");
                out.print(gson.toJson(result));
                return;
            }
            
            int orderId = Integer.parseInt(orderIdStr);
            
            if ("confirm-received".equals(action)) {
                // Khách hàng xác nhận đã nhận hàng -> chuyển sang Hoàn thành
                boolean updated = orderDAO.updateOrderStatusOnly(orderId, "Hoàn thành");
                
                if (updated) {
                    result.put("success", true);
                    result.put("message", "Đã xác nhận nhận hàng thành công");
                } else {
                    result.put("success", false);
                    result.put("message", "Cập nhật trạng thái thất bại");
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
