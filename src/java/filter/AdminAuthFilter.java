package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;

import java.io.IOException;

/**
 * This filter protects all URLs under the /admin/* path.
 * It checks if a user is logged in and has the 'Admin' role.
 * - If the user is not logged in, it redirects to the common login page.
 * - If the user is logged in but is not an 'Admin', it redirects them to an access denied page or their own dashboard.
 * - If the user is an 'Admin', it allows access.
 */
@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false); // Do not create a new session if one doesn't exist

        Customer loggedInUser = null;
        if (session != null) {
            loggedInUser = (Customer) session.getAttribute("currentCustomer");
        }

        if (loggedInUser != null) {
            // User is logged in, check their role
            String role = loggedInUser.getRole();
            if ("Admin".equalsIgnoreCase(role)) {
                // User is an Admin, allow access to the requested admin page
                chain.doFilter(request, response);
            } else {
                // User is logged in but is not an admin, redirect to an access denied page
                // or their own dashboard. Redirecting to login would cause a loop.
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied.jsp");
            }
        } else {
            // User is not logged in, redirect to the common login page
            // Save the original requested URL to redirect back after successful login
            String requestURI = httpRequest.getRequestURI();
            if (httpRequest.getQueryString() != null) {
                requestURI += "?" + httpRequest.getQueryString();
            }
            session = httpRequest.getSession(); // Create session to store the URL
            session.setAttribute("preLoginURL", requestURI);
            
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialization needed
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }
}
