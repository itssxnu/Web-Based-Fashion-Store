package com.app.store.repository;

import com.app.store.entity.OrderItem;
import com.app.store.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface OrderItemRepository extends JpaRepository<OrderItem, Long> {

        
        @Query("SELECT oi FROM OrderItem oi WHERE oi.productVariant.product.seller = :seller ORDER BY oi.order.createdAt DESC")
        List<OrderItem> findByProductVariantProductSellerOrderByOrderCreatedAtDesc(@Param("seller") User seller);

        
        @Query(value = "SELECT p.title, SUM(oi.quantity) as total_sold " +
                        "FROM order_items oi " +
                        "JOIN product_variants pv ON oi.product_variant_id = pv.id " +
                        "JOIN products p ON pv.product_id = p.id " +
                        "JOIN orders o ON oi.order_id = o.id " +
                        "GROUP BY p.id, p.title " +
                        "ORDER BY total_sold DESC LIMIT 5", nativeQuery = true)
        List<Object[]> findBestSellingProducts();

        
        @Query(value = "SELECT DATE_FORMAT(o.created_at, '%Y-%m') as month, SUM(o.total_amount) as profit " +
                        "FROM orders o " +
                        "GROUP BY month " +
                        "ORDER BY month ASC LIMIT 12", nativeQuery = true)
        List<Object[]> findMonthlyProfitReporting();

        
        @Query(value = "SELECT DATE_FORMAT(o.created_at, '%M') as month, p.category, SUM(oi.quantity) as demand " +
                        "FROM order_items oi " +
                        "JOIN product_variants pv ON oi.product_variant_id = pv.id " +
                        "JOIN products p ON pv.product_id = p.id " +
                        "JOIN orders o ON oi.order_id = o.id " +
                        "GROUP BY month, p.category " +
                        "ORDER BY FIELD(month, 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'), demand DESC", nativeQuery = true)
        List<Object[]> findSeasonalDemand();

        
        @Query(value = "SELECT pv2.product_id " +
                        "FROM order_items o1 " +
                        "JOIN order_items o2 ON o1.order_id = o2.order_id " +
                        "JOIN product_variants pv1 ON o1.product_variant_id = pv1.id " +
                        "JOIN product_variants pv2 ON o2.product_variant_id = pv2.id " +
                        "WHERE pv1.product_id = :productId " +
                        "AND pv2.product_id != :productId " +
                        "GROUP BY pv2.product_id " +
                        "ORDER BY COUNT(o2.id) DESC LIMIT 4", nativeQuery = true)
        List<Long> findFrequentlyBoughtTogetherProductIds(@Param("productId") Long productId);
}
