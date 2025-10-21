package model;

// public class Customer { ... } 
// (Giả định đã có cột password trong lớp này để khớp với DB)
public class Customer {

    private int customerId;
    private String name;
    private String email;
    private String phone;
    private String password;

    public Customer() {
    }

    // Getters and Setters...
    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
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
}
