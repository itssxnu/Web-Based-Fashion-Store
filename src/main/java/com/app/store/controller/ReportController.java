package com.app.store.controller;

import com.app.store.entity.User;
import com.app.store.repository.UserRepository;
import com.app.store.service.ReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;

@Controller
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportController {

    private final ReportService reportService;
    private final UserRepository userRepository;

    @PostMapping("/seller")
    public String reportSeller(@RequestParam("sellerId") Long sellerId,
                               @RequestParam("orderId") Long orderId,
                               @RequestParam("reason") String reason,
                               @RequestParam("description") String description,
                               Principal principal,
                               RedirectAttributes redirectAttributes) {
        
        if (principal == null) {
            return "redirect:/login";
        }

        User user = userRepository.findByEmail(principal.getName()).orElse(null);
        if (user == null) {
            return "redirect:/login";
        }

        try {
            reportService.submitReport(user, sellerId, orderId, reason, description);
            redirectAttributes.addFlashAttribute("successMessage", "Report submitted successfully! We will review this shortly.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to submit report: " + e.getMessage());
        }

        return "redirect:/user/orders";
    }
}
