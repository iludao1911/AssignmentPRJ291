package controller;

import dao.UserDAO;
import model.User;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "BanUserServlet", urlPatterns = {"/admin/users/ban"})
public class BanUserServlet extends HttpServlet {
    
    private UserDAO userDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Check if user is admin
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("currentUser") == null) {
                result.put("success", false);
                result.put("message", "Vui lòng đăng nhập");
                out.print(gson.toJson(result));
                return;
            }
            
            User currentUser = (User) session.getAttribute("currentUser");
            if (!currentUser.isAdmin()) {
                result.put("success", false);
                result.put("message", "Bạn không có quyền thực hiện thao tác này");
                out.print(gson.toJson(result));
                return;
            }
            
            // Read JSON body
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            
            // Parse JSON
            Map<String, Object> requestData = gson.fromJson(sb.toString(), Map.class);
            int userId = ((Double) requestData.get("userId")).intValue();
            String action = (String) requestData.get("action");
            
            // Validate
            if (userId <= 0) {
                result.put("success", false);
                result.put("message", "ID người dùng không hợp lệ");
                out.print(gson.toJson(result));
                return;
            }
            
            // Don't allow banning yourself
            if (userId == currentUser.getUserId()) {
                result.put("success", false);
                result.put("message", "Không thể cấm tài khoản của chính mình");
                out.print(gson.toJson(result));
                return;
            }
            
            // Perform action
            boolean success = false;
            String message = "";
            
            if ("ban".equals(action)) {
                success = userDAO.banUser(userId);
                message = success ? "Đã cấm tài khoản thành công" : "Không thể cấm tài khoản";
            } else if ("unban".equals(action)) {
                success = userDAO.unbanUser(userId);
                message = success ? "Đã mở khóa tài khoản thành công" : "Không thể mở khóa tài khoản";
            } else {
                result.put("success", false);
                result.put("message", "Hành động không hợp lệ");
                out.print(gson.toJson(result));
                return;
            }
            
            result.put("success", success);
            result.put("message", message);
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra: " + e.getMessage());
            e.printStackTrace();
        }
        
        out.print(gson.toJson(result));
    }
}
