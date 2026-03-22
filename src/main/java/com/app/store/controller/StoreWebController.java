package com.app.store.controller;

import com.app.store.entity.Product;
import com.app.store.repository.ProductRepository;
import com.app.store.repository.UserRepository;
import com.app.store.service.ProductService;
import com.app.store.service.RecommendationService;
import com.app.store.service.ReviewService;
import com.app.store.entity.Review;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class StoreWebController {

    private final ProductService productService;
    private final UserRepository userRepository;
    private final RecommendationService recommendationService;
    private final ReviewService reviewService;

    private final ProductRepository productRepository;

    @ModelAttribute("globalCategories")
    public List<String> globalCategories() {
        return productRepository.findDistinctCategories();
    }

    @GetMapping(value = { "/", "/index" })
    public String index(Model model, @AuthenticationPrincipal UserDetails userDetails) {
        model.addAttribute("products", productService.getNewArrivals());

        if (userDetails != null) {
            userRepository.findByEmail(userDetails.getUsername()).ifPresent(user -> {
                List<Product> recentlyExplored = recommendationService.getRecentlyExploredProducts(user, 10);
                model.addAttribute("recentlyExplored", recentlyExplored);

                
            });
        }

        return "index";
    }

    @GetMapping("/shop")
    public String shop(@RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "sort", required = false) String sort,
            Model model) {

        List<Product> products = productService.getProductsWithFilterAndSort(keyword, category, sort);
        model.addAttribute("products", products);

        
        model.addAttribute("currentKeyword", keyword);
        model.addAttribute("currentCategory", category);
        model.addAttribute("currentSort", sort);

        return "shop";
    }

    @GetMapping("/about")
    public String about() {
        return "about";
    }

    @GetMapping("/login")
    public String login() {
        return "login"; 
    }

    @GetMapping("/product/{id}")
    public String productDetails(@org.springframework.web.bind.annotation.PathVariable Long id, Model model,
            @AuthenticationPrincipal UserDetails userDetails) {
        try {
            Product product = productService.getProductById(id);
            model.addAttribute("product", product);

            if (userDetails != null) {
                userRepository.findByEmail(userDetails.getUsername()).ifPresent(user -> {
                    recommendationService.trackProductView(user, product);
                });
            }

            model.addAttribute("frequentlyBoughtTogether", recommendationService.getFrequentlyBoughtTogether(id));

            List<Review> reviews = reviewService.getReviewsForProduct(id);
            model.addAttribute("reviews", reviews);
            double avgRating = reviews.isEmpty() ? 0.0 : reviews.stream().mapToInt(Review::getRating).average().orElse(0.0);
            model.addAttribute("averageRating", avgRating);

            return "product-details";
        } catch (Exception e) {
            return "redirect:/shop?error=Product+not+found";
        }
    }
}
