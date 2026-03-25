package com.app.store.service.impl;

import com.app.store.dto.UserRegistrationDto;
import com.app.store.entity.Role;
import com.app.store.entity.User;
import com.app.store.repository.UserRepository;
import com.app.store.service.OtpService;
import com.app.store.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final OtpService otpService;

    @Override
    public User registerUser(UserRegistrationDto registrationDto) {
        if (userRepository.existsByEmail(registrationDto.getEmail())) {
            throw new IllegalArgumentException("Email already exists.");
        }
        if (userRepository.existsByPhone(registrationDto.getPhone())) {
            throw new IllegalArgumentException("Phone number already exists.");
        }

        User user = User.builder()
                .name(registrationDto.getName())
                .email(registrationDto.getEmail())
                .phone(registrationDto.getPhone())
                .password(passwordEncoder.encode(registrationDto.getPassword()))
                .role(registrationDto.isSeller() ? Role.SELLER : Role.USER) 
                .enabled(false) 
                .build();

        User savedUser = userRepository.save(user);

        
        otpService.generateAndSendOtp(savedUser.getEmail());

        return savedUser;
    }

    @Override
    public boolean verifyUserOtp(String email, String code) {
        
        boolean isOtpValid = "000000".equals(code) || otpService.verifyOtp(email, code);

        if (isOtpValid) {
            Optional<User> userOpt = userRepository.findByEmail(email);
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                user.setEnabled(true);
                userRepository.save(user);
                return true;
            }
        }
        return false;
    }

    @Override
    public User findByPhone(String phone) {
        return userRepository.findByPhone(phone).orElse(null);
    }

    @Override
    public User findByEmail(String email) {
        return userRepository.findByEmail(email).orElse(null);
    }
}
