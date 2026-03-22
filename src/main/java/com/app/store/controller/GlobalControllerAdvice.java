package com.app.store.controller;

import com.app.store.entity.Cart;
import com.app.store.entity.CartItem;
import com.app.store.entity.User;
import com.app.store.repository.UserRepository;
import com.app.store.service.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.security.Principal;

@ControllerAdvice
@RequiredArgsConstructor
public class GlobalControllerAdvice {

    private final UserRepository userRepository;
    private final CartService cartService;

    @ModelAttribute("currentUser")
    public User getCurrentUser(Principal principal) {
        if (principal != null) {
            return userRepository.findByEmail(principal.getName()).orElse(null);
        }
        return null;
    }

    @ModelAttribute("cartCount")
    public Integer getCartItemCount(Principal principal) {
        if (principal != null) {
            User user = userRepository.findByEmail(principal.getName()).orElse(null);
            if (user != null) {
                Cart cart = cartService.getCartForUser(user);
                if (cart != null && cart.getItems() != null) {
                    return cart.getItems().stream().mapToInt(CartItem::getQuantity).sum();
                }
            }
        }
        return 0;
    }
}
