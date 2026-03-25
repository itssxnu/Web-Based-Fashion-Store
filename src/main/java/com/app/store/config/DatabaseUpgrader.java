package com.app.store.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Component
@RequiredArgsConstructor
@Slf4j
public class DatabaseUpgrader implements CommandLineRunner {

    private final JdbcTemplate jdbcTemplate;

    @Override
    public void run(String... args) {
        try {
            jdbcTemplate.execute("ALTER TABLE otps CHANGE phone email VARCHAR(255) NOT NULL");
            log.info("DatabaseUpgrader: Column 'phone' renamed to 'email' in 'otps' table successfully.");
        } catch (Exception e) {
            log.debug("DatabaseUpgrader: Column rename skipped. It might already be renamed.");
        }
    }
}
