package com.app.store.service;

import com.app.store.dto.UserRegistrationDto;
import com.app.store.entity.User;

public interface UserService {
    User registerUser(UserRegistrationDto registrationDto);

    boolean verifyUserOtp(String phone, String code);

    User findByPhone(String phone);

    User findByEmail(String email);
}
