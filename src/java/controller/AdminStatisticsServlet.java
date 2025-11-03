package controller;

import dao.DBConnection;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminStatisticsServlet", urlPatterns = {"/admin-statistics"})
public class AdminStatisticsServlet extends HttpServlet {

    private Gson gson;

    @Override
    public void init() throws ServletException {
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> stats = new HashMap<>();

        try {
            Connection conn = DBConnection.getConnection();

            // 1. Tổng số user
            stats.put("totalUsers", getTotalUsers(conn));

            // 2. Tổng số thuốc
            stats.put("totalMedicines", getTotalMedicines(conn));

            // 3. Tổng số đơn hàng
            stats.put("totalOrders", getTotalOrders(conn));

            // 4. Tổng doanh thu
            stats.put("totalRevenue", getTotalRevenue(conn));

            // 5. Đơn hàng theo trạng thái
            stats.put("ordersByStatus", getOrdersByStatus(conn));

            // 6. Doanh thu 7 ngày gần đây
            stats.put("revenueByDate", getRevenueByDate(conn, 7));

            // 7. Top 5 thuốc bán chạy
            stats.put("topMedicines", getTopMedicines(conn, 5));

            // 8. Đơn hàng mới hôm nay
            stats.put("todayOrders", getTodayOrders(conn));

            conn.close();

            stats.put("success", true);
            out.print(gson.toJson(stats));

        } catch (Exception e) {
            e.printStackTrace();
            stats.put("success", false);
            stats.put("message", "Error: " + e.getMessage());
            out.print(gson.toJson(stats));
        }
    }

    private int getTotalUsers(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM [User]";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("count");
            }
        }
        return 0;
    }

    private int getTotalMedicines(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM Medicine";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("count");
            }
        }
        return 0;
    }

    private int getTotalOrders(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM [Order]";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("count");
            }
        }
        return 0;
    }

    private double getTotalRevenue(Connection conn) throws SQLException {
        String sql = "SELECT SUM(total_amount) as total FROM [Order] WHERE status IN ('Paid', 'Shipping', 'Done')";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("total");
            }
        }
        return 0.0;
    }

    private Map<String, Integer> getOrdersByStatus(Connection conn) throws SQLException {
        Map<String, Integer> result = new HashMap<>();
        String sql = "SELECT status, COUNT(*) as count FROM [Order] GROUP BY status";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.put(rs.getString("status"), rs.getInt("count"));
            }
        }
        return result;
    }

    private List<Map<String, Object>> getRevenueByDate(Connection conn, int days) throws SQLException {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT CAST(order_date AS DATE) as date, SUM(total_amount) as revenue " +
                     "FROM [Order] WHERE status IN ('Paid', 'Shipping', 'Done') " +
                     "AND order_date >= DATEADD(DAY, -?, CAST(GETDATE() AS DATE)) " +
                     "GROUP BY CAST(order_date AS DATE) ORDER BY date ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, days);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("date", rs.getString("date"));
                    item.put("revenue", rs.getDouble("revenue"));
                    result.add(item);
                }
            }
        }
        return result;
    }

    private List<Map<String, Object>> getTopMedicines(Connection conn, int limit) throws SQLException {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT TOP (?) m.Medicine_id, m.name, SUM(od.quantity) as total_sold " +
                     "FROM Medicine m " +
                     "JOIN OrderDetail od ON m.Medicine_id = od.Medicine_id " +
                     "JOIN [Order] o ON od.Order_id = o.Order_id " +
                     "WHERE o.status IN ('Paid', 'Shipping', 'Done') " +
                     "GROUP BY m.Medicine_id, m.name " +
                     "ORDER BY total_sold DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("medicineId", rs.getInt("Medicine_id"));
                    item.put("name", rs.getString("name"));
                    item.put("totalSold", rs.getInt("total_sold"));
                    result.add(item);
                }
            }
        }
        return result;
    }

    private int getTodayOrders(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM [Order] WHERE CAST(order_date AS DATE) = CAST(GETDATE() AS DATE)";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("count");
            }
        }
        return 0;
    }
}
