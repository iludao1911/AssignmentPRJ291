package controller;

import dao.CartDAO;
import dao.OrderDAO;
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
import java.util.List;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {
    
    private CartDAO cartDAO;
    private OrderDAO orderDAO;
    
    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        orderDAO = new OrderDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        
        try {
            // Lấy giỏ hàng
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
            
            // Tạo Order với status Paid (đã thanh toán nhưng chưa giao)
            Order order = new Order();
            order.setUserId(currentUser.getUserId());
            order.setTotalAmount(totalAmount);
            order.setStatus("Paid");
            order.setShippingAddress(""); // Sẽ cập nhật từ form
            
            int orderId = orderDAO.createOrderWithDetails(order, cartItems);
            
            if (orderId > 0) {
                // Lưu orderId vào session để confirm sau
                session.setAttribute("pendingOrderId", orderId);
                
                // Forward đến trang checkout
                request.setAttribute("cartItems", cartItems);
                request.setAttribute("totalAmount", totalAmount);
                request.setAttribute("orderId", orderId);
                request.getRequestDispatcher("checkout.jsp").forward(request, response);
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
}
