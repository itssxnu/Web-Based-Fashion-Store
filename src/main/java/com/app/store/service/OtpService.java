package com.app.store.service;

import com.app.store.entity.Otp;

public interface OtpService {
    Otp generateAndSendOtp(String email);
    
    Otp generateAndSendCheckoutOtp(String email);

    boolean verifyOtp(String email, String code);
}
