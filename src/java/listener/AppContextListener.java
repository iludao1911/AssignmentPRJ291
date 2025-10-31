package listener;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Application Context Listener
 * Lắng nghe sự kiện khởi động và tắt ứng dụng
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        String appName = context.getContextPath();
        String startTime = LocalDateTime.now().format(formatter);

        // Lưu thông tin khởi động vào context
        context.setAttribute("appStartTime", startTime);
        context.setAttribute("appName", appName);

        // Initialize counters
        context.setAttribute("totalVisitors", 0);
        context.setAttribute("currentOnlineUsers", 0);

        // Log khởi động
        System.out.println("========================================");
        System.out.println("APPLICATION STARTED");
        System.out.println("Application Name: " + appName);
        System.out.println("Start Time: " + startTime);
        System.out.println("========================================");

        // Load configuration nếu cần
        loadConfiguration(context);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        String appName = context.getAttribute("appName").toString();
        String startTime = context.getAttribute("appStartTime").toString();
        String stopTime = LocalDateTime.now().format(formatter);
        Integer totalVisitors = (Integer) context.getAttribute("totalVisitors");

        // Log shutdown
        System.out.println("========================================");
        System.out.println("APPLICATION SHUTDOWN");
        System.out.println("Application Name: " + appName);
        System.out.println("Started: " + startTime);
        System.out.println("Stopped: " + stopTime);
        System.out.println("Total Visitors: " + totalVisitors);
        System.out.println("========================================");

        // Cleanup resources
        cleanupResources(context);
    }

    private void loadConfiguration(ServletContext context) {
        // Load configuration from properties file hoặc database
        try {
            // Ví dụ: Load chatbot config, payment gateway config, etc.
            System.out.println("Loading application configuration...");

            // Có thể load thêm config khác ở đây
            context.setAttribute("configLoaded", true);

            System.out.println("Configuration loaded successfully!");
        } catch (Exception e) {
            System.err.println("Error loading configuration: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void cleanupResources(ServletContext context) {
        // Cleanup resources như database connections, cache, etc.
        try {
            System.out.println("Cleaning up application resources...");

            // Close database connections nếu có connection pool
            // Clear cache nếu có
            // Stop scheduled tasks nếu có

            System.out.println("Resources cleaned up successfully!");
        } catch (Exception e) {
            System.err.println("Error cleaning up resources: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
