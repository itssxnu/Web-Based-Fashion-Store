package com.app.store.service.impl;

import com.app.store.entity.OrderItem;
import com.app.store.entity.OrderStatus;
import com.app.store.entity.ProductVariant;
import com.app.store.entity.User;
import com.app.store.repository.OrderItemRepository;
import com.app.store.repository.ProductVariantRepository;
import com.app.store.service.SellerDashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SellerDashboardServiceImpl implements SellerDashboardService {

    private final OrderItemRepository orderItemRepository;
    private final ProductVariantRepository productVariantRepository;

    @Override
    public Double calculateTotalRevenue(User seller) {
        List<OrderItem> items = orderItemRepository.findByProductVariantProductSellerOrderByOrderCreatedAtDesc(seller);
        return items.stream()
                .filter(item -> item.getStatus() != OrderStatus.REFUNDED)
                .mapToDouble(item -> item.getPriceAtTimeOfPurchase() * item.getQuantity())
                .sum();
    }

    @Override
    public Integer calculateTotalUnitsSold(User seller) {
        List<OrderItem> items = orderItemRepository.findByProductVariantProductSellerOrderByOrderCreatedAtDesc(seller);
        return items.stream()
                .filter(item -> item.getStatus() != OrderStatus.REFUNDED)
                .mapToInt(OrderItem::getQuantity)
                .sum();
    }

    @Override
    public List<ProductVariant> getLowStockAlerts(User seller, int threshold) {

        return productVariantRepository.findAll().stream()
                .filter(variant -> variant.getProduct().getSeller() != null &&
                        variant.getProduct().getSeller().getId().equals(seller.getId()))
                .filter(variant -> variant.getStockQuantity() <= threshold)
                .collect(Collectors.toList());
    }

    @Override
    public List<OrderItem> getRecentPurchaseAlerts(User seller, int limit) {
        List<OrderItem> allItems = orderItemRepository
                .findByProductVariantProductSellerOrderByOrderCreatedAtDesc(seller);
        return allItems.stream().limit(limit).collect(Collectors.toList());
    }
}
