package service;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

/**
 * EmailService - Dịch vụ gửi email
 */
public class EmailService {
    
    private static Properties emailConfig;
    private static final String CONFIG_FILE = "config.properties";
    
    static {
        loadConfig();
    }
    
    /**
     * Load email configuration từ file properties
     */
    private static void loadConfig() {
        emailConfig = new Properties();
        try (InputStream input = EmailService.class.getClassLoader().getResourceAsStream(CONFIG_FILE)) {
            if (input == null) {
                System.out.println("Unable to find " + CONFIG_FILE);
                return;
            }
            emailConfig.load(input);
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
    
    /**
     * Tạo email session
     */
    private static Session getEmailSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", emailConfig.getProperty("EMAIL_HOST"));
        props.put("mail.smtp.port", emailConfig.getProperty("EMAIL_PORT"));
        props.put("mail.smtp.ssl.trust", emailConfig.getProperty("EMAIL_HOST"));
        
        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(
                    emailConfig.getProperty("EMAIL_USER"),
                    emailConfig.getProperty("EMAIL_PASS")
                );
            }
        });
    }
    
    /**
     * Gửi email verification
     */
    public static boolean sendVerificationEmail(String toEmail, String userName, String token) {
        try {
            String appUrl = emailConfig.getProperty("APP_URL");
            String verificationLink = appUrl + "/verify-email?token=" + token;
            
            String subject = "Xác thực tài khoản - Nhà Thuốc MS";
            String htmlContent = buildVerificationEmailHTML(userName, verificationLink);
            
            return sendEmail(toEmail, subject, htmlContent);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Gửi email reset password
     */
    public static boolean sendPasswordResetEmail(String toEmail, String userName, String token) {
        try {
            String appUrl = emailConfig.getProperty("APP_URL");
            String resetLink = appUrl + "/reset-password?token=" + token;
            
            String subject = "Đặt lại mật khẩu - Nhà Thuốc MS";
            String htmlContent = buildPasswordResetEmailHTML(userName, resetLink);
            
            return sendEmail(toEmail, subject, htmlContent);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Gửi email (core method)
     */
    private static boolean sendEmail(String toEmail, String subject, String htmlContent) {
        try {
            Session session = getEmailSession();
            
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(
                emailConfig.getProperty("EMAIL_FROM"),
                emailConfig.getProperty("EMAIL_FROM_NAME")
            ));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(htmlContent, "text/html; charset=UTF-8");
            
            Transport.send(message);
            
            System.out.println("Email sent successfully to: " + toEmail);
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Build HTML template cho email verification
     */
    private static String buildVerificationEmailHTML(String userName, String verificationLink) {
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<meta charset='UTF-8'>" +
            "<style>" +
            "body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
            ".container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
            ".header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }" +
            ".content { background: #f9f9f9; padding: 30px; }" +
            ".button { display: inline-block; padding: 15px 30px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; text-decoration: none; border-radius: 5px; margin: 20px 0; }" +
            ".footer { text-align: center; padding: 20px; color: #666; font-size: 12px; }" +
            "</style>" +
            "</head>" +
            "<body>" +
            "<div class='container'>" +
            "<div class='header'>" +
            "<h1>🏥 Nhà Thuốc MS</h1>" +
            "</div>" +
            "<div class='content'>" +
            "<h2>Xin chào " + userName + "!</h2>" +
            "<p>Cảm ơn bạn đã đăng ký tài khoản tại <strong>Nhà Thuốc MS</strong>.</p>" +
            "<p>Để hoàn tất đăng ký, vui lòng xác thực địa chỉ email của bạn bằng cách nhấp vào nút bên dưới:</p>" +
            "<div style='text-align: center;'>" +
            "<a href='" + verificationLink + "' class='button'>Xác thực Email</a>" +
            "</div>" +
            "<p>Hoặc copy link sau vào trình duyệt:</p>" +
            "<p style='background: #fff; padding: 10px; border: 1px solid #ddd; word-break: break-all;'>" + verificationLink + "</p>" +
            "<p><strong>Lưu ý:</strong> Link này sẽ hết hạn sau 24 giờ.</p>" +
            "<p>Nếu bạn không đăng ký tài khoản này, vui lòng bỏ qua email này.</p>" +
            "</div>" +
            "<div class='footer'>" +
            "<p>© 2025 Nhà Thuốc MS. All rights reserved.</p>" +
            "</div>" +
            "</div>" +
            "</body>" +
            "</html>";
    }
    
    /**
     * Build HTML template cho password reset
     */
    private static String buildPasswordResetEmailHTML(String userName, String resetLink) {
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<meta charset='UTF-8'>" +
            "<style>" +
            "body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
            ".container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
            ".header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }" +
            ".content { background: #f9f9f9; padding: 30px; }" +
            ".button { display: inline-block; padding: 15px 30px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; text-decoration: none; border-radius: 5px; margin: 20px 0; }" +
            ".warning { background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 15px 0; }" +
            ".footer { text-align: center; padding: 20px; color: #666; font-size: 12px; }" +
            "</style>" +
            "</head>" +
            "<body>" +
            "<div class='container'>" +
            "<div class='header'>" +
            "<h1>🔒 Đặt lại mật khẩu</h1>" +
            "</div>" +
            "<div class='content'>" +
            "<h2>Xin chào " + userName + "!</h2>" +
            "<p>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.</p>" +
            "<p>Để đặt lại mật khẩu, vui lòng nhấp vào nút bên dưới:</p>" +
            "<div style='text-align: center;'>" +
            "<a href='" + resetLink + "' class='button'>Đặt lại mật khẩu</a>" +
            "</div>" +
            "<p>Hoặc copy link sau vào trình duyệt:</p>" +
            "<p style='background: #fff; padding: 10px; border: 1px solid #ddd; word-break: break-all;'>" + resetLink + "</p>" +
            "<div class='warning'>" +
            "<strong>⚠️ Lưu ý quan trọng:</strong>" +
            "<ul>" +
            "<li>Link này sẽ hết hạn sau <strong>1 giờ</strong></li>" +
            "<li>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này</li>" +
            "<li>Không chia sẻ link này với bất kỳ ai</li>" +
            "</ul>" +
            "</div>" +
            "</div>" +
            "<div class='footer'>" +
            "<p>© 2025 Nhà Thuốc MS. All rights reserved.</p>" +
            "</div>" +
            "</div>" +
            "</body>" +
            "</html>";
    }
}
