package com.app.store.repository;

import com.app.store.entity.StorePolicy;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface StorePolicyRepository extends JpaRepository<StorePolicy, Long> {
    Optional<StorePolicy> findByTopic(String topic);
}
