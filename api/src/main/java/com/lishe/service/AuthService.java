package com.lishe.service;
import ClickSend.ApiException;
import com.lishe.models.*;
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
    private final ClickSendService clickSendService;

    public String signUp(BasicInfo basicInfo) throws ApiException {
        Optional<Users> user = userRepository.findByUsername(basicInfo.getUsername());
        if(user.isPresent()){
            throw new UserAlreadyExistsException("Username already taken");
        }

        Optional<Users> userByMobile = userRepository.findByMobile(basicInfo.getMobile());
        if (userByMobile.isPresent()) {
            throw new UserAlreadyExistsException("Mobile number already registered");
        }

        String codes = Generator.generateOtp();
        log.debug("OTP generated for user: {}", basicInfo.getUsername());
        Users users = Users.builder()
                .username(basicInfo.getUsername())
                .mobile(basicInfo.getMobile())
                .build();
        userRepository.save(users);

        Otp otp = Otp.builder()
                .otpCode(codes)
                .users(users)
                .build();
        otpRepo.save(otp);
        clickSendService.sendOtp(basicInfo.getMobile(), codes);
        log.debug("OTP Codes sent to your phone number {}", basicInfo.getMobile());
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

    public String signUp(String username, String password){
        return userRepository.findByUsername(username).map(
                users -> {
                    users.setPassword(passwordEncoder.encode(password));
                    users.setRoles(UserRoles.USER);
                    userRepository.save(users);
                    return "Password saved successfully";
                }
        ).orElseThrow(()-> new EntityNotFoundException("User not found"));
    }

    public OnboardResponse onboarding(HealthInfoRequest infoRequest){
        return userRepository.findByUsername(infoRequest.getIdentifier()).map(
                users -> {
                    Goal goal = getGoal(infoRequest.getGoals());
                    ActivityLevel level = getLevel(infoRequest.getActivity());
                    Age age = getAge(infoRequest.getGroupAge());

                    users.setGoal(goal);
                    users.setAge(age);
                    users.setLevel(level);
                    users.setHeight(infoRequest.getHeight());
                    users.setWeight(infoRequest.getWeight());
                    users.setBmiValue(infoRequest.getBmiValue());
                    users.setGender(infoRequest.getGender());
                    users.setDietType(infoRequest.getDietType());
                    users.setFoodAllergies(infoRequest.getFoodAllergies() != null ? infoRequest.getFoodAllergies() : null);
                    users.setFavoriteFoods(infoRequest.getFavoriteFoods() != null ? infoRequest.getFavoriteFoods() : null);
                    userRepository.save(users);

                    return OnboardResponse.builder()
                            .username(users.getUsername())
                            .gender(users.getGender())
                            .goal(goal.toMap())
                            .mobile(users.getMobile())
                            .level(level.toMap())
                            .alleges(users.getFoodAllergies())
                            .favorites(users.getFavoriteFoods())
                            .height(users.getHeight())
                            .weight(users.getWeight())
                            .dietType(users.getDietType())
                            .age(age.toMap()).build();
                }
        ).orElseThrow(()-> new EntityNotFoundException("User not found with identifier: "+infoRequest.getIdentifier()));
    }

    public Goal getGoal(Integer goal){
        return switch (goal){
            case 100 -> Goal.LOSE_WEIGHT;
            case 200 -> Goal.EAT_HEALTHIER;
            case 300 -> Goal.MANAGE_HEALTH;
            default -> throw new IllegalArgumentException("Invalid goal input");
        };
    }

    public ActivityLevel getLevel(String level){
        return switch (level){
            case "0-1" -> ActivityLevel.SEDENTARY;
            case "1-3" -> ActivityLevel.LIGHTLY_ACTIVE;
            case "3-5" -> ActivityLevel.MODERATELY_ACTIVE;
            case "5-7" -> ActivityLevel.VERY_ACTIVE;
            default -> throw new IllegalArgumentException("Invalid level input");
        };
    }

    public Age getAge(String group){
        return switch (group){
            case "0-1" -> Age.INFANCY;
            case "1-12" -> Age.CHILDHOOD;
            case "13-19" -> Age.ADOLESCENCE;
            case "20-39" -> Age.YOUNG_ADULTHOOD;
            case "40-59" -> Age.MIDDLE_ADULTHOOD;
            case "60+ years" -> Age.OLDER_ADULTHOOD;
            default -> throw new IllegalArgumentException("Invalid group age input");
        };
    }

}
