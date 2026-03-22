package com.app.store;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.boot.CommandLineRunner;
import org.springframework.jdbc.core.JdbcTemplate;

@SpringBootApplication
public class StoreApplication {

    public static void main(String[] args) {
        SpringApplication.run(StoreApplication.class, args);
    }

    @Bean
    public CommandLineRunner updateRoleEnum(JdbcTemplate jdbcTemplate) {
        return args -> {
            try {
                jdbcTemplate.execute(
                        "ALTER TABLE users MODIFY COLUMN role ENUM('ADMIN', 'USER', 'SELLER') DEFAULT 'USER';");
                System.out.println("Successfully updated 'role' column enum values.");

                
                jdbcTemplate.execute(
                        "INSERT IGNORE INTO categories (name, description) VALUES " +
                                "('T-Shirts', 'Essential upper body wear'), " +
                                "('Pants', 'Jeans, trousers, and sweatpants'), " +
                                "('Hoodies', 'Warm and comfortable outerwear'), " +
                                "('Accessories', 'Hats, bags, and jewelry')");
                System.out.println("Seeded Default Product Categories");

                
                jdbcTemplate.execute(
                        "INSERT IGNORE INTO store_policies (topic, content, created_at, updated_at) VALUES " +
                                "('Return Policy', 'We accept returns within 7 days after purchase if the tag is still attached.', NOW(), NOW()), "
                                +
                                "('Delivery Policy', 'We offer standard island wide delivery within 3-5 business days. Express delivery takes 1-2 business days. Orders above 12000 LKR qualify for free standard delivery. Tracking details are sent via email once the order is dispatched.', NOW(), NOW()), "
                                +
                                "('Exchange Policy', 'Exchanges are allowed within 7 days for size or color changes, subject to stock availability. Customers must provide the original receipt or order confirmation.', NOW(), NOW()), "
                                +
                                "('Payment Methods', 'We accept Visa, Amex and MasterCard. All payments are processed securely through encrypted payment gateways.', NOW(), NOW()), "
                                +
                                "('Contact Sellers', 'You can contact sellers you purchased from. Head over to Order history and you''ll see a contact seller option.', NOW(), NOW())");
                System.out.println("Seeded Default Store Policies");

            } catch (Exception e) {
                System.err.println("Database startup script failed: " + e.getMessage());
            }
        };
    }
}
