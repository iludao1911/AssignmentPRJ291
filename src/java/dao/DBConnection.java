package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // Cấu hình thông tin kết nối
    private static final String DRIVER_NAME = "com.microsoft.sqlserver.jdbc.SQLServerDriver";

    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=Project;encrypt=false;trustServerCertificate=true;";
    private static final String USER_DB = "sa";
    private static final String PASS_DB = "123456";


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
