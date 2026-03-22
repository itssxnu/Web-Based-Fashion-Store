package com.app.store.controller;

import com.app.store.entity.Category;
import com.app.store.repository.CategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/categories")
@PreAuthorize("hasRole('ADMIN')")
@RequiredArgsConstructor
public class AdminCategoryController {

    private final CategoryRepository categoryRepository;

    @GetMapping
    public String listCategories(Model model) {
        model.addAttribute("categories", categoryRepository.findAll());
        model.addAttribute("newCategory", new Category());
        return "admin/category-list";
    }

    @PostMapping("/new")
    public String createCategory(@ModelAttribute("newCategory") Category category) {
        if (categoryRepository.findByName(category.getName()).isPresent()) {
            return "redirect:/admin/categories?error=Category+already+exists";
        }
        categoryRepository.save(category);
        return "redirect:/admin/categories?success=Category+created";
    }

    @GetMapping("/{id}/delete")
    public String deleteCategory(@PathVariable Long id) {
        categoryRepository.deleteById(id);
        return "redirect:/admin/categories?success=Category+deleted";
    }
}
