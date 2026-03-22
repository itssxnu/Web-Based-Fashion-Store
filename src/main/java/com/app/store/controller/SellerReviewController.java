package com.app.store.controller;

import com.app.store.entity.Review;
import com.app.store.entity.User;
import com.app.store.repository.UserRepository;
import com.app.store.service.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/seller/reviews")
@RequiredArgsConstructor
public class SellerReviewController {

    private final ReviewService reviewService;
    private final UserRepository userRepository;

    private User getAuthenticatedSeller(Principal principal) {
        if (principal == null) return null;
        return userRepository.findByEmail(principal.getName()).orElse(null);
    }

    @GetMapping
    public String listSellerReviews(Model model, Principal principal) {
        User seller = getAuthenticatedSeller(principal);
        if (seller == null) return "redirect:/login";

        List<Review> reviews = reviewService.getReviewsForSeller(seller.getId());
        model.addAttribute("reviews", reviews);

        return "seller/reviews";
    }

    @PostMapping("/reply")
    public String replyToReview(@RequestParam("reviewId") Long reviewId,
                                @RequestParam("reply") String reply,
                                Principal principal,
                                RedirectAttributes redirectAttributes) {
        User seller = getAuthenticatedSeller(principal);
        if (seller == null) return "redirect:/login";

        try {
            reviewService.addSellerReply(seller, reviewId, reply);
            redirectAttributes.addFlashAttribute("successMessage", "Reply added successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to add reply: " + e.getMessage());
        }

        return "redirect:/seller/reviews";
    }
}
