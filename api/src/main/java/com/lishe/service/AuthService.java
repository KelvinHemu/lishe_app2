package com.lishe.service;
import com.lishe.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.lishe.dto.UserDTO;
import java.util.Optional;
import com.lishe.entity.Users;
import com.lishe.entity.UserRoles;
import com.lishe.exception.UsernameExistsException;
import lombok.RequiredArgsConstructor;
import com.lishe.security.service.JwtService;
import jakarta.persistence.EntityNotFoundException;



@Service
@RequiredArgsConstructor
public class AuthService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    UserDTO userdto= new UserDTO();

    public String initialRegistration(UserDTO userdto) {
        Optional<Users> existingUser = userRepository.findByUsername(userdto.getUsername());
        if (existingUser.isPresent()) {
            return new UsernameExistsException("EMAIL_ALREADY_EXISTS", "User already exists").getMessage();
        }
        if (userdto.getUsername()== null || userdto.getUsername().trim().isEmpty() || userdto.getPhoneNumber()== null||userdto.getPhoneNumber().trim().isEmpty()){
            return new NullPointerException("Credentials can't be empty").getMessage();
        }
        Users user = new Users();
        user.setUsername(userdto.getUsername());
        user.setPhoneNumber(userdto.getPhoneNumber());
        user.setRoles(UserRoles.USER);
        return "User registered successfully";
    }
    //Implementation of sending OTP token
    
    /*public String verifyToken(UserDTO userdto){
        String token= userdto.getToken();
        if(token==null){
            return new NullPointerException("Token can't be empty").getMessage();
        }
    }*/
    //TODO:Implement OTP verification

    public String createPassword(UserDTO userdto){
        Optional<Users> existingUser = userRepository.findByUsername(userdto.getUsername());
        if (existingUser.isEmpty()) {
            return new EntityNotFoundException( "User not found").getMessage();
        }
        if(!userdto.getConfirmPassword().equals(userdto.getPassword())){
            return new IllegalArgumentException("Passwords do not match").getMessage();
        }
        Users user=existingUser.get();
        user.setPassword(passwordEncoder.encode(userdto.getPassword()));
        userRepository.save(user);
        return "Password created successfully";
    }

    public String completeSignUp(UserDTO userdto){
        Optional<Users> existingUser= userRepository.findByUsername(userdto.getUsername());
        if (existingUser.isEmpty()) {
            return new EntityNotFoundException( "User not found").getMessage();
        }
        Users user=existingUser.get();
        user.setHeight(userdto.getHeight());
        user.setWeight(userdto.getWeight());
        user.setBirthYear(userdto.getBirthYear());
        user.setGender(userdto.getGender());
        user.setMealFrequency(userdto.getMealFrequency());
        user.setPrimaryGoal(userdto.getPrimaryGoal());
        user.setTargetWeight(userdto.getTargetWeight());
        user.setActivityLevel(userdto.getActivityLevel());
        user.setHealthGoals(userdto.getHealthGoals());
        user.setDietType(userdto.getDietType());
        user.setFoodallergies(userdto.getFoodallergies());
        user.setRegularFoods(userdto.getRegularFoods());
        user.setHealthConditions(userdto.getHealthConditions());
        userRepository.save(user);
        return "User details updated successfully";
    }


}
