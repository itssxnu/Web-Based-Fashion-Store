package com.app.store.service.impl;

import com.app.store.entity.Message;
import com.app.store.entity.User;
import com.app.store.repository.MessageRepository;
import com.app.store.service.MessagingService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MessagingServiceImpl implements MessagingService {

    private final MessageRepository messageRepository;

    @Override
    public Message sendMessage(User sender, User receiver, String content) {
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("Message content cannot be empty.");
        }

        Message message = Message.builder()
                .sender(sender)
                .receiver(receiver)
                .content(content.trim())
                .build();

        return messageRepository.save(message);
    }

    @Override
    public List<Message> getConversationHistory(User user1, User user2) {
        return messageRepository.findConversationHistory(user1, user2);
    }

    @Override
    public List<User> getConversingUsers(User user) {
        return messageRepository.findConversingUsers(user);
    }
}
