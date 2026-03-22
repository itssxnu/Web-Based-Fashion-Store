package com.app.store.service.impl;

import com.app.store.entity.Cart;
import com.app.store.entity.CartItem;
import com.app.store.entity.ProductVariant;
import com.app.store.entity.User;
import com.app.store.repository.CartRepository;
import com.app.store.repository.ProductVariantRepository;
import com.app.store.service.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CartServiceImpl implements CartService {

    private final CartRepository cartRepository;
    private final ProductVariantRepository productVariantRepository;

    @Override
    public Cart getCartForUser(User user) {
        return cartRepository.findByUser(user).orElseGet(() -> {
            Cart newCart = Cart.builder().user(user).build();
            return cartRepository.save(newCart);
        });
    }

    @Override
    @Transactional
    public Cart addToCart(User user, Long variantId, Integer quantity) {
        Cart cart = getCartForUser(user);
        ProductVariant variant = productVariantRepository.findById(variantId)
                .orElseThrow(() -> new RuntimeException("Variant not found"));

        if (variant.getStockQuantity() < quantity) {
            throw new RuntimeException("Not enough stock available");
        }

        
        Optional<CartItem> existingItem = cart.getItems().stream()
                .filter(item -> item.getProductVariant().getId().equals(variantId))
                .findFirst();

        if (existingItem.isPresent()) {
            CartItem item = existingItem.get();
            if (variant.getStockQuantity() < (item.getQuantity() + quantity)) {
                throw new RuntimeException("Cannot add more, exceeds available stock");
            }
            item.setQuantity(item.getQuantity() + quantity);
        } else {
            CartItem newItem = CartItem.builder()
                    .cart(cart)
                    .productVariant(variant)
                    .quantity(quantity)
                    .build();
            cart.getItems().add(newItem);
        }

        return cartRepository.save(cart);
    }

    @Override
    @Transactional
    public Cart updateQuantity(User user, Long cartItemId, Integer quantity) {
        Cart cart = getCartForUser(user);
        CartItem itemToUpdate = cart.getItems().stream()
                .filter(item -> item.getId().equals(cartItemId))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Cart item not found"));

        if (itemToUpdate.getProductVariant().getStockQuantity() < quantity) {
            throw new RuntimeException("Not enough stock available");
        }

        if (quantity <= 0) {
            cart.getItems().remove(itemToUpdate);
        } else {
            itemToUpdate.setQuantity(quantity);
        }

        return cartRepository.save(cart);
    }

    @Override
    @Transactional
    public Cart removeFromCart(User user, Long cartItemId) {
        Cart cart = getCartForUser(user);
        cart.getItems().removeIf(item -> item.getId().equals(cartItemId));
        return cartRepository.save(cart);
    }

    @Override
    @Transactional
    public void clearCart(User user) {
        Cart cart = getCartForUser(user);
        cart.getItems().clear();
        cartRepository.save(cart);
    }

    @Override
    public Double calculateCartTotal(Cart cart) {
        return cart.getItems().stream()
                .mapToDouble(item -> {
                    Double basePrice = item.getProductVariant().getProduct().getBasePrice();
                    Double modifier = item.getProductVariant().getPriceModifier();
                    return (basePrice + (modifier != null ? modifier : 0.0)) * item.getQuantity();
                })
                .sum();
    }

    @Override
    public Double calculateDeliveryCharge(Double subtotal) {
        if (subtotal >= 12000.0) {
            return 0.0;
        }
        return 350.0;
    }
}
