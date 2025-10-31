package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Forward to profile page
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");

        try {
            // Get updated info from form
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");

            // Update basic info
            if (name != null && !name.trim().isEmpty()) {
                currentUser.setName(name.trim());
            }
            if (phone != null) {
                currentUser.setPhone(phone.trim());
            }
            // Note: address is not a field in User model, it's only used in Order (shipping_address)
            // if (address != null) {
            //     currentUser.setAddress(address.trim());
            // }

            // Update password if provided
            boolean passwordChanged = false;
            if (currentPassword != null && !currentPassword.trim().isEmpty()
                && newPassword != null && !newPassword.trim().isEmpty()) {

                // Verify current password
                User dbUser = userDAO.getUserById(currentUser.getUserId());
                if (dbUser != null && dbUser.getPassword().equals(currentPassword)) {
                    currentUser.setPassword(newPassword);
                    passwordChanged = true;
                } else {
                    request.setAttribute("error", "Mật khẩu hiện tại không đúng");
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                    return;
                }
            }

            // Update in database
            boolean updated = userDAO.updateUser(currentUser);

            if (updated) {
                // Update session
                session.setAttribute("currentUser", currentUser);

                String successMsg = passwordChanged ?
                    "Cập nhật thông tin và mật khẩu thành công!" :
                    "Cập nhật thông tin thành công!";
                request.setAttribute("success", successMsg);
            } else {
                request.setAttribute("error", "Không thể cập nhật thông tin");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}
