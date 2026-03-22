package com.app.store.service.impl;

import com.app.store.entity.*;
import com.app.store.repository.OrderRepository;
import com.app.store.repository.ProductVariantRepository;
import com.app.store.service.CartService;
import com.app.store.service.EmailService;
import com.app.store.service.OrderService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {

    private final OrderRepository orderRepository;
    private final CartService cartService;
    private final ProductVariantRepository variantRepository;
    private final EmailService emailService;

    @Override
    @Transactional
    public Order placeOrder(User user, String shippingAddress, String cardNumber, String expiry, String cvv) {
        Cart cart = cartService.getCartForUser(user);

        if (cart.getItems() == null || cart.getItems().isEmpty()) {
            throw new RuntimeException("Cannot place order with an empty cart");
        }

        
        log.info("Simulating payment processing for card ending in {}",
                cardNumber.substring(Math.max(0, cardNumber.length() - 4)));
        if (cardNumber.length() < 12) {
            throw new IllegalArgumentException("Invalid card number format");
        }

        Double subtotal = cartService.calculateCartTotal(cart);
        Double deliveryCharge = cartService.calculateDeliveryCharge(subtotal);
        Double totalAmount = subtotal + deliveryCharge;

        Order order = Order.builder()
                .user(user)
                .subtotal(subtotal)
                .deliveryCharge(deliveryCharge)
                .totalAmount(totalAmount)
                .shippingAddress(shippingAddress)
                .orderStatus("PROCESSING")
                .build();

        for (CartItem cartItem : cart.getItems()) {
            ProductVariant variant = cartItem.getProductVariant();

            if (variant.getStockQuantity() < cartItem.getQuantity()) {
                throw new RuntimeException("Insufficient stock for " + variant.getProduct().getTitle());
            }

            
            variant.setStockQuantity(variant.getStockQuantity() - cartItem.getQuantity());
            variantRepository.save(variant);

            Double price = variant.getProduct().getBasePrice()
                    + (variant.getPriceModifier() != null ? variant.getPriceModifier() : 0.0);

            OrderItem orderItem = OrderItem.builder()
                    .order(order)
                    .productVariant(variant)
                    .quantity(cartItem.getQuantity())
                    .priceAtTimeOfPurchase(price)
                    .status(OrderStatus.PENDING)
                    .build();

            order.getItems().add(orderItem);
        }

        Order savedOrder = orderRepository.save(order);
        cartService.clearCart(user);

        log.info("Order {} placed successfully for user {}", savedOrder.getId(), user.getEmail());

        
        emailService.sendOrderConfirmation(user, savedOrder);

        return savedOrder;
    }

    @Override
    public List<Order> getUserOrders(User user) {
        return orderRepository.findByUserOrderByCreatedAtDesc(user);
    }

    @Override
    public Order getOrderById(Long orderId, User user) {
        return orderRepository.findById(orderId)
                .filter(order -> order.getUser().getId().equals(user.getId()))
                .orElseThrow(() -> new RuntimeException("Order not found or unauthorized"));
    }
}
