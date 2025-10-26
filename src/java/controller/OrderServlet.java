/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import model.Customer;
import model.Order;
import dao.OrderDAO;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("currentCustomer");

        if (customer == null) {
            response.sendRedirect("customer-login.jsp");
            return;
        }

        // Lấy danh sách đơn hàng của khách hàng hiện tại
        List<Order> orderList = orderDAO.getOrdersByCustomerId(customer.getCustomerId());
        request.setAttribute("orderList", orderList);
        request.getRequestDispatcher("order-history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            boolean deleted = orderDAO.deleteOrder(orderId);

            if (deleted) {
                request.setAttribute("message", "Đã xóa đơn hàng thành công!");
            } else {
                request.setAttribute("message", "Không thể xóa đơn hàng!");
            }

            // Sau khi xóa, load lại danh sách đơn hàng
            HttpSession session = request.getSession();
            Customer customer = (Customer) session.getAttribute("currentCustomer");
            List<Order> orderList = orderDAO.getOrdersByCustomerId(customer.getCustomerId());
            request.setAttribute("orderList", orderList);
            request.getRequestDispatcher("order-history.jsp").forward(request, response);
        }
    }
}
