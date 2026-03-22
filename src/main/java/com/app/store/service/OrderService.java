package com.app.store.service;

import com.app.store.entity.Order;
import com.app.store.entity.User;

import java.util.List;

public interface OrderService {
    Order placeOrder(User user, String shippingAddress, String cardNumber, String expiry, String cvv);

    List<Order> getUserOrders(User user);

    Order getOrderById(Long orderId, User user);
}
