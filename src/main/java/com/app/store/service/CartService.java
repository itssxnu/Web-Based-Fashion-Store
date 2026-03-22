package com.app.store.service;

import com.app.store.entity.Cart;
import com.app.store.entity.User;

public interface CartService {
    Cart getCartForUser(User user);

    Cart addToCart(User user, Long variantId, Integer quantity);

    Cart updateQuantity(User user, Long cartItemId, Integer quantity);

    Cart removeFromCart(User user, Long cartItemId);

    void clearCart(User user);

    Double calculateCartTotal(Cart cart);

    Double calculateDeliveryCharge(Double subtotal);
}
