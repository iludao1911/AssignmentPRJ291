package listener;

import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletRequestEvent;
import jakarta.servlet.ServletRequestListener;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpServletRequest;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Servlet Request Listener
 * Lắng nghe và log mọi HTTP request đến ứng dụng
 */
@WebListener
public class RequestListener implements ServletRequestListener {

    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss.SSS");

    @Override
    public void requestInitialized(ServletRequestEvent sre) {
        ServletRequest request = sre.getServletRequest();

        if (request instanceof HttpServletRequest) {
            HttpServletRequest httpRequest = (HttpServletRequest) request;

            // Lưu thời gian bắt đầu request
            long startTime = System.currentTimeMillis();
            request.setAttribute("startTime", startTime);

            // Lấy thông tin request
            String method = httpRequest.getMethod();
            String uri = httpRequest.getRequestURI();
            String queryString = httpRequest.getQueryString();
            String remoteAddr = getClientIP(httpRequest);
            String userAgent = httpRequest.getHeader("User-Agent");

            // Build full URL
            String fullURL = uri;
            if (queryString != null && !queryString.isEmpty()) {
                fullURL += "?" + queryString;
            }

            // Log request (chỉ log những request quan trọng, bỏ qua static resources)
            if (shouldLogRequest(uri)) {
                String timestamp = LocalDateTime.now().format(formatter);
                System.out.println(String.format("[REQUEST] %s | %s %s | IP: %s",
                        timestamp, method, fullURL, remoteAddr));

                // Log user agent nếu cần debug
                // System.out.println("User-Agent: " + userAgent);
            }
        }
    }

    @Override
    public void requestDestroyed(ServletRequestEvent sre) {
        ServletRequest request = sre.getServletRequest();

        if (request instanceof HttpServletRequest) {
            HttpServletRequest httpRequest = (HttpServletRequest) request;

            // Tính thời gian xử lý
            Long startTime = (Long) request.getAttribute("startTime");
            if (startTime != null) {
                long endTime = System.currentTimeMillis();
                long duration = endTime - startTime;

                String uri = httpRequest.getRequestURI();
                String method = httpRequest.getMethod();

                // Log slow requests (> 1000ms)
                if (duration > 1000 && shouldLogRequest(uri)) {
                    System.out.println(String.format("[SLOW REQUEST] %s %s | Duration: %dms",
                            method, uri, duration));
                }

                // Log nếu có error
                Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
                if (statusCode != null && statusCode >= 400) {
                    System.out.println(String.format("[ERROR] %s %s | Status: %d | Duration: %dms",
                            method, uri, statusCode, duration));
                }
            }
        }
    }

    /**
     * Lấy IP thực của client (xử lý cả trường hợp có proxy)
     */
    private String getClientIP(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        // Nếu có nhiều IP (qua nhiều proxy), lấy IP đầu tiên
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }

    /**
     * Kiểm tra xem có nên log request này không
     * (Bỏ qua static resources như CSS, JS, images)
     */
    private boolean shouldLogRequest(String uri) {
        if (uri == null) return false;

        // Bỏ qua static resources
        if (uri.endsWith(".css") || uri.endsWith(".js") ||
            uri.endsWith(".jpg") || uri.endsWith(".jpeg") ||
            uri.endsWith(".png") || uri.endsWith(".gif") ||
            uri.endsWith(".ico") || uri.endsWith(".svg") ||
            uri.endsWith(".woff") || uri.endsWith(".woff2") ||
            uri.endsWith(".ttf") || uri.endsWith(".eot")) {
            return false;
        }

        // Bỏ qua favicon
        if (uri.contains("favicon")) {
            return false;
        }

        return true;
    }
}
