package com.app.store.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ProductVariantDto {
    private Long id;

    @NotBlank(message = "Size is required (e.g., S, M, L, OS)")
    private String size;

    @NotBlank(message = "Color is required")
    private String color;

    @Min(value = 0, message = "Stock quantity cannot be negative")
    private Integer stockQuantity = 0;

    private Double priceModifier = 0.0;
}
