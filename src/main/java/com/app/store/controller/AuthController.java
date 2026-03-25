package com.app.store.controller;

import com.app.store.dto.OtpVerificationDto;
import com.app.store.dto.UserRegistrationDto;
import com.app.store.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;

    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("user", new UserRegistrationDto());
        return "register";
    }

    @PostMapping("/register")
    public String registerUserAccount(@Valid @ModelAttribute("user") UserRegistrationDto registrationDto,
            BindingResult result,
            Model model) {
        if (result.hasErrors()) {
            return "register";
        }

        try {
            userService.registerUser(registrationDto);
            return "redirect:/verify-otp?email=" + registrationDto.getEmail();
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "register";
        }
    }

    @GetMapping("/verify-otp")
    public String showOtpVerificationForm(@RequestParam(value = "email", required = false) String email, Model model) {
        if (email == null || email.trim().isEmpty()) {
            return "redirect:/register";
        }

        OtpVerificationDto dto = new OtpVerificationDto();
        dto.setEmail(email);
        model.addAttribute("otpDto", dto);
        return "verify-otp";
    }

    @PostMapping("/verify-otp")
    public String verifyOtp(@Valid @ModelAttribute("otpDto") OtpVerificationDto dto,
            BindingResult result,
            Model model) {
        if (result.hasErrors()) {
            return "verify-otp";
        }

        boolean verified = userService.verifyUserOtp(dto.getEmail(), dto.getCode());

        if (verified) {
            return "redirect:/login?verified=true";
        } else {
            model.addAttribute("error", "Invalid or expired OTP. Please try again.");
            return "verify-otp";
        }
    }
}
