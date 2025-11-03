package controller;

import dao.*;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        System.out.println("[AdminDashboard] Session: " + (session != null ? session.getId() : "null"));
        
        if (session == null || session.getAttribute("currentUser") == null) {
            System.out.println("[AdminDashboard] No session or user, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/auth-login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        System.out.println("[AdminDashboard] User: " + currentUser.getName() + " | Role: " + currentUser.getRole());
        
        if (!currentUser.isAdmin()) {
            System.out.println("[AdminDashboard] User is not admin, redirecting to home");
            response.sendRedirect(request.getContextPath() + "/home.jsp");
            return;
        }

        try {
            // Get statistics from database
            Connection conn = DBConnection.getConnection();
            
            // Total medicines
            String sqlMedicines = "SELECT COUNT(*) as total FROM Medicine";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sqlMedicines);
            int totalMedicines = 0;
            if (rs.next()) {
                totalMedicines = rs.getInt("total");
            }
            rs.close();
            
            // Total orders
            String sqlOrders = "SELECT COUNT(*) as total FROM [Order]";
            rs = stmt.executeQuery(sqlOrders);
            int totalOrders = 0;
            if (rs.next()) {
                totalOrders = rs.getInt("total");
            }
            rs.close();
            
            // Total customers
            String sqlCustomers = "SELECT COUNT(*) as total FROM [User] WHERE role = 'Customer'";
            rs = stmt.executeQuery(sqlCustomers);
            int totalCustomers = 0;
            if (rs.next()) {
                totalCustomers = rs.getInt("total");
            }
            rs.close();
            
            // Total revenue
            String sqlRevenue = "SELECT ISNULL(SUM(total_amount), 0) as total FROM [Order] WHERE status != 'Cancelled'";
            rs = stmt.executeQuery(sqlRevenue);
            double totalRevenue = 0;
            if (rs.next()) {
                totalRevenue = rs.getDouble("total");
            }
            rs.close();
            
            // Pending orders
            String sqlPendingOrders = "SELECT COUNT(*) as total FROM [Order] WHERE status = 'Pending'";
            rs = stmt.executeQuery(sqlPendingOrders);
            int pendingOrders = 0;
            if (rs.next()) {
                pendingOrders = rs.getInt("total");
            }
            rs.close();
            
            // Low stock medicines
            String sqlLowStock = "SELECT COUNT(*) as total FROM Medicine WHERE quantity < 50";
            rs = stmt.executeQuery(sqlLowStock);
            int lowStockCount = 0;
            if (rs.next()) {
                lowStockCount = rs.getInt("total");
            }
            rs.close();
            
            stmt.close();
            conn.close();
            
            // Set attributes
            request.setAttribute("totalMedicines", totalMedicines);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("pendingOrders", pendingOrders);
            request.setAttribute("lowStockCount", lowStockCount);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải dữ liệu: " + e.getMessage());
        }

        request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
    }
}
