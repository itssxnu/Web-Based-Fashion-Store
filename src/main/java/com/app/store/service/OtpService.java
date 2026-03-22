package com.app.store.service;

import com.app.store.entity.Otp;

public interface OtpService {
    Otp generateAndSendOtp(String phoneNumber);
    
    Otp generateAndSendCheckoutOtp(String phoneNumber);

    boolean verifyOtp(String phoneNumber, String code);
}
