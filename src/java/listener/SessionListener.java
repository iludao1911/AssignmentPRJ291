package listener;

import jakarta.servlet.ServletContext;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import model.User;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * HTTP Session Listener
 * Lắng nghe sự kiện tạo và hủy session
 */
@WebListener
public class SessionListener implements HttpSessionListener {

    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        ServletContext context = session.getServletContext();

        // Tăng counter
        synchronized (context) {
            Integer currentOnline = (Integer) context.getAttribute("currentOnlineUsers");
            Integer totalVisitors = (Integer) context.getAttribute("totalVisitors");

            if (currentOnline == null) currentOnline = 0;
            if (totalVisitors == null) totalVisitors = 0;

            currentOnline++;
            totalVisitors++;

            context.setAttribute("currentOnlineUsers", currentOnline);
            context.setAttribute("totalVisitors", totalVisitors);
        }

        // Lưu thời gian tạo session
        String createdTime = LocalDateTime.now().format(formatter);
        session.setAttribute("sessionCreatedTime", createdTime);

        // Log
        System.out.println("[SESSION] Created - ID: " + session.getId() +
                          " | Time: " + createdTime +
                          " | Online: " + context.getAttribute("currentOnlineUsers"));
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        ServletContext context = session.getServletContext();

        // Lấy thông tin user nếu có
        User user = (User) session.getAttribute("currentUser");
        String username = (user != null) ? user.getName() : "Guest";

        // Giảm counter
        synchronized (context) {
            Integer currentOnline = (Integer) context.getAttribute("currentOnlineUsers");
            if (currentOnline != null && currentOnline > 0) {
                currentOnline--;
                context.setAttribute("currentOnlineUsers", currentOnline);
            }
        }

        // Lấy thông tin session
        String createdTime = (String) session.getAttribute("sessionCreatedTime");
        String destroyedTime = LocalDateTime.now().format(formatter);

        // Log
        System.out.println("[SESSION] Destroyed - ID: " + session.getId() +
                          " | User: " + username +
                          " | Created: " + createdTime +
                          " | Destroyed: " + destroyedTime +
                          " | Online: " + context.getAttribute("currentOnlineUsers"));

        // Cleanup session data nếu cần
        cleanupSessionData(session);
    }

    private void cleanupSessionData(HttpSession session) {
        try {
            // Clear sensitive data
            session.removeAttribute("currentUser");
            session.removeAttribute("userId");
            session.removeAttribute("userRole");
            session.removeAttribute("pendingOrderId");

            // Log cleanup
            System.out.println("[SESSION] Session data cleaned up");
        } catch (Exception e) {
            System.err.println("[SESSION] Error cleaning up session data: " + e.getMessage());
        }
    }
}
