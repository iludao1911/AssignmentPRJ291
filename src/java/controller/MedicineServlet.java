package controller;

import dao.MedicineDAO;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Medicine;
import service.IMedicineService;
import service.MedicineServiceImpl;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/medicines")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class MedicineServlet extends HttpServlet {

    private IMedicineService medicineService;
    private static final String UPLOAD_DIR = "image";
    private ServletContext context;

    @Override
    public void init() throws ServletException {
        this.medicineService = new MedicineServiceImpl(new MedicineDAO());
        this.context = getServletContext();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "delete":
                    deleteMedicine(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "sale":
                    showSaleForm(request, response);
                    break;
                case "searchName":
                    searchMedicines(request, response);
                    break;
                case "filterByCategory":
                    listMedicinesByCategory(request, response);
                    break;
                default:
                    listMedicines(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        request.setCharacterEncoding("UTF-8");

        try {
            if ("insert".equals(action)) {
                insertMedicine(request, response);
            } else if ("update".equals(action)) {
                updateMedicine(request, response);
            } else if ("updateSale".equals(action)) {
                updateSale(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void searchMedicines(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String name = request.getParameter("name");
        String sortOrder = request.getParameter("sort");
        int page = 1;
        int recordsPerPage = 10;
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        List<Medicine> listMedicine = medicineService.searchMedicines(name, (page - 1) * recordsPerPage, recordsPerPage, sortOrder);
        int totalRecords = medicineService.getSearchTotalCount(name);
        int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);
        List<String> categories = medicineService.getDistinctCategories();

        request.setAttribute("listMedicine", listMedicine);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchName", name);
        request.setAttribute("categories", categories);
        request.setAttribute("sortOrder", sortOrder);
        request.getRequestDispatcher("/medicine/ListMedicine.jsp").forward(request, response);
    }

    private void listMedicines(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        String sortOrder = request.getParameter("sort");
        int page = 1;
        int recordsPerPage = 10;
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        List<Medicine> listMedicine = medicineService.getMedicines((page - 1) * recordsPerPage, recordsPerPage, sortOrder);
        int totalRecords = medicineService.getTotalMedicineCount();
        int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);
        List<String> categories = medicineService.getDistinctCategories();

        request.setAttribute("listMedicine", listMedicine);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("categories", categories);
        request.setAttribute("sortOrder", sortOrder);
        request.getRequestDispatcher("/medicine/ListMedicine.jsp").forward(request, response);
    }

    private void listMedicinesByCategory(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String category = request.getParameter("category");
        String sortOrder = request.getParameter("sort");
        int page = 1;
        int recordsPerPage = 10;
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        List<Medicine> listMedicine = medicineService.getMedicinesByCategory(category, (page - 1) * recordsPerPage, recordsPerPage, sortOrder);
        int totalRecords = medicineService.getTotalCountByCategory(category);
        int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);
        List<String> categories = medicineService.getDistinctCategories();

        request.setAttribute("listMedicine", listMedicine);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("sortOrder", sortOrder);
        request.getRequestDispatcher("/medicine/ListMedicine.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/medicine/createMedicine.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Medicine existingMedicine = medicineService.getMedicineById(id);
        request.setAttribute("medicine", existingMedicine);
        request.getRequestDispatcher("/medicine/editMedicine.jsp").forward(request, response);
    }

    private void showSaleForm(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Medicine existingMedicine = medicineService.getMedicineById(id);
        request.setAttribute("medicine", existingMedicine);
        request.getRequestDispatcher("/medicine/saleMedicine.jsp").forward(request, response);
    }

    private void insertMedicine(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        // Lấy dữ liệu từ form
        int supplierId = Integer.parseInt(request.getParameter("supplierId"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String category = request.getParameter("category");
        Date expiryDate = Date.valueOf(request.getParameter("expiryDate"));

        // Xử lý upload ảnh
        Part filePart = request.getPart("image_path");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String imagePath = null;
        if (fileName != null && !fileName.isEmpty()) {
            imagePath = handleImageUpload(filePart, fileName);
        }

        Medicine newMedicine = new Medicine(0, supplierId, name, description, price, null, quantity, category, expiryDate, imagePath);
        try {
            medicineService.saveMedicine(newMedicine);
            response.sendRedirect(request.getContextPath() + "/medicines");
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMsg", e.getMessage());
            request.getRequestDispatcher("/medicine/createMedicine.jsp").forward(request, response);
        }
    }

    private void updateMedicine(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        int supplierId = Integer.parseInt(request.getParameter("supplierId"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String category = request.getParameter("category");
        Date expiryDate = Date.valueOf(request.getParameter("expiryDate"));

        // Lấy ảnh mới
        Part filePart = request.getPart("image");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String imagePath;

        // Lấy thông tin thuốc hiện tại để giữ lại salePrice và imagePath nếu không có ảnh mới
        Medicine existingMedicine = medicineService.getMedicineById(id);
        BigDecimal salePrice = existingMedicine.getSalePrice(); // Giữ lại sale price

        if (fileName != null && !fileName.isEmpty()) {
            // Nếu có ảnh mới thì upload và cập nhật path
            imagePath = handleImageUpload(filePart, fileName);
        } else {
            // Nếu không, giữ lại ảnh cũ
            imagePath = existingMedicine.getImagePath();
        }

        Medicine medicine = new Medicine(id, supplierId, name, description, price, salePrice, quantity, category, expiryDate, imagePath);
        try {
            medicineService.updateMedicine(medicine);
            response.sendRedirect(request.getContextPath() + "/medicines");
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMsg", e.getMessage());
            request.setAttribute("medicine", medicine);
            request.getRequestDispatcher("/medicine/editMedicine.jsp").forward(request, response);
        }
    }

    private void updateSale(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        BigDecimal salePrice = new BigDecimal(request.getParameter("salePrice"));

        Medicine existingMedicine = medicineService.getMedicineById(id);
        existingMedicine.setSalePrice(salePrice);

        medicineService.updateMedicine(existingMedicine);
        response.sendRedirect(request.getContextPath() + "/medicines");
    }

    private void deleteMedicine(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        medicineService.deleteMedicine(id);
        response.sendRedirect(request.getContextPath() + "/medicines");
    }

    private String handleImageUpload(Part filePart, String fileName) throws IOException {
        // Path for build/web/image
        String buildPath = this.context.getRealPath("") + UPLOAD_DIR;
        File buildDir = new File(buildPath);
        if (!buildDir.exists()) {
            buildDir.mkdirs();
        }
        String buildFilePath = buildPath + File.separator + fileName;

        // Path for web/image (source)
        String sourcePath = "c:\\Users\\Windows\\Documents\\NetBeansProjects\\asm1\\web\\image";
        File sourceDir = new File(sourcePath);
        if (!sourceDir.exists()) {
            sourceDir.mkdirs();
        }
        String sourceFilePath = sourcePath + File.separator + fileName;

        // Use a temporary file to avoid reading the input stream twice
        File tempFile = File.createTempFile("upload-", ".tmp");
        tempFile.deleteOnExit();
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, tempFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }

        // Copy from the temp file to the final destinations
        Files.copy(tempFile.toPath(), Paths.get(buildFilePath), StandardCopyOption.REPLACE_EXISTING);
        Files.copy(tempFile.toPath(), Paths.get(sourceFilePath), StandardCopyOption.REPLACE_EXISTING);

        return fileName;
    }
}
