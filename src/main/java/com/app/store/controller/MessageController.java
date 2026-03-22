package com.app.store.controller;

import com.app.store.entity.Message;
import com.app.store.entity.User;
import com.app.store.repository.UserRepository;
import com.app.store.service.MessagingService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/messages")
@RequiredArgsConstructor
public class MessageController {

    private final MessagingService messagingService;
    private final UserRepository userRepository;

    private User getAuthenticatedUser(Principal principal) {
        if (principal == null)
            return null;
        return userRepository.findByEmail(principal.getName()).orElse(null);
    }

    @GetMapping
    public String viewInbox(Principal principal, Model model) {
        User currentUser = getAuthenticatedUser(principal);
        if (currentUser == null)
            return "redirect:/login";

        List<User> conversingUsers = messagingService.getConversingUsers(currentUser);
        model.addAttribute("conversations", conversingUsers);
        model.addAttribute("currentUser", currentUser);

        return "messages/inbox";
    }

    @GetMapping("/{userId}")
    public String viewChat(@PathVariable("userId") Long userId, Principal principal, Model model) {
        User currentUser = getAuthenticatedUser(principal);
        if (currentUser == null)
            return "redirect:/login";

        User otherUser = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        List<Message> chatHistory = messagingService.getConversationHistory(currentUser, otherUser);

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("otherUser", otherUser);
        model.addAttribute("chatHistory", chatHistory);

        model.addAttribute("conversations", messagingService.getConversingUsers(currentUser));

        return "messages/chat";
    }

    @PostMapping("/{userId}/send")
    public String sendMessage(@PathVariable("userId") Long userId,
            @RequestParam("content") String content,
            Principal principal) {
        User sender = getAuthenticatedUser(principal);
        if (sender == null)
            return "redirect:/login";

        User receiver = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Receiver not found"));

        messagingService.sendMessage(sender, receiver, content);

        return "redirect:/messages/" + userId;
    }
}
