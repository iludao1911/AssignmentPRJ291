package listener;

import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionAttributeListener;
import jakarta.servlet.http.HttpSessionBindingEvent;
import model.User;

/**
 * Session Attribute Listener
 * Lắng nghe các thay đổi về attributes trong session
 * Hữu ích cho việc debug và security monitoring
 */
@WebListener
public class SessionAttributeListener implements HttpSessionAttributeListener {

    private static final boolean DEBUG_MODE = false; // Bật/tắt debug logging

    @Override
    public void attributeAdded(HttpSessionBindingEvent event) {
        String attributeName = event.getName();
        Object attributeValue = event.getValue();

        // Log các sự kiện quan trọng
        if ("currentUser".equals(attributeName)) {
            User user = (User) attributeValue;
            System.out.println("[SESSION] User logged in - Name: " + user.getName() +
                              " | UserID: " + user.getUserId() +
                              " | Role: " + user.getRole() +
                              " | SessionID: " + event.getSession().getId());
        } else if ("pendingOrderId".equals(attributeName)) {
            System.out.println("[SESSION] Pending order created - OrderID: " + attributeValue +
                              " | SessionID: " + event.getSession().getId());
        } else if (DEBUG_MODE) {
            // Debug mode: log all attributes
            System.out.println("[SESSION] Attribute added - Name: " + attributeName +
                              " | Value: " + attributeValue +
                              " | SessionID: " + event.getSession().getId());
        }
    }

    @Override
    public void attributeRemoved(HttpSessionBindingEvent event) {
        String attributeName = event.getName();
        Object attributeValue = event.getValue();

        // Log các sự kiện quan trọng
        if ("currentUser".equals(attributeName)) {
            User user = (User) attributeValue;
            System.out.println("[SESSION] User logged out - Name: " + user.getName() +
                              " | UserID: " + user.getUserId() +
                              " | SessionID: " + event.getSession().getId());
        } else if ("pendingOrderId".equals(attributeName)) {
            System.out.println("[SESSION] Pending order completed/cancelled - OrderID: " + attributeValue +
                              " | SessionID: " + event.getSession().getId());
        } else if (DEBUG_MODE) {
            // Debug mode: log all attributes
            System.out.println("[SESSION] Attribute removed - Name: " + attributeName +
                              " | Value: " + attributeValue +
                              " | SessionID: " + event.getSession().getId());
        }
    }

    @Override
    public void attributeReplaced(HttpSessionBindingEvent event) {
        String attributeName = event.getName();
        Object oldValue = event.getValue();
        Object newValue = event.getSession().getAttribute(attributeName);

        // Log các thay đổi quan trọng
        if ("currentUser".equals(attributeName)) {
            User oldUser = (User) oldValue;
            User newUser = (User) newValue;

            // Cảnh báo nếu user thay đổi (có thể là security issue)
            if (oldUser.getUserId() != newUser.getUserId()) {
                System.out.println("[SESSION WARNING] User changed in same session!" +
                                  " | Old: " + oldUser.getName() +
                                  " | New: " + newUser.getName() +
                                  " | SessionID: " + event.getSession().getId());
            }
        } else if (DEBUG_MODE) {
            // Debug mode: log all attribute changes
            System.out.println("[SESSION] Attribute replaced - Name: " + attributeName +
                              " | OldValue: " + oldValue +
                              " | NewValue: " + newValue +
                              " | SessionID: " + event.getSession().getId());
        }
    }
}
