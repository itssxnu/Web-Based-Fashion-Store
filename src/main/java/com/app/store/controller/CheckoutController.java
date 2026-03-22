package com.app.store.controller;

import com.app.store.entity.Cart;
import com.app.store.entity.User;
import com.app.store.repository.UserRepository;
import com.app.store.service.CartService;
import com.app.store.service.OrderService;
import com.app.store.service.OtpService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;

@Controller
@RequestMapping("/checkout")
@RequiredArgsConstructor
public class CheckoutController {

    private final CartService cartService;
    private final OrderService orderService;
    private final UserRepository userRepository;
    private final OtpService otpService;

    private User getAuthenticatedUser(Principal principal) {
        if (principal == null)
            return null;
        return userRepository.findByEmail(principal.getName()).orElse(null);
    }

    @GetMapping
    public String checkoutPage(Model model, Principal principal, HttpSession session) {
        User user = getAuthenticatedUser(principal);
        if (user == null)
            return "redirect:/login";

        Boolean isVerified = (Boolean) session.getAttribute("checkout_verified");
        if (isVerified == null || !isVerified) {
            otpService.generateAndSendCheckoutOtp(user.getPhone());
            return "redirect:/checkout/verify-otp";
        }

        Cart cart = cartService.getCartForUser(user);
        if (cart.getItems().isEmpty()) {
            return "redirect:/cart?error=Your cart is empty";
        }

        Double subtotal = cartService.calculateCartTotal(cart);
        Double deliveryCharge = cartService.calculateDeliveryCharge(subtotal);
        Double totalAmount = subtotal + deliveryCharge;

        model.addAttribute("cart", cart);
        model.addAttribute("subtotal", subtotal);
        model.addAttribute("deliveryCharge", deliveryCharge);
        model.addAttribute("totalAmount", totalAmount);

        return "checkout";
    }

    @GetMapping("/verify-otp")
    public String showCheckoutOtpVerification(Principal principal) {
        User user = getAuthenticatedUser(principal);
        if (user == null) return "redirect:/login";

        return "checkout-verify-otp";
    }

    @PostMapping("/verify-otp")
    public String verifyCheckoutOtp(@RequestParam("code") String code, Principal principal, HttpSession session, RedirectAttributes redirectAttributes) {
        User user = getAuthenticatedUser(principal);
        if (user == null) return "redirect:/login";

        boolean verified = otpService.verifyOtp(user.getPhone(), code);
        if (verified) {
            session.setAttribute("checkout_verified", true);
            return "redirect:/checkout";
        } else {
            redirectAttributes.addFlashAttribute("error", "Invalid or expired OTP. Please try again.");
            return "redirect:/checkout/verify-otp";
        }
    }

    @PostMapping("/process")
    public String processCheckout(
            @RequestParam("shippingAddress") String shippingAddress,
            @RequestParam("cardNumber") String cardNumber,
            @RequestParam("expiry") String expiry,
            @RequestParam("cvv") String cvv,
            Principal principal,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User user = getAuthenticatedUser(principal);
        if (user == null)
            return "redirect:/login";

        Boolean isVerified = (Boolean) session.getAttribute("checkout_verified");
        if (isVerified == null || !isVerified) {
            return "redirect:/checkout";
        }

        try {
            orderService.placeOrder(user, shippingAddress, cardNumber, expiry, cvv);
            session.removeAttribute("checkout_verified");
            redirectAttributes.addFlashAttribute("successMessage", "Order Placed Successfully!");
            return "redirect:/shop";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Checkout Failed: " + e.getMessage());
            return "redirect:/checkout";
        }
    }
}
