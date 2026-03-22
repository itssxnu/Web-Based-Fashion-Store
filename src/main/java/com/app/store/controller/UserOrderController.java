package com.app.store.controller;

import com.app.store.entity.Order;

import com.app.store.entity.User;
import com.app.store.repository.UserRepository;
import com.app.store.service.OrderLifecycleService;
import com.app.store.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.app.store.entity.OrderItem;
import com.app.store.entity.ProductVariant;
import com.app.store.service.CartService;

import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/user/orders")
@RequiredArgsConstructor
public class UserOrderController {

    private final OrderService orderService;
    private final OrderLifecycleService orderLifecycleService;
    private final CartService cartService;
    private final UserRepository userRepository;

    private User getAuthenticatedUser(Principal principal) {
        if (principal == null)
            return null;
        return userRepository.findByEmail(principal.getName()).orElse(null);
    }

    
    @GetMapping
    public String viewOrderHistory(Principal principal, Model model) {
        User user = getAuthenticatedUser(principal);
        if (user == null)
            return "redirect:/login";

        List<Order> orders = orderService.getUserOrders(user);
        model.addAttribute("orders", orders);

        return "user/orders";
    }

    
    @PostMapping("/items/{itemId}/return")
    public String requestReturn(@PathVariable("itemId") Long itemId, Principal principal, RedirectAttributes redirectAttributes) {
        User buyer = getAuthenticatedUser(principal);
        if (buyer == null)
            return "redirect:/login";

        try {
            orderLifecycleService.requestReturnByUser(itemId, buyer);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Return requested successfully. The seller has been notified.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return "redirect:/user/orders";
    }

    
    @GetMapping("/{orderId}/invoice")
    public String viewInvoice(@PathVariable("orderId") Long orderId, Principal principal, Model model,
            RedirectAttributes redirectAttributes) {
        User user = getAuthenticatedUser(principal);
        if (user == null)
            return "redirect:/login";

        try {
            Order order = orderService.getOrderById(orderId, user);
            model.addAttribute("order", order);
            model.addAttribute("user", user);
            return "user/invoice";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Unable to retrieve invoice: " + e.getMessage());
            return "redirect:/user/orders";
        }
    }

    
    @PostMapping("/{orderId}/reorder")
    public String reorderItems(@PathVariable("orderId") Long orderId, Principal principal, RedirectAttributes redirectAttributes) {
        User user = getAuthenticatedUser(principal);
        if (user == null)
            return "redirect:/login";

        try {
            Order order = orderService.getOrderById(orderId, user);
            int itemsAdded = 0;
            int itemsSkipped = 0;

            for (OrderItem item : order.getItems()) {
                ProductVariant variant = item.getProductVariant();
                
                if (variant == null || variant.getProduct() == null) {
                    itemsSkipped++;
                    continue;
                }

                
                int qtyToAdd = Math.min(item.getQuantity(), variant.getStockQuantity());

                if (qtyToAdd > 0) {
                    cartService.addToCart(user, variant.getId(), qtyToAdd);
                    itemsAdded++;
                } else {
                    itemsSkipped++;
                }
            }

            if (itemsAdded > 0 && itemsSkipped == 0) {
                redirectAttributes.addFlashAttribute("successMessage", "All items successfully added to your cart!");
            } else if (itemsAdded > 0 && itemsSkipped > 0) {
                redirectAttributes.addFlashAttribute("successMessage",
                        "Added available items to your cart. Some items were out of stock or unavailable.");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage",
                        "Could not reorder. All items from this order are currently out of stock or unavailable.");
            }

            return "redirect:/cart";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to initiate reorder: " + e.getMessage());
            return "redirect:/user/orders";
        }
    }
}
