package com.app.store.controller;

import com.app.store.dto.ProductDto;
import com.app.store.entity.Product;
import com.app.store.repository.CategoryRepository;
import com.app.store.service.ProductService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/products")
@RequiredArgsConstructor
public class AdminProductController {

    private final ProductService productService;
    private final CategoryRepository categoryRepository;

    @GetMapping
    public String listProducts(Model model) {
        model.addAttribute("products", productService.getAllProducts());
        return "admin/product-list";
    }

    @GetMapping("/new")
    public String createProductForm(Model model) {
        model.addAttribute("productDto", new ProductDto());
        model.addAttribute("categories", categoryRepository.findAll());
        return "admin/product-form";
    }

    @PostMapping("/new")
    public String saveProduct(@Valid @ModelAttribute("productDto") ProductDto productDto,
            BindingResult result,
            Model model) {
        if (result.hasErrors()) {
            return "admin/product-form";
        }

        try {
            productService.createProduct(productDto);
            return "redirect:/admin/products?success=Created successfully";
        } catch (Exception e) {
            model.addAttribute("error", "Failed to save product: " + e.getMessage());
            return "admin/product-form";
        }
    }

    @GetMapping("/{id}/edit")
    public String editProductForm(@PathVariable("id") Long id, Model model) {
        try {
            Product product = productService.getProductById(id);
            ProductDto dto = new ProductDto();
            dto.setId(product.getId());
            dto.setTitle(product.getTitle());
            dto.setDescription(product.getDescription());
            dto.setBasePrice(product.getBasePrice());
            dto.setCategory(product.getCategory());
            dto.setMainImageUrl(product.getMainImageUrl());
            dto.setAdditionalImageUrls(product.getAdditionalImageUrls() != null
                    ? new java.util.ArrayList<>(product.getAdditionalImageUrls())
                    : new java.util.ArrayList<>());

            if (product.getVariants() != null) {
                List<com.app.store.dto.ProductVariantDto> variantDtos = product.getVariants().stream().map(v -> {
                    com.app.store.dto.ProductVariantDto varDto = new com.app.store.dto.ProductVariantDto();
                    varDto.setId(v.getId());
                    varDto.setSize(v.getSize());
                    varDto.setColor(v.getColor());
                    varDto.setStockQuantity(v.getStockQuantity());
                    varDto.setPriceModifier(v.getPriceModifier());
                    return varDto;
                }).collect(java.util.stream.Collectors.toList());
                dto.setVariants(variantDtos);
            }

            model.addAttribute("productDto", dto);
            model.addAttribute("categories", categoryRepository.findAll());
            return "admin/product-form";
        } catch (Exception e) {
            return "redirect:/admin/products?error=Product not found";
        }
    }

    @PostMapping("/{id}/edit")
    public String updateProduct(@PathVariable("id") Long id,
            @Valid @ModelAttribute("productDto") ProductDto productDto,
            BindingResult result,
            Model model) {
        if (result.hasErrors()) {
            return "admin/product-form";
        }

        try {
            productService.updateProduct(id, productDto);
            return "redirect:/admin/products?success=Updated successfully";
        } catch (Exception e) {
            model.addAttribute("error", "Failed to update product: " + e.getMessage());
            return "admin/product-form";
        }
    }

    @GetMapping("/{id}/delete")
    public String deleteProduct(@PathVariable("id") Long id) {
        try {
            productService.deleteProduct(id);
            return "redirect:/admin/products?success=Deleted successfully";
        } catch (Exception e) {
            return "redirect:/admin/products?error=Deletion failed";
        }
    }
}
