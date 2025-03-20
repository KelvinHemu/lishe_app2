package com.lishe.service;
import com.lishe.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.lishe.dto.BasicInfo;
import java.util.Optional;
import com.lishe.entity.Users;
import com.lishe.models.UserRoles;
import com.lishe.exception.UsernameExistsException;
import lombok.RequiredArgsConstructor;
import jakarta.persistence.EntityNotFoundException;
import com.lishe.dto.CreatePassword;
import com.lishe.dto.InitialSignUp;



@Service
@RequiredArgsConstructor
public class AuthService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    BasicInfo basicInfoDto= new BasicInfo();
    CreatePassword createPasswordDto= new CreatePassword();
    InitialSignUp initialSignUpDto= new InitialSignUp();

    public String initialRegistration(InitialSignUp initialSignUpDto) {
        Optional<Users> existingUser = userRepository.findByUsername(initialSignUpDto.getUsername());
        if (existingUser.isPresent()) {
            return new UsernameExistsException("EMAIL_ALREADY_EXISTS", "User already exists").getMessage();
        }
        if (initialSignUpDto.getUsername()== null || initialSignUpDto.getUsername().trim().isEmpty() || initialSignUpDto.getPhoneNumber()== null||initialSignUpDto.getPhoneNumber().trim().isEmpty()){
            return new NullPointerException("Credentials can't be empty").getMessage();
        }
        Users user = new Users();
        user.setUsername(initialSignUpDto.getUsername());
        user.setPhoneNumber(initialSignUpDto.getPhoneNumber());
        user.setRoles(UserRoles.USER);
        userRepository.save(user);
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

    public String createPassword(CreatePassword createPasswordDto){
        Optional<Users> existingUser = userRepository.findByUsername(createPasswordDto.getUsername());
        if (existingUser.isEmpty()) {
            return new EntityNotFoundException( "User not found").getMessage();
        }
        Users user=existingUser.get();
        user.setPassword(passwordEncoder.encode(createPasswordDto.getPassword()));
        userRepository.save(user);
        return "Password created successfully";
    }

    public String completeSignUp(BasicInfo basicInfoDto){
        Optional<Users> existingUser= userRepository.findByUsername(basicInfoDto.getUsername());
        if (existingUser.isEmpty()) {
            return new EntityNotFoundException( "User not found").getMessage();
        }
        Users user=existingUser.get();
        user.setHeight(basicInfoDto.getHeight());
        user.setWeight(basicInfoDto.getWeight());
        user.setBirthYear(basicInfoDto.getBirthYear());
        user.setGender(basicInfoDto.getGender());
        user.setMealFrequency(basicInfoDto.getMealFrequency());
        user.setPrimaryGoal(basicInfoDto.getPrimaryGoal());
        user.setTargetWeight(basicInfoDto.getTargetWeight());
        user.setActivityLevel(basicInfoDto.getActivityLevel());
        user.setHealthGoals(basicInfoDto.getHealthGoals());
        user.setDietType(basicInfoDto.getDietType());
        user.setFoodallergies(basicInfoDto.getFoodallergies());
        user.setRegularFoods(basicInfoDto.getRegularFoods());
        user.setHealthConditions(basicInfoDto.getHealthConditions());
        userRepository.save(user);
        return "User details updated successfully";
    }
}
