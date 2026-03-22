package com.app.store.controller;

import com.app.store.entity.Product;
import com.app.store.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class ComparisonController {

    private final ProductService productService;

    @GetMapping("/compare")
    public String showComparison(@RequestParam(value = "ids", required = false) List<Long> ids, Model model) {

        if (ids == null || ids.size() < 2) {
            model.addAttribute("error", "Please select at least 2 products to compare.");
            return "redirect:/shop";
        }

        
        if (ids.size() > 4) {
            ids = ids.subList(0, 4);
        }

        List<Product> products = new ArrayList<>();
        Double lowestPrice = Double.MAX_VALUE;

        for (Long id : ids) {
            try {
                Product p = productService.getProductById(id);
                products.add(p);
                if (p.getBasePrice() < lowestPrice) {
                    lowestPrice = p.getBasePrice();
                }
            } catch (IllegalArgumentException e) {
            }
        }

        if (products.size() < 2) {
            model.addAttribute("error", "Not enough valid products found for comparison.");
            return "redirect:/shop";
        }

        model.addAttribute("products", products);
        model.addAttribute("lowestPrice", lowestPrice);

        return "product/compare";
    }
}
