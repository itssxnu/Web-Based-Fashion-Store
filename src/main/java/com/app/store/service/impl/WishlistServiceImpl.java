package com.app.store.service.impl;

import com.app.store.entity.Product;
import com.app.store.entity.User;
import com.app.store.entity.Wishlist;
import com.app.store.entity.WishlistItem;
import com.app.store.repository.ProductRepository;
import com.app.store.repository.WishlistRepository;
import com.app.store.service.WishlistService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class WishlistServiceImpl implements WishlistService {

    private final WishlistRepository wishlistRepository;
    private final ProductRepository productRepository;

    @Override
    public Wishlist getWishlistForUser(User user) {
        return wishlistRepository.findByUser(user).orElseGet(() -> {
            Wishlist newWishlist = Wishlist.builder().user(user).build();
            return wishlistRepository.save(newWishlist);
        });
    }

    @Override
    @Transactional
    public Wishlist addToWishlist(User user, Long productId) {
        Wishlist wishlist = getWishlistForUser(user);

        
        boolean exists = wishlist.getItems().stream()
                .anyMatch(item -> item.getProduct().getId().equals(productId));

        if (exists) {
            return wishlist; 
        }

        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        WishlistItem newItem = WishlistItem.builder()
                .wishlist(wishlist)
                .product(product)
                .build();

        wishlist.getItems().add(newItem);
        return wishlistRepository.save(wishlist);
    }

    @Override
    @Transactional
    public Wishlist removeFromWishlist(User user, Long wishlistItemId) {
        Wishlist wishlist = getWishlistForUser(user);
        wishlist.getItems().removeIf(item -> item.getId().equals(wishlistItemId));
        return wishlistRepository.save(wishlist);
    }

    @Override
    public boolean isProductInWishlist(User user, Long productId) {
        Wishlist wishlist = getWishlistForUser(user);
        return wishlist.getItems().stream()
                .anyMatch(item -> item.getProduct().getId().equals(productId));
    }
}
