package com.app.store.service.impl;

import com.app.store.entity.Auction;
import com.app.store.entity.Bid;
import com.app.store.entity.Product;
import com.app.store.entity.User;
import com.app.store.repository.AuctionRepository;
import com.app.store.repository.BidRepository;
import com.app.store.repository.ProductRepository;
import com.app.store.service.AuctionService;
import com.app.store.service.MessagingService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AuctionServiceImpl implements AuctionService {

    private final AuctionRepository auctionRepository;
    private final BidRepository bidRepository;
    private final ProductRepository productRepository;
    private final MessagingService messagingService;

    @Override
    @Transactional
    public Auction createAuction(User seller, Long productId, BigDecimal startingPrice, BigDecimal expectedPrice,
            Integer clothingPieces) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Product not found"));

        if (!product.getSeller().getId().equals(seller.getId())) {
            throw new IllegalArgumentException("You can only auction your own products.");
        }

        if (startingPrice.compareTo(expectedPrice) >= 0) {
            throw new IllegalArgumentException("Starting price must be strictly less than the expected price.");
        }

        Auction auction = Auction.builder()
                .product(product)
                .seller(seller)
                .startingPrice(startingPrice)
                .expectedPrice(expectedPrice)
                .clothingPieces(clothingPieces)
                .currentHighestBid(startingPrice) 
                .active(true)
                .build();

        return auctionRepository.save(auction);
    }

    @Override
    @Transactional
    public Auction editAuction(User seller, Long auctionId, BigDecimal startingPrice, BigDecimal expectedPrice,
            Integer clothingPieces) {
        Auction auction = auctionRepository.findById(auctionId)
                .orElseThrow(() -> new IllegalArgumentException("Auction not found"));

        if (!auction.getSeller().getId().equals(seller.getId())) {
            throw new IllegalArgumentException("Unauthorized");
        }

        if (auction.getCurrentHighestBidder() != null) {
            throw new IllegalStateException("Cannot edit an auction after bids have been placed.");
        }

        if (startingPrice.compareTo(expectedPrice) >= 0) {
            throw new IllegalArgumentException("Starting price must be less than expected.");
        }

        auction.setStartingPrice(startingPrice);
        auction.setExpectedPrice(expectedPrice);
        auction.setClothingPieces(clothingPieces);
        auction.setCurrentHighestBid(startingPrice);

        return auctionRepository.save(auction);
    }

    @Override
    @Transactional
    public void deleteAuction(User seller, Long auctionId) {
        Auction auction = auctionRepository.findById(auctionId)
                .orElseThrow(() -> new IllegalArgumentException("Auction not found"));

        if (!auction.getSeller().getId().equals(seller.getId())) {
            throw new IllegalArgumentException("Unauthorized");
        }

        
        
        auctionRepository.delete(auction);
    }

    @Override
    @Transactional
    public Auction stopAuction(User seller, Long auctionId) {
        Auction auction = auctionRepository.findById(auctionId)
                .orElseThrow(() -> new IllegalArgumentException("Auction not found"));

        if (!auction.getSeller().getId().equals(seller.getId())) {
            throw new IllegalArgumentException("Unauthorized");
        }

        if (!auction.isActive()) {
            throw new IllegalStateException("Auction is already closed.");
        }

        return closeAuction(auction);
    }

    @Override
    @Transactional
    public Bid placeBid(User buyer, Long auctionId, BigDecimal amount) {
        Auction auction = auctionRepository.findById(auctionId)
                .orElseThrow(() -> new IllegalArgumentException("Auction not found"));

        if (!auction.isActive()) {
            throw new IllegalStateException("This auction is closed.");
        }

        if (auction.getSeller().getId().equals(buyer.getId())) {
            throw new IllegalArgumentException("Sellers cannot bid on their own auctions.");
        }

        if (amount.compareTo(auction.getCurrentHighestBid()) <= 0) {
            throw new IllegalArgumentException("Your bid must be strictly higher than the current top bid of LKR "
                    + auction.getCurrentHighestBid());
        }

        
        Bid bid = Bid.builder()
                .auction(auction)
                .bidder(buyer)
                .amount(amount)
                .build();
        bid = bidRepository.save(bid);

        
        auction.setCurrentHighestBid(amount);
        auction.setCurrentHighestBidder(buyer);

        
        if (amount.compareTo(auction.getExpectedPrice()) >= 0) {
            closeAuction(auction);
        } else {
            auctionRepository.save(auction);
        }

        return bid;
    }

    
    private Auction closeAuction(Auction auction) {
        auction.setActive(false);

        if (auction.getCurrentHighestBidder() != null) {
            auction.setWinner(auction.getCurrentHighestBidder());

            
            String victoryMessage = "Congratulations! You have won the auction for '" +
                    auction.getProduct().getTitle() + "' with a final bid of LKR " +
                    auction.getCurrentHighestBid() + ". Please arrange payment and delivery with me here.";

            messagingService.sendMessage(auction.getSeller(), auction.getWinner(), victoryMessage);
        }

        return auctionRepository.save(auction);
    }

    @Override
    public List<Auction> getActivePublicAuctions() {
        return auctionRepository.findByActiveTrueOrderByCreatedAtDesc();
    }

    @Override
    public List<Auction> getAuctionsBySeller(User seller) {
        return auctionRepository.findBySellerOrderByCreatedAtDesc(seller);
    }

    @Override
    public Auction getAuctionById(Long auctionId) {
        return auctionRepository.findById(auctionId)
                .orElseThrow(() -> new IllegalArgumentException("Auction not found"));
    }

    @Override
    public List<Bid> getBidsForAuction(Long auctionId) {
        
        
        
        Auction auction = getAuctionById(auctionId);
        return bidRepository.findByAuctionOrderByAmountDesc(auction);
    }
}
