package com.app.store.service;

import com.app.store.dto.ProductDto;
import com.app.store.entity.Product;

import java.util.List;

public interface ProductService {
    List<Product> getAllProducts();

    Product getProductById(Long id);

    Product createProduct(ProductDto productDto);

    Product updateProduct(Long id, ProductDto productDto);

    void deleteProduct(Long id);

    
    List<Product> getNewArrivals();

    List<Product> searchProducts(String keyword);

    List<Product> getProductsByCategory(String category);

    
    List<Product> getProductsWithFilterAndSort(String keyword, String category, String sort);
}
