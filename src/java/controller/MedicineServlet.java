package controller;

import dao.MedicineDAO;
import dao.SupplierDAO;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Medicine;
import model.Supplier;
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

@WebServlet("/admin/medicines")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class MedicineServlet extends HttpServlet {

    private IMedicineService medicineService;
    private SupplierDAO supplierDAO;
    private static final String UPLOAD_DIR = "image";
    private ServletContext context;

    @Override
    public void init() throws ServletException {
        this.medicineService = new MedicineServiceImpl(new MedicineDAO());
        this.supplierDAO = new SupplierDAO();
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
        request.getRequestDispatcher("/admin/medicines.jsp").forward(request, response);
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
        request.getRequestDispatcher("/admin/medicines.jsp").forward(request, response);
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
        request.getRequestDispatcher("/admin/medicines.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Supplier> suppliers = supplierDAO.getAllSuppliers();
            request.setAttribute("suppliers", suppliers);
            request.setAttribute("action", "insert");
            request.getRequestDispatcher("/product-form.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Medicine existingMedicine = medicineService.getMedicineById(id);
        List<Supplier> suppliers = supplierDAO.getAllSuppliers();
        request.setAttribute("medicine", existingMedicine);
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("action", "update");
        request.getRequestDispatcher("/product-form.jsp").forward(request, response);
    }

    private void showSaleForm(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Medicine existingMedicine = medicineService.getMedicineById(id);
        request.setAttribute("medicine", existingMedicine);
        request.setAttribute("action", "updateSale");
        request.getRequestDispatcher("/product-form.jsp").forward(request, response);
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
        String imagePath = null;
        Part filePart = request.getPart("imageFile");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            if (fileName != null && !fileName.isEmpty()) {
                imagePath = handleImageUpload(filePart, fileName);
            }
        }

        Medicine newMedicine = new Medicine(0, supplierId, name, description, price, null, quantity, category, expiryDate, imagePath);
        try {
            medicineService.saveMedicine(newMedicine);
            response.sendRedirect(request.getContextPath() + "/admin/medicines");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("action", "insert");
            request.getRequestDispatcher("/product-form.jsp").forward(request, response);
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

        // Lấy thông tin thuốc hiện tại để giữ lại salePrice và imagePath nếu không có ảnh mới
        Medicine existingMedicine = medicineService.getMedicineById(id);
        BigDecimal salePrice = existingMedicine.getSalePrice(); // Giữ lại sale price
        String imagePath = existingMedicine.getImagePath(); // Mặc định giữ ảnh cũ

        // Xử lý upload ảnh mới
        Part filePart = request.getPart("imageFile");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            if (fileName != null && !fileName.isEmpty()) {
                imagePath = handleImageUpload(filePart, fileName);
            }
        }

        Medicine medicine = new Medicine(id, supplierId, name, description, price, salePrice, quantity, category, expiryDate, imagePath);
        try {
            medicineService.updateMedicine(medicine);
            response.sendRedirect(request.getContextPath() + "/admin/medicines");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("medicine", medicine);
            request.setAttribute("action", "update");
            request.getRequestDispatcher("/product-form.jsp").forward(request, response);
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
        response.sendRedirect(request.getContextPath() + "/admin/medicines");
    }

    private String handleImageUpload(Part filePart, String fileName) throws IOException {
        // Tạo tên file unique để tránh trùng
        String fileExtension = "";
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex > 0) {
            fileExtension = fileName.substring(dotIndex);
        }
        String uniqueFileName = System.currentTimeMillis() + fileExtension;
        
        // Đường dẫn thư mục build (runtime)
        String buildPath = this.context.getRealPath("/") + UPLOAD_DIR;
        File buildDir = new File(buildPath);
        if (!buildDir.exists()) {
            buildDir.mkdirs();
        }

        // Đường dẫn thư mục source (để giữ lại khi rebuild)
        String projectPath = System.getProperty("user.dir");
        String sourcePath = projectPath + File.separator + "web" + File.separator + UPLOAD_DIR;
        File sourceDir = new File(sourcePath);
        if (!sourceDir.exists()) {
            sourceDir.mkdirs();
        }

        // Lưu file vào cả 2 nơi
        String buildFilePath = buildPath + File.separator + uniqueFileName;
        String sourceFilePath = sourcePath + File.separator + uniqueFileName;

        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, Paths.get(buildFilePath), StandardCopyOption.REPLACE_EXISTING);
        }

        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, Paths.get(sourceFilePath), StandardCopyOption.REPLACE_EXISTING);
        }

        return UPLOAD_DIR + "/" + uniqueFileName;
    }
}
