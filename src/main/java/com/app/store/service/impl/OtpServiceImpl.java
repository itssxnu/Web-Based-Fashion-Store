package com.app.store.service.impl;

import com.app.store.entity.Otp;
import com.app.store.entity.User;
import com.app.store.repository.OtpRepository;
import com.app.store.repository.UserRepository;
import com.app.store.service.EmailService;
import com.app.store.service.OtpService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Random;

@Service
@RequiredArgsConstructor
@Slf4j
public class OtpServiceImpl implements OtpService {

    private final OtpRepository otpRepository;
    private final UserRepository userRepository;
    private final EmailService emailService;

    
    private static final int OTP_VALIDITY_MINUTES = 5;

    @Override
    public Otp generateAndSendOtp(String phoneNumber) {
        
        String code = String.format("%06d", new Random().nextInt(999999));

        Otp otp = Otp.builder()
                .phone(phoneNumber)
                .code(code)
                .expiresAt(LocalDateTime.now().plusMinutes(OTP_VALIDITY_MINUTES))
                .verified(false)
                .build();

        otpRepository.save(otp);

        
        Optional<User> userOpt = userRepository.findByPhone(phoneNumber);
        if (userOpt.isPresent()) {
            emailService.sendOtpEmail(userOpt.get().getEmail(), code);
        } else {
            log.warn("Cannot send OTP email. No user found matched to phone: {}", phoneNumber);
        }

        return otp;
    }

    @Override
    public Otp generateAndSendCheckoutOtp(String phoneNumber) {
        String code = String.format("%06d", new Random().nextInt(999999));

        Otp otp = Otp.builder()
                .phone(phoneNumber)
                .code(code)
                .expiresAt(LocalDateTime.now().plusMinutes(OTP_VALIDITY_MINUTES))
                .verified(false)
                .build();

        otpRepository.save(otp);

        Optional<User> userOpt = userRepository.findByPhone(phoneNumber);
        if (userOpt.isPresent()) {
            emailService.sendCheckoutOtpEmail(userOpt.get().getEmail(), code);
        } else {
            log.warn("Cannot send Checkout OTP email. No user found matched to phone: {}", phoneNumber);
        }

        return otp;
    }

    @Override
    public boolean verifyOtp(String phoneNumber, String code) {
        Optional<Otp> otpOptional = otpRepository.findTopByPhoneOrderByExpiresAtDesc(phoneNumber);

        if (otpOptional.isPresent()) {
            Otp otp = otpOptional.get();

            if (otp.isVerified()) {
                return false; 
            }

            if (otp.getExpiresAt().isBefore(LocalDateTime.now())) {
                return false; 
            }

            if (otp.getCode().equals(code)) {
                otp.setVerified(true);
                otpRepository.save(otp);
                return true;
            }
        }

        return false;
    }
}
