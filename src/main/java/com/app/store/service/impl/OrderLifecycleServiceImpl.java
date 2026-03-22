package com.app.store.service.impl;

import com.app.store.entity.OrderItem;
import com.app.store.entity.OrderStatus;
import com.app.store.entity.User;
import com.app.store.repository.OrderItemRepository;
import com.app.store.service.OrderLifecycleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OrderLifecycleServiceImpl implements OrderLifecycleService {

    private final OrderItemRepository orderItemRepository;

    @Override
    public OrderItem getOrderItemForUser(Long itemId, User user) {
        return orderItemRepository.findById(itemId)
                .filter(item -> {
                    boolean isBuyer = item.getOrder().getUser().getId().equals(user.getId());
                    boolean isSeller = item.getProductVariant().getProduct().getSeller() != null &&
                            item.getProductVariant().getProduct().getSeller().getId().equals(user.getId());
                    return isBuyer || isSeller;
                })
                .orElseThrow(() -> new IllegalArgumentException("Order Item not found or access denied"));
    }

    @Override
    public OrderItem updateItemStatusBySeller(Long itemId, User seller, OrderStatus newStatus) {
        OrderItem item = orderItemRepository.findById(itemId)
                .filter(i -> i.getProductVariant().getProduct().getSeller() != null &&
                        i.getProductVariant().getProduct().getSeller().getId().equals(seller.getId()))
                .orElseThrow(() -> new IllegalArgumentException("Unauthorized modification attempt"));

        
        
        item.setStatus(newStatus);
        return orderItemRepository.save(item);
    }

    @Override
    public OrderItem requestReturnByUser(Long itemId, User buyer) {
        OrderItem item = orderItemRepository.findById(itemId)
                .filter(i -> i.getOrder().getUser().getId().equals(buyer.getId()))
                .orElseThrow(() -> new IllegalArgumentException("Unauthorized return attempt"));

        if (item.getStatus() != OrderStatus.DELIVERED) {
            throw new IllegalStateException("Can only request returns on DELIVERED items.");
        }

        item.setStatus(OrderStatus.RETURN_REQUESTED);
        return orderItemRepository.save(item);
    }

    @Override
    public OrderItem processRefund(Long itemId, User seller) {
        OrderItem item = orderItemRepository.findById(itemId)
                .filter(i -> i.getProductVariant().getProduct().getSeller() != null &&
                        i.getProductVariant().getProduct().getSeller().getId().equals(seller.getId()))
                .orElseThrow(() -> new IllegalArgumentException("Unauthorized refund attempt"));

        if (item.getStatus() != OrderStatus.RETURN_REQUESTED) {
            throw new IllegalStateException("Can only refund after a return is requested.");
        }

        item.setStatus(OrderStatus.REFUNDED);
        return orderItemRepository.save(item);
    }
}
