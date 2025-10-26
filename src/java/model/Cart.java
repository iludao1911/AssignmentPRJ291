/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

public class Cart {
    private Map<Integer, CartItem> items = new HashMap<>();

    public void addItem(Medicine medicine, int quantity) {
        int id = medicine.getMedicineId();
        if (items.containsKey(id)) {
            CartItem item = items.get(id);
            item.setQuantity(item.getQuantity() + quantity);
        } else {
            items.put(id, new CartItem(medicine, quantity));
        }
    }

    public void removeItem(int medicineId) {
        items.remove(medicineId);
    }

    public void updateQuantity(int medicineId, int quantity) {
        if (items.containsKey(medicineId)) {
            CartItem item = items.get(medicineId);
            item.setQuantity(quantity);
        }
    }

    public BigDecimal getTotalAmount() {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : items.values()) {
            total = total.add(item.getTotalPrice());
        }
        return total;
    }

    public Map<Integer, CartItem> getItems() {
        return items;
    }

    public void clear() {
        items.clear();
    }
}

