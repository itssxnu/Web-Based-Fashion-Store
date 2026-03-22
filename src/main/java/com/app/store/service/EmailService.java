package com.app.store.service;

import com.app.store.entity.Cart;
import com.app.store.entity.Order;
import com.app.store.entity.OrderItem;
import com.app.store.entity.User;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmailService {

    private final JavaMailSender javaMailSender;

    @Value("${spring.mail.username}")
    private String senderEmail;

    
    @Async
    public void sendOtpEmail(String toEmail, String otpCode) {
        if (senderEmail == null || senderEmail.contains("YOUR_EMAIL")) {
            log.warn("SMTP credentials unconfigured. Attempted to send OTP {} to {}", otpCode, toEmail);
            return;
        }

        try {
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(senderEmail);
            helper.setTo(toEmail);
            helper.setSubject("QC. - Verify Your Registration");

            String htmlContent = buildOtpEmailTemplate(otpCode);
            helper.setText(htmlContent, true); 

            javaMailSender.send(message);
            log.info("OTP verification email securely transmitted to {}", toEmail);

        } catch (MessagingException e) {
            log.error("Failed to transmit OTP email to {}. Reason: {}", toEmail, e.getMessage());
        }
    }

    private String buildOtpEmailTemplate(String otpCode) {
        return """
                <!DOCTYPE html>
                <html>
                <body style="font-family: 'Inter', Arial, sans-serif; background-color: #f8fafc; margin: 0; padding: 40px 0;">
                    <div style="max-width: 500px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); overflow: hidden;">
                        <div style="background-color: #0f172a; padding: 25px; text-align: center;">
                            <span style="color: #ffffff; font-size: 24px; font-weight: 700; letter-spacing: 2px;">QC.</span>
                        </div>
                        <div style="padding: 40px 30px; text-align: center;">
                            <h2 style="color: #0f172a; font-size: 20px; font-weight: 600; margin-top: 0; margin-bottom: 15px;">Verify Your Email</h2>
                            <p style="color: #64748b; font-size: 15px; line-height: 1.5; margin-bottom: 30px;">
                                Thank you for joining QC. Please use the following 6-digit verification code to complete your registration.
                            </p>
                            <div style="background-color: #f1f5f9; border-radius: 6px; padding: 20px; margin-bottom: 30px; border: 1px dashed #cbd5e1;">
                                <span style="font-size: 32px; font-weight: 700; letter-spacing: 5px; color: #0f172a;">%s</span>
                            </div>
                            <p style="color: #94a3b8; font-size: 13px; margin-bottom: 0;">
                                If you did not request this code, please ignore this email.
                            </p>
                        </div>
                    </div>
                </body>
                </html>
                """
                .formatted(otpCode);
    }

    @Async
    public void sendOrderConfirmation(User user, Order order) {
        if (senderEmail == null || senderEmail.contains("YOUR_EMAIL")) {
            log.warn("SMTP credentials unconfigured. Console Dump for Order Confirmation #{}", order.getId());
            return;
        }

        try {
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(senderEmail);
            helper.setTo(user.getEmail());
            helper.setSubject("QC. - Order Confirmation #" + order.getId());

            String htmlContent = buildOrderConfirmationTemplate(user, order);
            helper.setText(htmlContent, true);

            javaMailSender.send(message);
            log.info("Order Confirmation email securely transmitted to {}", user.getEmail());

        } catch (MessagingException e) {
            log.error("Failed to transmit Order Confirmation email to {}. Reason: {}", user.getEmail(), e.getMessage());
        }
    }

    @Async
    public void sendAbandonedCartReminder(String toEmail, Cart cart) {
        if (senderEmail == null || senderEmail.contains("YOUR_EMAIL"))
            return;

        try {
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(senderEmail);
            helper.setTo(toEmail);
            helper.setSubject("QC. - Did you forget something?");

            String htmlContent = buildAbandonedCartTemplate();
            helper.setText(htmlContent, true);
            javaMailSender.send(message);
            log.info("Abandoned Cart reminder transmitted to {}", toEmail);

        } catch (MessagingException e) {
            log.error("Failed to transmit Abandoned Cart email. {}", e.getMessage());
        }
    }

    private String buildOrderConfirmationTemplate(User user, Order order) {
        StringBuilder itemsHtml = new StringBuilder();
        for (OrderItem item : order.getItems()) {
            itemsHtml.append("<tr>")
                    .append("<td style='padding: 10px; border-bottom: 1px solid #eee;'>")
                    .append(item.getProductVariant().getProduct().getTitle()).append("</td>")
                    .append("<td style='padding: 10px; border-bottom: 1px solid #eee; text-align: center;'>")
                    .append(item.getQuantity()).append("</td>")
                    .append("<td style='padding: 10px; border-bottom: 1px solid #eee; text-align: right;'>LKR ")
                    .append(String.format("%.2f", item.getPriceAtTimeOfPurchase())).append("</td>")
                    .append("</tr>");
        }

        return """
                <!DOCTYPE html>
                <html>
                <body style="font-family: 'Inter', Arial, sans-serif; background-color: #f8fafc; margin: 0; padding: 40px 0;">
                    <div style="max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); overflow: hidden;">
                        <div style="background-color: #10b981; padding: 25px; text-align: center;">
                            <span style="color: #ffffff; font-size: 24px; font-weight: 700; letter-spacing: 2px;">QC.</span>
                        </div>
                        <div style="padding: 40px 30px;">
                            <h2 style="color: #0f172a; margin-top: 0;">Order Confirmed!</h2>
                            <p style="color: #64748b; line-height: 1.5;">Hi %s,</p>
                            <p style="color: #64748b; line-height: 1.5;">Thank you for shopping with QuickCart! Your order <b>#%d</b> has been received and is now processing.</p>

                            <table style="width: 100%%; border-collapse: collapse; margin-top: 20px; font-size: 14px;">
                                <thead>
                                    <tr style="background-color: #f1f5f9; color: #475569; text-align: left;">
                                        <th style="padding: 10px;">Item</th>
                                        <th style="padding: 10px; text-align: center;">Qty</th>
                                        <th style="padding: 10px; text-align: right;">Price</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    %s
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td colspan="2" style="padding: 10px; text-align: right; font-weight: 600;">Total:</td>
                                        <td style="padding: 10px; text-align: right; font-weight: 600;">LKR %.2f</td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                        <div style="background-color: #f8fafc; padding: 20px; text-align: center; font-size: 12px; color: #94a3b8;">
                            Thank you for choosing QuickCart.
                        </div>
                    </div>
                </body>
                </html>
                """
                .formatted(user.getName(), order.getId(), itemsHtml.toString(), order.getTotalAmount());
    }

    private String buildAbandonedCartTemplate() {
        return """
                <!DOCTYPE html>
                <html>
                <body style="font-family: 'Inter', Arial, sans-serif; background-color: #f8fafc; margin: 0; padding: 40px 0;">
                    <div style="max-width: 500px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); overflow: hidden;">
                        <div style="background-color: #0f172a; padding: 25px; text-align: center;">
                            <span style="color: #ffffff; font-size: 24px; font-weight: 700; letter-spacing: 2px;">QC.</span>
                        </div>
                        <div style="padding: 40px 30px; text-align: center;">
                            <h2 style="color: #0f172a; font-size: 20px; margin-top: 0; margin-bottom: 15px;">Still Deciding?</h2>
                            <p style="color: #64748b; font-size: 15px; line-height: 1.5; margin-bottom: 30px;">
                                We noticed you left some amazing items in your shopping cart! They're flying off the shelves, so come back to complete your checkout before they're gone.
                            </p>
                            <a href="http://localhost:8085/cart" style="display: inline-block; background-color: #10b981; color: #ffffff; padding: 12px 24px; text-decoration: none; border-radius: 4px; font-weight: 600;">Return to Cart</a>
                        </div>
                    </div>
                </body>
                </html>
                """;
    }

    @Async
    public void sendCheckoutOtpEmail(String toEmail, String otpCode) {
        if (senderEmail == null || senderEmail.contains("YOUR_EMAIL")) {
            log.warn("SMTP credentials unconfigured. Attempted to send Checkout OTP {} to {}", otpCode, toEmail);
            return;
        }

        try {
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(senderEmail);
            helper.setTo(toEmail);
            helper.setSubject("QC. - Verify Your Checkout");

            String htmlContent = buildCheckoutOtpEmailTemplate(otpCode);
            helper.setText(htmlContent, true);

            javaMailSender.send(message);
            log.info("Checkout OTP verification email securely transmitted to {}", toEmail);

        } catch (MessagingException e) {
            log.error("Failed to transmit Checkout OTP email to {}. Reason: {}", toEmail, e.getMessage());
        }
    }

    private String buildCheckoutOtpEmailTemplate(String otpCode) {
        return """
                <!DOCTYPE html>
                <html>
                <body style="font-family: 'Inter', Arial, sans-serif; background-color: #f8fafc; margin: 0; padding: 40px 0;">
                    <div style="max-width: 500px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); overflow: hidden;">
                        <div style="background-color: #0f172a; padding: 25px; text-align: center;">
                            <span style="color: #ffffff; font-size: 24px; font-weight: 700; letter-spacing: 2px;">QC.</span>
                        </div>
                        <div style="padding: 40px 30px; text-align: center;">
                            <h2 style="color: #0f172a; font-size: 20px; font-weight: 600; margin-top: 0; margin-bottom: 15px;">Verify Your Identity</h2>
                            <p style="color: #64748b; font-size: 15px; line-height: 1.5; margin-bottom: 30px;">
                                You are about to proceed to checkout. Please use the following 6-digit verification code to confirm it's you.
                            </p>
                            <div style="background-color: #f1f5f9; border-radius: 6px; padding: 20px; margin-bottom: 30px; border: 1px dashed #cbd5e1;">
                                <span style="font-size: 32px; font-weight: 700; letter-spacing: 5px; color: #0f172a;">%s</span>
                            </div>
                            <p style="color: #94a3b8; font-size: 13px; margin-bottom: 0;">
                                If you did not initiate this checkout, please ignore this email and secure your account.
                            </p>
                        </div>
                    </div>
                </body>
                </html>
                """
                .formatted(otpCode);
    }

}
