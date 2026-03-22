package com.app.store.controller;

import com.app.store.entity.Auction;
import com.app.store.entity.Bid;
import com.app.store.entity.Product;
import com.app.store.entity.User;
import com.app.store.repository.ProductRepository;
import com.app.store.service.AuctionService;
import com.app.store.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.List;

@Controller
@RequestMapping("/seller/auctions")
@RequiredArgsConstructor
public class SellerAuctionController {

    private final AuctionService auctionService;
    private final UserService userService;
    private final ProductRepository productRepository;

    @GetMapping
    public String viewAuctions(@AuthenticationPrincipal UserDetails userDetails, Model model) {
        if (userDetails == null) {
            return "redirect:/login";
        }
        User seller = userService.findByEmail(userDetails.getUsername());
        if (seller == null) {
            return "redirect:/login";
        }

        List<Product> products = productRepository.findBySellerIdOrderByCreatedAtDesc(seller.getId());

        model.addAttribute("auctions", auctionService.getAuctionsBySeller(seller));
        model.addAttribute("products", products);

        return "seller/auctions";
    }

    @PostMapping("/create")
    public String createAuction(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam("productId") Long productId,
            @RequestParam("startingPrice") BigDecimal startingPrice,
            @RequestParam("expectedPrice") BigDecimal expectedPrice,
            @RequestParam("clothingPieces") Integer clothingPieces,
            RedirectAttributes redirectAttributes) {

        try {
            User seller = userService.findByEmail(userDetails.getUsername());
            if (seller == null)
                throw new RuntimeException("Seller not found");

            auctionService.createAuction(seller, productId, startingPrice, expectedPrice, clothingPieces);
            redirectAttributes.addFlashAttribute("successMessage", "Auction started successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/seller/auctions";
    }

    @PostMapping("/{auctionId}/edit")
    public String editAuction(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable("auctionId") Long auctionId,
            @RequestParam("startingPrice") BigDecimal startingPrice,
            @RequestParam("expectedPrice") BigDecimal expectedPrice,
            @RequestParam("clothingPieces") Integer clothingPieces,
            RedirectAttributes redirectAttributes) {

        try {
            User seller = userService.findByEmail(userDetails.getUsername());
            if (seller == null)
                throw new RuntimeException("Seller not found");
            auctionService.editAuction(seller, auctionId, startingPrice, expectedPrice, clothingPieces);
            redirectAttributes.addFlashAttribute("successMessage", "Auction updated successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/seller/auctions";
    }

    @PostMapping("/{auctionId}/delete")
    public String deleteAuction(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable("auctionId") Long auctionId,
            RedirectAttributes redirectAttributes) {

        try {
            User seller = userService.findByEmail(userDetails.getUsername());
            if (seller == null)
                throw new RuntimeException("Seller not found");
            auctionService.deleteAuction(seller, auctionId);
            redirectAttributes.addFlashAttribute("successMessage", "Auction deleted.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/seller/auctions";
    }

    @PostMapping("/{auctionId}/stop")
    public String stopAuction(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable("auctionId") Long auctionId,
            RedirectAttributes redirectAttributes) {

        try {
            User seller = userService.findByEmail(userDetails.getUsername());
            if (seller == null)
                throw new RuntimeException("Seller not found");
            auctionService.stopAuction(seller, auctionId);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Auction stopped manually. Winner has been notified.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/seller/auctions";
    }

    

    @GetMapping("/active")
    public String viewActiveAuctions(Model model) {
        List<Auction> activeAuctions = auctionService.getActivePublicAuctions();
        model.addAttribute("auctions", activeAuctions);
        return "seller/active-auctions";
    }

    @GetMapping("/active/{auctionId}")
    public String viewAuctionDetails(
            @PathVariable("auctionId") Long auctionId,
            @AuthenticationPrincipal UserDetails userDetails,
            Model model) {

        Auction auction = auctionService.getAuctionById(auctionId);
        List<Bid> bids = auctionService.getBidsForAuction(auctionId);

        model.addAttribute("auction", auction);
        model.addAttribute("bids", bids);

        if (userDetails != null) {
            User currentUser = userService.findByEmail(userDetails.getUsername());
            model.addAttribute("currentUser", currentUser);
        }

        return "seller/active-auction-detail";
    }

    @PostMapping("/active/{auctionId}/bid")
    public String placeBid(
            @PathVariable("auctionId") Long auctionId,
            @RequestParam("amount") BigDecimal amount,
            @AuthenticationPrincipal UserDetails userDetails,
            RedirectAttributes redirectAttributes) {

        if (userDetails == null) {
            return "redirect:/login";
        }

        try {
            User buyer = userService.findByEmail(userDetails.getUsername());
            if (buyer == null)
                throw new RuntimeException("User not authenticated.");

            auctionService.placeBid(buyer, auctionId, amount);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Bid placed successfully! You are currently the highest bidder.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/seller/auctions/active/" + auctionId;
    }
}
