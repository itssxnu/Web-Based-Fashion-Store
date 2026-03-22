package com.app.store.controller;

import com.app.store.entity.Role;
import com.app.store.entity.User;
import com.app.store.repository.UserRepository;
import com.app.store.security.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/user/profile")
@RequiredArgsConstructor
public class UserProfileController {

    private final UserRepository userRepository;

    @GetMapping
    public String showProfile(Authentication authentication, Model model) {
        String email = authentication.getName();
        if (authentication.getPrincipal() instanceof CustomUserDetails) {
            email = ((CustomUserDetails) authentication.getPrincipal()).getUsername();
        }

        User user = userRepository.findByEmail(email).orElseThrow(() -> new RuntimeException("User not found"));
        model.addAttribute("user", user);
        return "user/profile";
    }

    @PostMapping("/upgrade")
    public String upgradeToSeller(Authentication authentication, RedirectAttributes redirectAttributes) {
        String email = authentication.getName();
        if (authentication.getPrincipal() instanceof CustomUserDetails) {
            email = ((CustomUserDetails) authentication.getPrincipal()).getUsername();
        }

        User user = userRepository.findByEmail(email).orElseThrow(() -> new RuntimeException("User not found"));

        if (user.getRole() == Role.SELLER) {
            redirectAttributes.addFlashAttribute("error", "You are already a Seller.");
            return "redirect:/user/profile";
        }

        user.setRole(Role.SELLER);
        userRepository.save(user);

        
        
        List<GrantedAuthority> updatedAuthorities = new ArrayList<>(authentication.getAuthorities());
        updatedAuthorities.removeIf(a -> a.getAuthority().equals("ROLE_USER"));
        updatedAuthorities.add(new SimpleGrantedAuthority("ROLE_SELLER"));

        Authentication newAuth;
        if (authentication instanceof OAuth2AuthenticationToken oauth2Auth) {
            newAuth = new OAuth2AuthenticationToken(
                    (CustomUserDetails) authentication.getPrincipal(),
                    updatedAuthorities,
                    oauth2Auth.getAuthorizedClientRegistrationId());
        } else {
            newAuth = new UsernamePasswordAuthenticationToken(
                    authentication.getPrincipal(),
                    authentication.getCredentials(),
                    updatedAuthorities);
        }

        SecurityContextHolder.getContext().setAuthentication(newAuth);

        redirectAttributes.addFlashAttribute("success",
                "Successfully upgraded to Seller Account! Welcome to your dashboard.");
        return "redirect:/seller/dashboard";
    }
}
