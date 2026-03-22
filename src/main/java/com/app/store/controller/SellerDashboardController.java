package com.app.store.controller;

import com.app.store.entity.User;
import com.app.store.repository.UserRepository;
import com.app.store.service.SellerDashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.security.Principal;

@Controller
@RequestMapping("/seller")
@RequiredArgsConstructor
public class SellerDashboardController {

    private final SellerDashboardService sellerDashboardService;
    private final UserRepository userRepository;

    @GetMapping("/dashboard")
    public String viewDashboard(Principal principal, Model model) {
        User seller = userRepository.findByEmail(principal.getName())
                .orElseThrow(() -> new IllegalArgumentException("Seller not found"));

        Double totalRevenue = sellerDashboardService.calculateTotalRevenue(seller);
        Integer totalUnitsSold = sellerDashboardService.calculateTotalUnitsSold(seller);

        
        model.addAttribute("lowStockAlerts", sellerDashboardService.getLowStockAlerts(seller, 10));
        
        model.addAttribute("recentOrders", sellerDashboardService.getRecentPurchaseAlerts(seller, 5));

        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("totalUnitsSold", totalUnitsSold);

        return "seller/dashboard";
    }
}
