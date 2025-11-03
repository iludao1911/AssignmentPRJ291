/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;

public class OrderDetail {
    private int orderDetailId;
    private int orderId;
    private int medicineId;
    private int quantity;
    private BigDecimal price;
    private BigDecimal subtotal;
    
    // Additional fields from JOIN query
    private String medicineName;
    private String medicineImage;

    public OrderDetail() {}

    public OrderDetail(int orderId, int medicineId, int quantity, BigDecimal price) {
        this.orderId = orderId;
        this.medicineId = medicineId;
        this.quantity = quantity;
        this.price = price;
    }

    // Getter & Setter
    public int getOrderDetailId() { return orderDetailId; }
    public void setOrderDetailId(int orderDetailId) { this.orderDetailId = orderDetailId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getMedicineId() { return medicineId; }
    public void setMedicineId(int medicineId) { this.medicineId = medicineId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    
    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }
    
    public String getMedicineName() { return medicineName; }
    public void setMedicineName(String medicineName) { this.medicineName = medicineName; }
    
    public String getMedicineImage() { return medicineImage; }
    public void setMedicineImage(String medicineImage) { this.medicineImage = medicineImage; }
    
    /**
     * Alias method for compatibility with check-out.jsp
     */
    public BigDecimal getTotalPrice() {
        return subtotal != null ? subtotal : price.multiply(new BigDecimal(quantity));
    }
}

