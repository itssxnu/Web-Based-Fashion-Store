package com.app.store.service.impl;

import com.app.store.entity.Product;
import com.app.store.entity.Review;
import com.app.store.entity.User;
import com.app.store.repository.ProductRepository;
import com.app.store.repository.ReviewRepository;
import com.app.store.service.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ReviewServiceImpl implements ReviewService {

    private final ReviewRepository reviewRepository;
    private final ProductRepository productRepository;

    @Override
    public Review addReview(User user, Long productId, int rating, String comment) {
        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
        
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Product not found"));

        Review review = Review.builder()
                .user(user)
                .product(product)
                .rating(rating)
                .comment(comment)
                .build();

        return reviewRepository.save(review);
    }

    @Override
    public List<Review> getReviewsForProduct(Long productId) {
        return reviewRepository.findByProductIdOrderByCreatedAtDesc(productId);
    }

    @Override
    public List<Review> getReviewsForSeller(Long sellerId) {
        return reviewRepository.findByProductSellerIdOrderByCreatedAtDesc(sellerId);
    }

    @Override
    public Review addSellerReply(User seller, Long reviewId, String reply) {
        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new IllegalArgumentException("Review not found"));

        if (!review.getProduct().getSeller().getId().equals(seller.getId())) {
            throw new IllegalArgumentException("You are not the seller of this product");
        }

        review.setSellerReply(reply);
        review.setSellerRepliedAt(LocalDateTime.now());

        return reviewRepository.save(review);
    }
}
