package com.app.store.service;

import com.app.store.entity.Message;
import com.app.store.entity.User;

import java.util.List;

public interface MessagingService {

    
    Message sendMessage(User sender, User receiver, String content);

    
    List<Message> getConversationHistory(User user1, User user2);

    
    List<User> getConversingUsers(User user);
}
