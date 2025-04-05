package com.lishe.service;
import com.lishe.entity.Otp;
import com.lishe.exception.HandleOtpException;
import com.lishe.exception.UserAlreadyExistsException;
import com.lishe.repository.OtpRepository;
import com.lishe.repository.UserRepository;

import jakarta.persistence.EntityNotFoundException;
import lombok.extern.log4j.Log4j2;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.lishe.entity.Users;
import lombok.RequiredArgsConstructor;

import java.time.LocalDateTime;
import java.util.Optional;


@Service
@RequiredArgsConstructor
@Log4j2
public class AuthService {

    private final UserRepository userRepository;
    private final OtpRepository otpRepo;
    private final PasswordEncoder passwordEncoder;
    private final TwilioService twilioService;

    public String signUp(String username, String mobile){
        Optional<Users> user = userRepository.findByUsername(username);
        if(user.isPresent()){
            throw new UserAlreadyExistsException("Username already taken");
        }

        Optional<Users> userByMobile = userRepository.findByMobile(mobile);
        if (userByMobile.isPresent()) {
            throw new UserAlreadyExistsException("Mobile number already registered");
        }

        String codes = Generator.generateOtp();
        log.debug("OTP generated for user: {}", username);
        Users users = Users.builder()
                .username(username)
                .mobile(mobile)
                .build();
        userRepository.save(users);

        Otp otp = Otp.builder()
                .otpCode(codes)
                .users(users)
                .build();
        otpRepo.save(otp);
        twilioService.sendOtp(mobile, codes);
        log.debug("OTP Codes sent to your phone number {}", mobile);

        return "OTP Codes sent to your phone number";
    }

    public String verifyOtpCode(String mobile, String otpCode){
       Users user = userRepository.findByMobile(mobile).orElseThrow(
               ()-> new EntityNotFoundException("User not found"));
       Otp otp = otpRepo.findByUsers(user).orElseThrow(
               ()-> new EntityNotFoundException("Otp for user with mobile number " + mobile + " not found"));

       long OTP_EXPIRATION_MINUTES = 30;
       String storedOtp = otp.getOtpCode();
       if (!storedOtp.equals(otpCode)){
           throw new HandleOtpException("Invalid OTP Code");
       }else if (LocalDateTime.now().minusMinutes(OTP_EXPIRATION_MINUTES).isAfter(otp.getCreatedAt())) {
           otpRepo.delete(otp);
           throw new HandleOtpException("Your OTP code has expired");
       }
       otpRepo.delete(otp);
       return "OTP Code verified successfully";
    }
}
