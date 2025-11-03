package model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

public class Order {
    private int orderId;
    private int userId; // Đổi từ customerId thành userId
    private Timestamp orderDate;
    private double totalAmount; // Đổi từ BigDecimal thành double
    private String status; // Thêm field status
    private String shippingAddress; // Thêm field shippingAddress
    private List<OrderDetail> orderDetails;
    private String paymentMethod;
    
    // User info (from JOIN)
    private String userName;
    private String userEmail;

    public Order() {}

    public Order(int userId, double totalAmount) {
        this.userId = userId;
        this.totalAmount = totalAmount;
    }

    public Order(String paymentMethod, String shippingAddress) {
        this.paymentMethod = paymentMethod;
        this.shippingAddress = shippingAddress;
    }

    // Getter & Setter
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    // Giữ lại customerId cho backward compatibility
    public int getCustomerId() { return userId; }
    public void setCustomerId(int customerId) { this.userId = customerId; }

    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public List<OrderDetail> getOrderDetails() { return orderDetails; }
    public void setOrderDetails(List<OrderDetail> orderDetails) { this.orderDetails = orderDetails; }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    // Giữ lại address cho backward compatibility
    public String getAddress() { return shippingAddress; }
    public void setAddress(String address) { this.shippingAddress = address; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    @Override
    public String toString() {
        return "Order{" +
                "orderId=" + orderId +
                ", userId=" + userId +
                ", orderDate=" + orderDate +
                ", totalAmount=" + totalAmount +
                ", status='" + status + '\'' +
                ", shippingAddress='" + shippingAddress + '\'' +
                '}';
    }
}

