package com.app.store.repository;

import com.app.store.entity.Message;
import com.app.store.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MessageRepository extends JpaRepository<Message, Long> {

    
    @Query("SELECT m FROM Message m WHERE (m.sender = :user1 AND m.receiver = :user2) OR (m.sender = :user2 AND m.receiver = :user1) ORDER BY m.timestamp ASC")
    List<Message> findConversationHistory(@Param("user1") User user1, @Param("user2") User user2);

    
    @Query("SELECT DISTINCT u FROM User u WHERE u IN (SELECT m.receiver FROM Message m WHERE m.sender = :user) OR u IN (SELECT m.sender FROM Message m WHERE m.receiver = :user)")
    List<User> findConversingUsers(@Param("user") User user);
}
