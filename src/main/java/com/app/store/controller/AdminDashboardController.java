package com.app.store.controller;

import com.app.store.repository.OrderItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminDashboardController {

    private final OrderItemRepository orderItemRepository;

    @GetMapping(value = { "", "/", "/dashboard" })
    public String dashboard(Model model) {
        
        List<Object[]> bestSellingRaw = orderItemRepository.findBestSellingProducts();
        List<Object[]> monthlyProfitsRaw = orderItemRepository.findMonthlyProfitReporting();
        List<Object[]> seasonalDemandRaw = orderItemRepository.findSeasonalDemand();

        
        model.addAttribute("bestSelling", bestSellingRaw);
        model.addAttribute("monthlyProfits", monthlyProfitsRaw);
        model.addAttribute("seasonalDemand", seasonalDemandRaw);

        return "admin/dashboard";
    }
}
