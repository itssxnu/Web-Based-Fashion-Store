package com.app.store.service;

import com.app.store.entity.User;
import com.app.store.entity.Wishlist;

public interface WishlistService {
    Wishlist getWishlistForUser(User user);

    Wishlist addToWishlist(User user, Long productId);

    Wishlist removeFromWishlist(User user, Long wishlistItemId);

    boolean isProductInWishlist(User user, Long productId);
}
