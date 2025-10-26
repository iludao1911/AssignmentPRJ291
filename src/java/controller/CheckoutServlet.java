/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import model.*;
import dao.OrderDAO;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    // 🔹 Khi người dùng bấm nút “Thanh toán” trong giỏ hàng → gọi GET
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("currentCustomer");

        if (customer == null) {
            response.sendRedirect("customer-login.jsp");
            return;
        }

        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            request.setAttribute("message", "Giỏ hàng trống!");
            request.getRequestDispatcher("cart-view.jsp").forward(request, response);
            return;
        }

        // Gửi giỏ hàng sang trang checkout.jsp để hiển thị form thanh toán
        request.setAttribute("cart", cart);
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    // 🔹 Khi người dùng bấm “Xác nhận thanh toán” → gọi POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("currentCustomer");

        if (customer == null) {
            response.sendRedirect("customer-login.jsp");
            return;
        }

        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            request.setAttribute("message", "Giỏ hàng của bạn đang trống!");
            request.getRequestDispatcher("cart-view.jsp").forward(request, response);
            return;
        }

        // 🔹 Lấy thông tin form
        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod");

        double totalAmount = 0;
        for (CartItem item : cart) {
            totalAmount += item.getMedicine().getPrice().doubleValue() * item.getQuantity();
        }

        try {
            OrderDAO orderDAO = new OrderDAO();
            Order order = new Order(customer.getCustomerId(), BigDecimal.valueOf(totalAmount));
            int orderId = orderDAO.createOrder(order);

            if (orderId != -1) {
                orderDAO.addOrderDetails(orderId, cart);
            }

            // Xoá giỏ hàng sau khi thanh toán
            session.removeAttribute("cart");

            // Gửi dữ liệu sang trang thành công
            request.setAttribute("customer", customer);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("paymentMethod", paymentMethod);
            request.setAttribute("address", address);

            request.getRequestDispatcher("checkout-success.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi khi xử lý thanh toán!");
            request.getRequestDispatcher("cart-view.jsp").forward(request, response);
        }
    }
}



