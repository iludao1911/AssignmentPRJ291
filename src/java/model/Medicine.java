package model;

import java.math.BigDecimal;
import java.sql.Date;

public class Medicine {
    private int medicineId;
    private int supplierId;
    private String name;
    private String description;
    private BigDecimal price;
    private int quantity;
    private String category;
    private Date expiryDate;
    private String imagePath;
    
    public Medicine() {}

    public Medicine(int medicineId, int supplierId, String name, String description, BigDecimal price, int quantity, String category, Date expiryDate, String imagePath) {
        this.medicineId = medicineId;
        this.supplierId = supplierId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.quantity = quantity;
        this.category = category;
        this.expiryDate = expiryDate;
        this.imagePath = imagePath;
    }

    public int getMedicineId() { return medicineId; }
    public void setMedicineId(int medicineId) { this.medicineId = medicineId; }
    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public Date getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Date expiryDate) { this.expiryDate = expiryDate; }
    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
}