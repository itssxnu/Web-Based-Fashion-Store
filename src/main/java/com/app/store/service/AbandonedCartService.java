package com.app.store.service;

import com.app.store.entity.Cart;
import com.app.store.repository.CartRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class AbandonedCartService {

    private final CartRepository cartRepository;
    private final EmailService emailService;

    
    
    @Scheduled(cron = "0 */5 * * * *")
    public void scanAndRemindAbandonedCarts() {
        log.info("Scanning for abandoned carts...");
        
        LocalDateTime thresholds = LocalDateTime.now().minusHours(24);

        
        List<Cart> allCarts = cartRepository.findAll();
        long emailsSent = 0;

        for (Cart cart : allCarts) {
            if (cart.getItems() != null && !cart.getItems().isEmpty()) {
                if (cart.getUpdatedAt() != null && cart.getUpdatedAt().isBefore(thresholds)) {
                    
                    log.info("Abandoned cart detected for user {}", cart.getUser().getEmail());
                    emailService.sendAbandonedCartReminder(cart.getUser().getEmail(), cart);

                    
                    
                    cart.setUpdatedAt(LocalDateTime.now());
                    cartRepository.save(cart);
                    emailsSent++;
                }
            }
        }
        log.info("Abandoned Cart Scan complete. Sent {} reminder emails.", emailsSent);
    }
}
