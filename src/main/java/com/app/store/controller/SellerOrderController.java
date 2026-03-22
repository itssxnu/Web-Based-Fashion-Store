package com.app.store.controller;

import com.app.store.entity.OrderItem;
import com.app.store.entity.OrderStatus;
import com.app.store.entity.User;
import com.app.store.repository.OrderItemRepository;
import com.app.store.repository.UserRepository;
import com.app.store.service.OrderLifecycleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/seller/orders")
@RequiredArgsConstructor
public class SellerOrderController {

    private final OrderItemRepository orderItemRepository;
    private final OrderLifecycleService orderLifecycleService;
    private final UserRepository userRepository;

    private User getAuthenticatedSeller(Principal principal) {
        if (principal == null)
            return null;
        return userRepository.findByEmail(principal.getName()).orElse(null);
    }

    
    @GetMapping
    public String viewSellerOrders(Principal principal, Model model) {
        User seller = getAuthenticatedSeller(principal);
        if (seller == null)
            return "redirect:/login";

        List<OrderItem> items = orderItemRepository.findByProductVariantProductSellerOrderByOrderCreatedAtDesc(seller);
        model.addAttribute("orderItems", items);
        model.addAttribute("currentUser", seller);

        return "seller/orders";
    }

    
    @PostMapping("/{itemId}/status")
    public String updateItemStatus(@PathVariable("itemId") Long itemId,
            @RequestParam("status") OrderStatus newStatus,
            Principal principal,
            RedirectAttributes redirectAttributes) {
        User seller = getAuthenticatedSeller(principal);
        if (seller == null)
            return "redirect:/login";

        try {
            orderLifecycleService.updateItemStatusBySeller(itemId, seller, newStatus);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Item marked as " + newStatus.name().toLowerCase() + " successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return "redirect:/seller/orders";
    }

    
    @PostMapping("/{itemId}/refund")
    public String processRefund(@PathVariable("itemId") Long itemId, Principal principal, RedirectAttributes redirectAttributes) {
        User seller = getAuthenticatedSeller(principal);
        if (seller == null)
            return "redirect:/login";

        try {
            orderLifecycleService.processRefund(itemId, seller);
            redirectAttributes.addFlashAttribute("successMessage", "Refund issued successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return "redirect:/seller/orders";
    }
}
