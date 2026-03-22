package com.app.store.service;

import com.app.store.entity.Auction;
import com.app.store.entity.Bid;
import com.app.store.entity.User;

import java.math.BigDecimal;
import java.util.List;

public interface AuctionService {

    
    Auction createAuction(User seller, Long productId, BigDecimal startingPrice, BigDecimal expectedPrice,
            Integer clothingPieces);

    
    Auction editAuction(User seller, Long auctionId, BigDecimal startingPrice, BigDecimal expectedPrice,
            Integer clothingPieces);

    
    void deleteAuction(User seller, Long auctionId);

    
    Auction stopAuction(User seller, Long auctionId);

    
    Bid placeBid(User buyer, Long auctionId, BigDecimal amount);

    
    List<Auction> getActivePublicAuctions();

    List<Auction> getAuctionsBySeller(User seller);

    Auction getAuctionById(Long auctionId);

    List<Bid> getBidsForAuction(Long auctionId);
}
