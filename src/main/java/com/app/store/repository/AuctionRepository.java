package com.app.store.repository;

import com.app.store.entity.Auction;
import com.app.store.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface AuctionRepository extends JpaRepository<Auction, Long> {

    
    List<Auction> findByActiveTrueOrderByCreatedAtDesc();

    
    List<Auction> findBySellerOrderByCreatedAtDesc(User seller);

    
    @Query("SELECT a FROM Auction a WHERE a.id = :id AND a.active = true")
    Auction findActiveById(@Param("id") Long id);
}
