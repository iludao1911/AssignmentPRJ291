package model;

import java.util.Date;

/**
 * Model User - Đại diện cho người dùng trong hệ thống (Admin & Customer)
 */
public class User {

    private int userId;
    private String name;
    private String email;
    private String phone;
    private String password;
    private String role; // "Admin" hoặc "Customer"
    private boolean isVerified;
    private Date createdAt;
    private String image; // Avatar/profile image URL

    public User() {
    }

    public User(int userId, String name, String email, String phone, String password, String role) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.role = role;
        this.isVerified = false;
    }

    // Getters and Setters
    
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isVerified() {
        return isVerified;
    }

    public void setVerified(boolean verified) {
        isVerified = verified;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    // Helper methods
    
    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
    
    public boolean isAdmin() {
        return "Admin".equalsIgnoreCase(this.role);
    }

    public boolean isCustomer() {
        return "Customer".equalsIgnoreCase(this.role);
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", role='" + role + '\'' +
                ", isVerified=" + isVerified +
                ", createdAt=" + createdAt +
                ", image='" + image + '\'' +
                '}';
    }
}
