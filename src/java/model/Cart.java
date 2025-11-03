package model;

import java.sql.Timestamp;

/**
 * Model đại diện cho bảng Cart trong database
 */
public class Cart {
    private int cartId;
    private int userId;
    private int medicineId;
    private int quantity;
    private Timestamp addedAt;
    
    // Medicine details (from JOIN query)
    private String medicineName;
    private String medicineImage;
    private double medicinePrice;
    private Double medicineSalePrice;

    public Cart() {
    }

    public Cart(int cartId, int userId, int medicineId, int quantity, Timestamp addedAt) {
        this.cartId = cartId;
        this.userId = userId;
        this.medicineId = medicineId;
        this.quantity = quantity;
        this.addedAt = addedAt;
    }

    // Getters and Setters
    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Timestamp getAddedAt() {
        return addedAt;
    }

    public void setAddedAt(Timestamp addedAt) {
        this.addedAt = addedAt;
    }

    public String getMedicineName() {
        return medicineName;
    }

    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
    }

    public String getMedicineImage() {
        return medicineImage;
    }

    public void setMedicineImage(String medicineImage) {
        this.medicineImage = medicineImage;
    }

    public double getMedicinePrice() {
        return medicinePrice;
    }

    public void setMedicinePrice(double medicinePrice) {
        this.medicinePrice = medicinePrice;
    }

    public Double getMedicineSalePrice() {
        return medicineSalePrice;
    }

    public void setMedicineSalePrice(Double medicineSalePrice) {
        this.medicineSalePrice = medicineSalePrice;
    }

    /**
     * Tính giá hiệu lực (sale price nếu có, không thì price gốc)
     */
    public double getEffectivePrice() {
        return (medicineSalePrice != null && medicineSalePrice > 0) ? medicineSalePrice : medicinePrice;
    }

    /**
     * Tính tổng giá cho item này
     */
    public double getTotalPrice() {
        return getEffectivePrice() * quantity;
    }
    
    /**
     * Setter methods for compatibility with check-out.jsp
     */
    public void setPrice(java.math.BigDecimal price) {
        this.medicinePrice = price.doubleValue();
    }
    
    public void setTotalPrice(java.math.BigDecimal totalPrice) {
        // This is calculated, but we provide setter for JSP compatibility
        // Do nothing or you can store it if needed
    }

    @Override
    public String toString() {
        return "Cart{" +
                "cartId=" + cartId +
                ", userId=" + userId +
                ", medicineId=" + medicineId +
                ", quantity=" + quantity +
                ", medicineName='" + medicineName + '\'' +
                ", medicinePrice=" + medicinePrice +
                ", medicineSalePrice=" + medicineSalePrice +
                '}';
    }
}

