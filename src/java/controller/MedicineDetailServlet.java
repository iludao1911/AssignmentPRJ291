package controller;

import dao.MedicineDAO;
import dao.ReviewDAO;
import model.Medicine;
import model.Review;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet hiển thị chi tiết thuốc
 */
@WebServlet("/medicine-detail")
public class MedicineDetailServlet extends HttpServlet {

    private MedicineDAO medicineDAO = new MedicineDAO();
    private ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy medicine_id từ parameter
            String medicineIdStr = request.getParameter("id");
            if (medicineIdStr == null || medicineIdStr.isEmpty()) {
                response.sendRedirect("home.jsp");
                return;
            }
            
            int medicineId = Integer.parseInt(medicineIdStr);
            
            // Lấy thông tin thuốc
            Medicine medicine = medicineDAO.getMedicineById(medicineId);
            if (medicine == null) {
                response.sendRedirect("home.jsp");
                return;
            }
            
            // Lấy reviews
            List<Review> reviews = reviewDAO.getReviewsByMedicineId(medicineId);
            
            // Lấy rating trung bình và số lượng reviews
            double avgRating = reviewDAO.getAverageRating(medicineId);
            int reviewCount = reviewDAO.getReviewCount(medicineId);
            
            // Set attributes
            request.setAttribute("medicine", medicine);
            request.setAttribute("reviews", reviews);
            request.setAttribute("avgRating", avgRating);
            request.setAttribute("reviewCount", reviewCount);
            
            // Forward to JSP
            request.getRequestDispatcher("medicine-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("home.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
}
