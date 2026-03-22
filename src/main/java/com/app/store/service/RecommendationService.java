package com.app.store.service;

import com.app.store.entity.BrowsingHistory;
import com.app.store.entity.Product;
import com.app.store.entity.User;
import com.app.store.repository.BrowsingHistoryRepository;
import com.app.store.repository.OrderItemRepository;
import com.app.store.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RecommendationService {

    private final BrowsingHistoryRepository browsingHistoryRepository;
    private final OrderItemRepository orderItemRepository;
    private final ProductRepository productRepository;

    public void trackProductView(User user, Product product) {
        if (user == null || product == null)
            return;
        BrowsingHistory history = BrowsingHistory.builder()
                .user(user)
                .product(product)
                .build();
        browsingHistoryRepository.save(history);
    }

    public List<Product> getRecentlyExploredProducts(User user, int limit) {
        if (user == null)
            return List.of();
        return browsingHistoryRepository.findRecentUniqueProductViewsByUser(user, PageRequest.of(0, limit))
                .stream()
                .map(BrowsingHistory::getProduct)
                .collect(Collectors.toList());
    }

    public Optional<String> getUserFavoriteCategory(User user) {
        if (user == null)
            return Optional.empty();
        return browsingHistoryRepository.findMostFrequentCategoryByUser(user);
    }

    public List<Product> getFrequentlyBoughtTogether(Long productId) {
        List<Long> relatedIds = orderItemRepository.findFrequentlyBoughtTogetherProductIds(productId);
        if (relatedIds.isEmpty())
            return List.of();
        return productRepository.findAllById(relatedIds);
    }
}
