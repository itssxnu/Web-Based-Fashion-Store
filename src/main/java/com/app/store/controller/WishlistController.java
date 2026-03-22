package com.app.store.controller;

import com.app.store.entity.User;
import com.app.store.entity.Wishlist;
import com.app.store.repository.UserRepository;
import com.app.store.service.WishlistService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;

@Controller
@RequestMapping("/wishlist")
@RequiredArgsConstructor
public class WishlistController {

    private final WishlistService wishlistService;
    private final UserRepository userRepository;

    private User getAuthenticatedUser(Principal principal) {
        if (principal == null)
            return null;
        return userRepository.findByEmail(principal.getName()).orElse(null);
    }

    @GetMapping
    public String viewWishlist(Model model, Principal principal) {
        User user = getAuthenticatedUser(principal);
        if (user == null)
            return "redirect:/login";

        Wishlist wishlist = wishlistService.getWishlistForUser(user);
        model.addAttribute("wishlist", wishlist);

        return "wishlist";
    }

    @PostMapping("/add")
    public String addToWishlist(@RequestParam("productId") Long productId, Principal principal,
            RedirectAttributes redirectAttributes, @RequestHeader(value = "Referer", required = false) String referer) {
        User user = getAuthenticatedUser(principal);
        if (user == null)
            return "redirect:/login";

        try {
            wishlistService.addToWishlist(user, productId);
            redirectAttributes.addFlashAttribute("successMessage", "Added to wishlist!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Could not add to wishlist.");
        }

        return "redirect:" + (referer != null ? referer : "/wishlist");
    }

    @PostMapping("/remove")
    public String removeFromWishlist(@RequestParam("wishlistItemId") Long wishlistItemId, Principal principal) {
        User user = getAuthenticatedUser(principal);
        if (user == null)
            return "redirect:/login";

        wishlistService.removeFromWishlist(user, wishlistItemId);
        return "redirect:/wishlist";
    }
}
