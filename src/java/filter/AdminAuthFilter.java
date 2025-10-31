package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;

/**
 * This filter protects all URLs under the /admin/* path.
 * It checks if a user is logged in and has the 'Admin' role.
 * - If the user is not logged in, it redirects to the common login page.
 * - If the user is logged in but is not an 'Admin', it redirects them to home page.
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

        User currentUser = null;
        if (session != null) {
            currentUser = (User) session.getAttribute("currentUser");
        }

        if (currentUser != null) {
            // User is logged in, check their role
            if (currentUser.isAdmin()) {
                // User is an Admin, allow access to the requested admin page
                chain.doFilter(request, response);
            } else {
                // User is logged in but is not an admin, redirect to home page
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/home.jsp");
            }
        } else {
            // User is not logged in, redirect to the login page
            // Save the original requested URL to redirect back after successful login
            String requestURI = httpRequest.getRequestURI();
            if (httpRequest.getQueryString() != null) {
                requestURI += "?" + httpRequest.getQueryString();
            }
            session = httpRequest.getSession(); // Create session to store the URL
            session.setAttribute("preLoginURL", requestURI);
            
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/auth-login.jsp");
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
