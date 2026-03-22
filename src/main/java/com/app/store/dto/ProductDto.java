package com.app.store.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class ProductDto {
    private Long id;

    @NotBlank(message = "Title is required")
    private String title;

    @NotBlank(message = "Description is required")
    private String description;

    @NotNull(message = "Base price is required")
    @PositiveOrZero(message = "Price must be non-negative")
    private Double basePrice;

    @NotBlank(message = "Category is required")
    private String category;

    
    @NotBlank(message = "Image URL is required")
    private String mainImageUrl;

    
    private Long sellerId;

    private List<ProductVariantDto> variants = new ArrayList<>();

    private List<String> additionalImageUrls = new ArrayList<>();
}
