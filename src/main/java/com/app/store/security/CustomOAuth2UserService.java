package com.app.store.security;

import com.app.store.entity.AuthProvider;
import com.app.store.entity.Role;
import com.app.store.entity.User;
import com.app.store.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final UserRepository userRepository;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(userRequest);

        try {
            return processOAuth2User(userRequest, oAuth2User);
        } catch (Exception ex) {
            
            
            throw new OAuth2AuthenticationException(ex.getMessage());
        }
    }

    private OAuth2User processOAuth2User(OAuth2UserRequest oAuth2UserRequest, OAuth2User oAuth2User) {
        String registrationId = oAuth2UserRequest.getClientRegistration().getRegistrationId();

        
        String email = "";
        String name = "";

        if (registrationId.equalsIgnoreCase(AuthProvider.GOOGLE.name())) {
            email = oAuth2User.getAttribute("email");
            name = oAuth2User.getAttribute("name");
        }

        if (email == null || email.isEmpty()) {
            throw new OAuth2AuthenticationException("Email not found from OAuth2 provider");
        }

        Optional<User> userOptional = userRepository.findByEmail(email);
        User user;

        if (userOptional.isPresent()) {
            user = userOptional.get();
            
            if (!user.getProvider().name().equalsIgnoreCase(registrationId)) {
                
                
                user.setProvider(AuthProvider.valueOf(registrationId.toUpperCase()));
                user = userRepository.save(user);
            }
        } else {
            
            user = new User();
            user.setEmail(email);
            user.setName(name != null ? name : "Guest");
            user.setProvider(AuthProvider.valueOf(registrationId.toUpperCase()));
            user.setRole(Role.USER); 
            user.setEnabled(true); 

            
            
            user.setPassword(UUID.randomUUID().toString());

            user = userRepository.save(user);
        }

        
        return CustomUserDetails.create(user, oAuth2User.getAttributes());
    }
}
