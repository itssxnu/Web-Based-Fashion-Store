package com.app.store.service;

import com.app.store.entity.OrderItem;
import com.app.store.entity.OrderStatus;
import com.app.store.entity.User;

public interface OrderLifecycleService {

    
    OrderItem getOrderItemForUser(Long itemId, User user);

    
    
    OrderItem updateItemStatusBySeller(Long itemId, User seller, OrderStatus newStatus);

    
    OrderItem requestReturnByUser(Long itemId, User buyer);

    
    OrderItem processRefund(Long itemId, User seller);
}
