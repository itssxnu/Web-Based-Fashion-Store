package com.app.store.service;

import com.app.store.entity.Review;
import com.app.store.entity.User;

import java.util.List;

public interface ReviewService {
    Review addReview(User user, Long productId, int rating, String comment);
    List<Review> getReviewsForProduct(Long productId);
    List<Review> getReviewsForSeller(Long sellerId);
    Review addSellerReply(User seller, Long reviewId, String reply);
}
