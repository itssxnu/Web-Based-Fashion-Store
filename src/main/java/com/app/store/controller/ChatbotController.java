package com.app.store.controller;

import com.app.store.service.OpenRouterChatService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/chat")
public class ChatbotController {

    private final OpenRouterChatService chatService;

    public ChatbotController(OpenRouterChatService chatService) {
        this.chatService = chatService;
    }

    @PostMapping
    public ResponseEntity<Map<String, String>> processChat(@RequestBody List<Map<String, String>> conversationHistory) {
        String reply = chatService.generateChatResponse(conversationHistory);
        return ResponseEntity.ok(Map.of("role", "assistant", "content", reply));
    }
}
