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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dao.MedicineDAO;
import dao.OrderDAO;
import model.Medicine;
import model.CartItem;
import model.Customer;
import model.Order;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private MedicineDAO medicineDAO;

    @Override
    public void init() {
        medicineDAO = new MedicineDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addToCart(request, response);
        } else if ("remove".equals(action)) {
            removeFromCart(request, response);    
        } else if ("checkout".equals(action)) {
            checkout(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("view".equals(action)) {
            viewCart(request, response);
        } else if ("checkout".equals(action)) {
            checkout(request, response);
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("currentCustomer");

        if (customer == null) {
            response.sendRedirect("customer-login.jsp");
            return;
        }

        try {
            int medicineId = Integer.parseInt(request.getParameter("medicineId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            Medicine medicine = medicineDAO.getMedicineById(medicineId);
            if (medicine == null) {
                request.setAttribute("error", "Không tìm thấy thuốc!");
                request.getRequestDispatcher("customer-view-products.jsp").forward(request, response);
                return;
            }

            @SuppressWarnings("unchecked")
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            if (cart == null) {
                cart = new ArrayList<>();
            }

            boolean exists = false;
            for (CartItem item : cart) {
                if (item.getMedicine().getMedicineId() == medicineId) {
                    item.setQuantity(item.getQuantity() + quantity);
                    exists = true;
                    break;
                }
            }

            if (!exists) {
                cart.add(new CartItem(medicine, quantity));
            }

            session.setAttribute("cart", cart);
            response.sendRedirect("customer-view-products");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ!");
            request.getRequestDispatcher("customer-view-products.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi cơ sở dữ liệu!");
            request.getRequestDispatcher("customer-view-products.jsp").forward(request, response);
        }
    }
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response)
        throws IOException {
    HttpSession session = request.getSession();
    String medicineIdStr = request.getParameter("medicineId");

    if (medicineIdStr == null || medicineIdStr.isEmpty()) {
        System.out.println("⚠️ Không nhận được medicineId khi xóa sản phẩm!");
        response.sendRedirect("cart?action=view");
        return;
    }

    int medicineId = Integer.parseInt(medicineIdStr);

    @SuppressWarnings("unchecked")
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    if (cart != null) {
        cart.removeIf(item -> item.getMedicine().getMedicineId() == medicineId);
    }

    session.setAttribute("cart", cart);
    response.sendRedirect("cart?action=view");
}

   

    private void viewCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        BigDecimal total = BigDecimal.ZERO;
        if (cart != null) {
            for (CartItem item : cart) {
                total = total.add(item.getMedicine().getPrice()
                        .multiply(BigDecimal.valueOf(item.getQuantity())));
            }
        }

        request.setAttribute("totalAmount", total);
        request.getRequestDispatcher("cart-view.jsp").forward(request, response);
    }

    private void checkout(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("currentCustomer");

        if (customer == null) {
            response.sendRedirect("customer-login.jsp");
            return;
        }

        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart?action=view");
            return;
        }

        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : cart) {
            total = total.add(item.getMedicine().getPrice()
                    .multiply(BigDecimal.valueOf(item.getQuantity())));
        }

        try {
            OrderDAO orderDAO = new OrderDAO();
            Order order = new Order(customer.getCustomerId(), total);
            int orderId = orderDAO.createOrder(order);

            if (orderId > 0) {
                orderDAO.addOrderDetails(orderId, cart);
                session.removeAttribute("cart"); // Xóa giỏ hàng sau khi thanh toán
                response.sendRedirect("order-success.jsp");
            } else {
                request.setAttribute("error", "Không thể tạo đơn hàng!");
                request.getRequestDispatcher("cart-view.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi thanh toán!");
            request.getRequestDispatcher("cart-view.jsp").forward(request, response);
        }
    }
}



