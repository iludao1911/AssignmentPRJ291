/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import dao.OrderDAO;
import jakarta.servlet.annotation.WebServlet;
import model.Customer;
import model.Order;
    @WebServlet("/order-history")
    public class OrderHistoryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("currentCustomer");
        if (customer == null) {
            response.sendRedirect("customer-login.jsp");
            return;
        }

        try {
            OrderDAO dao = new OrderDAO();
            List<Order> orderList = dao.getOrdersByCustomerId(customer.getCustomerId());
            request.setAttribute("orderList", orderList);
            request.getRequestDispatcher("order-history.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}


