package com.app.store.repository;

import com.app.store.entity.Auction;
import com.app.store.entity.Bid;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface BidRepository extends JpaRepository<Bid, Long> {

    
    List<Bid> findByAuctionOrderByAmountDesc(Auction auction);

    
    List<Bid> findByBidderIdOrderByBidTimeDesc(Long bidderId);
}
