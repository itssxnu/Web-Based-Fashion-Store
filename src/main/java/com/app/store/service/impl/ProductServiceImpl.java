package com.app.store.service.impl;

import com.app.store.dto.ProductDto;
import com.app.store.entity.Product;
import com.app.store.repository.ProductRepository;
import com.app.store.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProductServiceImpl implements ProductService {

    private final ProductRepository productRepository;
    private final com.app.store.repository.UserRepository userRepository;
    private final org.springframework.jdbc.core.JdbcTemplate jdbcTemplate;

    @Override
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    @Override
    public Product getProductById(Long id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Invalid product id: " + id));
    }

    @Override
    public Product createProduct(ProductDto productDto) {

        com.app.store.entity.User productOwner = null;
        if (productDto.getSellerId() != null) {
            productOwner = userRepository.findById(productDto.getSellerId()).orElse(null);
        }

        Product product = Product.builder()
                .title(productDto.getTitle())
                .description(productDto.getDescription())
                .basePrice(productDto.getBasePrice())
                .category(productDto.getCategory())
                .mainImageUrl(productDto.getMainImageUrl())
                .seller(productOwner)
                .additionalImageUrls(productDto.getAdditionalImageUrls() != null ? productDto.getAdditionalImageUrls()
                        : new java.util.ArrayList<>())
                .build();

        if (productDto.getVariants() != null) {
            List<com.app.store.entity.ProductVariant> variants = productDto.getVariants().stream()
                    .map(v -> com.app.store.entity.ProductVariant.builder()
                            .product(product)
                            .size(v.getSize())
                            .color(v.getColor())
                            .stockQuantity(v.getStockQuantity() == null ? 0 : v.getStockQuantity())
                            .priceModifier(v.getPriceModifier() == null ? 0.0 : v.getPriceModifier())
                            .build())
                    .collect(java.util.stream.Collectors.toList());
            product.setVariants(variants);
        }

        return productRepository.save(product);
    }

    @Override
    public Product updateProduct(Long id, ProductDto productDto) {
        Product existingProduct = getProductById(id);

        existingProduct.setTitle(productDto.getTitle());
        existingProduct.setDescription(productDto.getDescription());
        existingProduct.setBasePrice(productDto.getBasePrice());
        existingProduct.setCategory(productDto.getCategory());
        existingProduct.setMainImageUrl(productDto.getMainImageUrl());

        if (productDto.getAdditionalImageUrls() != null) {
            existingProduct.setAdditionalImageUrls(productDto.getAdditionalImageUrls());
        } else {
            existingProduct.setAdditionalImageUrls(new java.util.ArrayList<>());
        }

        java.util.List<com.app.store.entity.ProductVariant> activeVariants = new java.util.ArrayList<>();
        if (existingProduct.getVariants() == null) {
            existingProduct.setVariants(new java.util.ArrayList<>());
        }

        if (productDto.getVariants() != null) {
            for (com.app.store.dto.ProductVariantDto v : productDto.getVariants()) {
                com.app.store.entity.ProductVariant existingVariant = existingProduct.getVariants().stream()
                        .filter(pv -> pv.getSize().equalsIgnoreCase(v.getSize())
                                && pv.getColor().equalsIgnoreCase(v.getColor()))
                        .findFirst()
                        .orElse(null);

                if (existingVariant != null) {
                    existingVariant.setStockQuantity(v.getStockQuantity() == null ? 0 : v.getStockQuantity());
                    existingVariant.setPriceModifier(v.getPriceModifier() == null ? 0.0 : v.getPriceModifier());
                    activeVariants.add(existingVariant);
                } else {
                    com.app.store.entity.ProductVariant newVariant = com.app.store.entity.ProductVariant.builder()
                            .product(existingProduct)
                            .size(v.getSize())
                            .color(v.getColor())
                            .stockQuantity(v.getStockQuantity() == null ? 0 : v.getStockQuantity())
                            .priceModifier(v.getPriceModifier() == null ? 0.0 : v.getPriceModifier())
                            .build();
                    activeVariants.add(newVariant);
                }
            }
        }

        
        
        for (com.app.store.entity.ProductVariant oldVariant : existingProduct.getVariants()) {
            if (!activeVariants.contains(oldVariant)) {
                oldVariant.setStockQuantity(0);
                activeVariants.add(oldVariant);
            }
        }

        existingProduct.getVariants().clear();
        existingProduct.getVariants().addAll(activeVariants);

        return productRepository.save(existingProduct);
    }

    @Override
    @org.springframework.transaction.annotation.Transactional
    public void deleteProduct(Long id) {
        
        
        
        
        jdbcTemplate.update(
                "DELETE FROM order_items WHERE product_variant_id IN (SELECT id FROM product_variants WHERE product_id = ?)",
                id);
        jdbcTemplate.update(
                "DELETE FROM cart_items WHERE product_variant_id IN (SELECT id FROM product_variants WHERE product_id = ?)",
                id);

        jdbcTemplate.update("DELETE FROM bids WHERE auction_id IN (SELECT id FROM auctions WHERE product_id = ?)", id);
        jdbcTemplate.update("DELETE FROM auctions WHERE product_id = ?", id);

        Product product = getProductById(id);
        productRepository.delete(product);
    }

    @Override
    public List<Product> getNewArrivals() {
        return productRepository.findTop8ByOrderByCreatedAtDesc();
    }

    @Override
    public List<Product> searchProducts(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllProducts();
        }
        return productRepository.searchByKeyword(keyword);
    }

    @Override
    public List<Product> getProductsByCategory(String category) {
        return productRepository.findByCategory(category);
    }

    @Override
    public List<Product> getProductsWithFilterAndSort(String keyword, String category, String sortOrder) {
        org.springframework.data.jpa.domain.Specification<Product> spec = (root, query, cb) -> cb.conjunction();

        
        if (keyword != null && !keyword.trim().isEmpty()) {
            spec = spec.and((root, query, cb) -> cb.or(
                    cb.like(cb.lower(root.get("title")), "%" + keyword.toLowerCase() + "%"),
                    cb.like(cb.lower(root.get("description")), "%" + keyword.toLowerCase() + "%")));
        }

        
        if (category != null && !category.trim().isEmpty() && !category.equalsIgnoreCase("all")) {
            spec = spec.and((root, query, cb) -> cb.equal(cb.lower(root.get("category")), category.toLowerCase()));
        }

        
        org.springframework.data.domain.Sort sort = org.springframework.data.domain.Sort.unsorted();
        if ("price_asc".equals(sortOrder)) {
            sort = org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.ASC,
                    "basePrice");
        } else if ("price_desc".equals(sortOrder)) {
            sort = org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.DESC,
                    "basePrice");
        } else if ("newest".equals(sortOrder)) {
            sort = org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.DESC,
                    "createdAt");
        }

        return productRepository.findAll(spec, sort);
    }
}
