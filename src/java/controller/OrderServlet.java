package controller;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/orders")
public class OrderServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        this.orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            if ("view".equals(action)) viewOrder(request, response);
            else if ("getDetails".equals(action)) getOrderDetails(request, response);
            else if ("updateStatus".equals(action)) updateStatus(request, response);
            else if ("delete".equals(action)) deleteOrder(request, response);
            else listOrders(request, response);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("updateStatus".equals(action)) updateStatus(request, response);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        List<Order> orders = orderDAO.getAllOrders();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
    }

    private void viewOrder(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("id"));
        Order order = orderDAO.getOrderById(orderId);
        request.setAttribute("order", order);
        request.getRequestDispatcher("/admin/order-detail.jsp").forward(request, response);
    }
    
    private void getOrderDetails(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        int orderId = Integer.parseInt(request.getParameter("id"));
        Order order = orderDAO.getOrderById(orderId);
        
        StringBuilder json = new StringBuilder();
        json.append("{\"items\":[");
        
        if (order != null && order.getOrderDetails() != null) {
            for (int i = 0; i < order.getOrderDetails().size(); i++) {
                if (i > 0) json.append(",");
                var item = order.getOrderDetails().get(i);
                json.append("{");
                json.append("\"medicineName\":\"").append(item.getMedicineName()).append("\",");
                json.append("\"quantity\":").append(item.getQuantity()).append(",");
                json.append("\"price\":").append(item.getPrice());
                json.append("}");
            }
        }
        
        json.append("]}");
        response.getWriter().write(json.toString());
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int orderId = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        orderDAO.updateOrderStatusOnly(orderId, status);
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }

    private void deleteOrder(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int orderId = Integer.parseInt(request.getParameter("id"));
        orderDAO.deleteOrder(orderId);
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
