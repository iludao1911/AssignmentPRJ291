package model;

import java.util.Date;

/**
 * Model VerificationToken - Token cho Email Verification và Password Reset
 */
public class VerificationToken {

    private int tokenId;
    private int userId;
    private String token;
    private String tokenType; // "EMAIL_VERIFICATION" hoặc "PASSWORD_RESET"
    private Date expiryDate;
    private Date createdAt;
    private boolean used;

    // Token types constants
    public static final String EMAIL_VERIFICATION = "EMAIL_VERIFICATION";
    public static final String PASSWORD_RESET = "PASSWORD_RESET";

    public VerificationToken() {
    }

    public VerificationToken(int userId, String token, String tokenType, Date expiryDate) {
        this.userId = userId;
        this.token = token;
        this.tokenType = tokenType;
        this.expiryDate = expiryDate;
        this.used = false;
        this.createdAt = new Date();
    }

    // Getters and Setters

    public int getTokenId() {
        return tokenId;
    }

    public void setTokenId(int tokenId) {
        this.tokenId = tokenId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getTokenType() {
        return tokenType;
    }

    public void setTokenType(String tokenType) {
        this.tokenType = tokenType;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isUsed() {
        return used;
    }

    public void setUsed(boolean used) {
        this.used = used;
    }

    // Helper methods

    public boolean isExpired() {
        return new Date().after(this.expiryDate);
    }

    public boolean isValid() {
        return !this.used && !isExpired();
    }

    @Override
    public String toString() {
        return "VerificationToken{" +
                "tokenId=" + tokenId +
                ", userId=" + userId +
                ", token='" + token + '\'' +
                ", tokenType='" + tokenType + '\'' +
                ", expiryDate=" + expiryDate +
                ", used=" + used +
                '}';
    }
}
