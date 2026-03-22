package com.app.store.controller;

import com.app.store.entity.Category;
import com.app.store.entity.Product;
import com.app.store.repository.CategoryRepository;
import com.app.store.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryRepository categoryRepository;
    private final ProductService productService;

    @GetMapping("/categories")
    public String viewCategoryGallery(Model model) {
        List<Category> allCategories = categoryRepository.findAll();
        model.addAttribute("categories", allCategories);
        return "category/list";
    }

    @GetMapping("/category/{name}")
    public String viewProductsInCategory(@PathVariable String name, Model model) {
        List<Product> products = productService.getProductsWithFilterAndSort(null, name, null);
        model.addAttribute("products", products);
        model.addAttribute("currentCategory", name);
        model.addAttribute("categoryFeatureTitle", name + " Collection");
        return "shop";
    }
}
