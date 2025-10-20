package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // Cấu hình thông tin kết nối
    private static final String DRIVER_NAME = "com.microsoft.sqlserver.jdbc.SQLServerDriver";

    // THAY THẾ DÒNG NÀY BẰNG SERVER NAME CỦA BẠN
    // LƯU Ý: Nếu server name có dấu '\', bạn phải viết thành '\\'
    // Ví dụ nếu server name của bạn là LAPTOP-7E2TLBDI\SQLEXPRESS
    private static final String DB_URL = "jdbc:sqlserver://LAPTOP-7E2TLBDI\\SQLEXPRESS;databaseName= Project;encrypt=true;trustServerCertificate=true;";
    // THAY THẾ BẰNG LOGIN CỦA BẠN
    private static final String USER_DB = "khoa";

    // THAY THẾ BẰNG MẬT KHẨU CỦA BẠN
    private static final String PASS_DB = "123";

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName(DRIVER_NAME);
            con = DriverManager.getConnection(DB_URL, USER_DB, PASS_DB);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return con;
    }

    public static void main(String[] args) {
        Connection con = getConnection();
        if (con != null) {
            System.out.println("Connect to PT1 Success");
        } else {
            System.out.println("Connect to PT1 Failed");
        }
    }
}
