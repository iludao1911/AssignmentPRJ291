package controller;

import dao.CartDAO;
import dao.OrderDAO;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Cart;
import model.User;
import model.Order;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    private CartDAO cartDAO;
    private OrderDAO orderDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        orderDAO = new OrderDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("auth-login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");

        try {
            // Kiểm tra xem có pendingOrderId không (từ order history)
            Integer pendingOrderId = (Integer) session.getAttribute("pendingOrderId");

            if (pendingOrderId != null) {
                // Load pending order và forward
                request.getRequestDispatcher("check-out.jsp").forward(request, response);
                return;
            }

            // Nếu không có pending order, tạo mới từ giỏ hàng
            List<Cart> cartItems = cartDAO.getCartByUserId(currentUser.getUserId());

            if (cartItems == null || cartItems.isEmpty()) {
                response.sendRedirect("cart-view.jsp");
                return;
            }

            // Tính tổng tiền
            double totalAmount = 0;
            for (Cart item : cartItems) {
                totalAmount += item.getTotalPrice();
            }

            // Tạo Order với status Chờ thanh toán
            Order order = new Order();
            order.setUserId(currentUser.getUserId());
            order.setTotalAmount(totalAmount);
            order.setStatus("Chờ thanh toán");
            order.setShippingAddress(""); // Sẽ cập nhật từ form

            int orderId = orderDAO.createOrderWithDetails(order, cartItems);

            if (orderId > 0) {
                // Lưu orderId vào session để confirm sau
                session.setAttribute("pendingOrderId", orderId);

                // Forward đến trang checkout
                request.setAttribute("cartItems", cartItems);
                request.setAttribute("totalAmount", totalAmount);
                request.setAttribute("orderId", orderId);
                request.getRequestDispatcher("check-out.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Không thể tạo đơn hàng");
                response.sendRedirect("cart-view.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect("cart-view.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            result.put("success", false);
            result.put("message", "Vui lòng đăng nhập");
            out.print(gson.toJson(result));
            return;
        }

        try {
            String action = request.getParameter("action");

            if ("continue".equals(action)) {
                // Tiếp tục thanh toán cho đơn hàng Pending
                String orderIdStr = request.getParameter("orderId");

                if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
                    result.put("success", false);
                    result.put("message", "Thiếu thông tin đơn hàng");
                    out.print(gson.toJson(result));
                    return;
                }

                int orderId = Integer.parseInt(orderIdStr);

                // Lưu orderId vào session
                session.setAttribute("pendingOrderId", orderId);

                result.put("success", true);
                result.put("message", "Chuyển đến trang thanh toán");

            } else {
                result.put("success", false);
                result.put("message", "Action không hợp lệ");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }

        out.print(gson.toJson(result));
    }
}
