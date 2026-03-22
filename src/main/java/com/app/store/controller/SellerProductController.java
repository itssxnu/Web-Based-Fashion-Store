package com.app.store.controller;

import com.app.store.dto.ProductDto;
import com.app.store.entity.Product;
import com.app.store.entity.User;
import com.app.store.repository.CategoryRepository;
import com.app.store.repository.ProductRepository;
import com.app.store.repository.UserRepository;
import com.app.store.service.ProductService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/seller/products")
@RequiredArgsConstructor
public class SellerProductController {

    private final ProductService productService;
    private final ProductRepository productRepository;
    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;

    private User getAuthenticatedSeller(Principal principal) {
        return userRepository.findByEmail(principal.getName())
                .orElseThrow(() -> new IllegalArgumentException("Seller not found"));
    }

    @GetMapping
    public String listProducts(Model model, Principal principal) {
        User seller = getAuthenticatedSeller(principal);
        
        List<Product> sellerProducts = productRepository.findBySellerIdOrderByCreatedAtDesc(seller.getId());
        model.addAttribute("products", sellerProducts);
        return "seller/product-list";
    }

    @GetMapping("/new")
    public String createProductForm(Model model) {
        model.addAttribute("productDto", new ProductDto());
        model.addAttribute("categories", categoryRepository.findAll());
        return "seller/product-form";
    }

    @PostMapping("/new")
    public String saveProduct(@Valid @ModelAttribute("productDto") ProductDto productDto,
            BindingResult result,
            Principal principal,
            Model model) {
        if (result.hasErrors()) {
            return "seller/product-form";
        }

        try {
            User seller = getAuthenticatedSeller(principal);
            
            
            productDto.setSellerId(seller.getId());

            productService.createProduct(productDto);
            return "redirect:/seller/products?success=Created successfully";
        } catch (Exception e) {
            model.addAttribute("error", "Failed to save product: " + e.getMessage());
            return "seller/product-form";
        }
    }

    @GetMapping("/{id}/edit")
    public String editProductForm(@PathVariable("id") Long id, Principal principal, Model model) {
        try {
            User seller = getAuthenticatedSeller(principal);
            Product product = productService.getProductById(id);

            
            if (product.getSeller() == null || !product.getSeller().getId().equals(seller.getId())) {
                return "redirect:/seller/products?error=Unauthorized to edit this product";
            }

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
            return "seller/product-form";
        } catch (Exception e) {
            return "redirect:/seller/products?error=Product not found";
        }
    }

    @PostMapping("/{id}/edit")
    public String updateProduct(@PathVariable("id") Long id,
            @Valid @ModelAttribute("productDto") ProductDto productDto,
            BindingResult result,
            Principal principal,
            Model model) {
        if (result.hasErrors()) {
            return "seller/product-form";
        }

        try {
            User seller = getAuthenticatedSeller(principal);
            Product product = productService.getProductById(id);

            if (product.getSeller() == null || !product.getSeller().getId().equals(seller.getId())) {
                return "redirect:/seller/products?error=Unauthorized to update this product";
            }

            
            productDto.setSellerId(seller.getId());
            productService.updateProduct(id, productDto);

            return "redirect:/seller/products?success=Updated successfully";
        } catch (Exception e) {
            model.addAttribute("error", "Failed to update product: " + e.getMessage());
            return "seller/product-form";
        }
    }

    @GetMapping("/{id}/delete")
    public String deleteProduct(@PathVariable("id") Long id, Principal principal) {
        try {
            User seller = getAuthenticatedSeller(principal);
            Product product = productService.getProductById(id);

            if (product.getSeller() == null || !product.getSeller().getId().equals(seller.getId())) {
                return "redirect:/seller/products?error=Unauthorized to delete this product";
            }

            productService.deleteProduct(id);
            return "redirect:/seller/products?success=Deleted successfully";
        } catch (Exception e) {
            return "redirect:/seller/products?error=Deletion failed";
        }
    }
}
