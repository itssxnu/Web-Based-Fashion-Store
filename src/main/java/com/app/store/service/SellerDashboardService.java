package com.app.store.service;

import com.app.store.entity.OrderItem;
import com.app.store.entity.ProductVariant;
import com.app.store.entity.User;

import java.util.List;

public interface SellerDashboardService {

    
    Double calculateTotalRevenue(User seller);

    
    Integer calculateTotalUnitsSold(User seller);

    
    List<ProductVariant> getLowStockAlerts(User seller, int threshold);

    
    List<OrderItem> getRecentPurchaseAlerts(User seller, int limit);
}
