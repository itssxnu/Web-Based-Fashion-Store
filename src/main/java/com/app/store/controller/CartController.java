package com.app.store.controller;

import com.app.store.entity.Cart;
import com.app.store.entity.User;
import com.app.store.repository.UserRepository;
import com.app.store.service.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;

@Controller
@RequestMapping("/cart")
@RequiredArgsConstructor
public class CartController {

    private final CartService cartService;
    private final UserRepository userRepository;

    private User getAuthenticatedUser(Principal principal) {
        if (principal == null)
            return null;
        return userRepository.findByEmail(principal.getName()).orElse(null);
    }

    @GetMapping
    public String viewCart(Model model, Principal principal) {
        User user = getAuthenticatedUser(principal);
        if (user == null) {
            return "redirect:/login";
        }

        Cart cart = cartService.getCartForUser(user);
        Double subtotal = cartService.calculateCartTotal(cart);
        Double deliveryCharge = cartService.calculateDeliveryCharge(subtotal);
        Double total = subtotal + deliveryCharge;

        model.addAttribute("cart", cart);
        model.addAttribute("subtotal", subtotal);
        model.addAttribute("deliveryCharge", deliveryCharge);
        model.addAttribute("total", total);

        return "cart";
    }

    @PostMapping("/add")
    public String addToCart(@RequestParam("variantId") Long variantId, @RequestParam("quantity") Integer quantity, Principal principal,
            RedirectAttributes redirectAttributes) {
        User user = getAuthenticatedUser(principal);
        if (user == null)
            return "redirect:/login";

        try {
            cartService.addToCart(user, variantId, quantity);
            return "redirect:/cart";
        } catch (Exception e) {
            redirectAttributes.addAttribute("error", e.getMessage());
            return "redirect:/shop";
        }
    }

    @PostMapping("/update")
    public String updateQuantity(@RequestParam("cartItemId") Long cartItemId, @RequestParam("quantity") Integer quantity, Principal principal) {
        User user = getAuthenticatedUser(principal);
        if (user == null)
            return "redirect:/login";

        try {
            cartService.updateQuantity(user, cartItemId, quantity);
        } catch (Exception ignored) {
        }

        return "redirect:/cart";
    }

    @PostMapping("/remove")
    public String removeFromCart(@RequestParam("cartItemId") Long cartItemId, Principal principal) {
        User user = getAuthenticatedUser(principal);
        if (user == null)
            return "redirect:/login";

        cartService.removeFromCart(user, cartItemId);
        return "redirect:/cart";
    }
}
