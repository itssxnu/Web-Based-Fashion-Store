package com.app.store.repository;

import com.app.store.entity.BrowsingHistory;
import com.app.store.entity.User;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BrowsingHistoryRepository extends JpaRepository<BrowsingHistory, Long> {

    
    @Query("SELECT bh FROM BrowsingHistory bh WHERE bh.user = :user AND bh.viewedAt IN " +
            "(SELECT MAX(bh2.viewedAt) FROM BrowsingHistory bh2 WHERE bh2.user = :user GROUP BY bh2.product) " +
            "ORDER BY bh.viewedAt DESC")
    List<BrowsingHistory> findRecentUniqueProductViewsByUser(@Param("user") User user, Pageable pageable);

    
    @Query("SELECT p.category FROM BrowsingHistory bh JOIN bh.product p WHERE bh.user = :user " +
            "GROUP BY p.category ORDER BY COUNT(bh.id) DESC LIMIT 1")
    Optional<String> findMostFrequentCategoryByUser(@Param("user") User user);
}
