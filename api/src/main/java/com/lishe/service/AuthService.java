package com.lishe.service;
import com.lishe.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.lishe.dto.UserDTO;
import java.util.Optional;
import com.lishe.entity.Users;
import com.lishe.entity.UserRoles;

@Service
public class AuthService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    UserDTO userdto= new UserDTO();

    public String initialRegistration(UserDTO userdto) {
        Optional<Users> existingUser = userRepository.findByUsername(userdto.getUsername());
        if (existingUser.isPresent()) {
            return "User already exists";
        }
        if (userdto.getUsername()== null || userdto.getPhoneNumber()== null){
            return "Credentials can't be empty";
        }
        Users user = new Users();
        user.setUsername(userdto.getUsername());
        user.setPhoneNumber(userdto.getPhoneNumber());
        user.setRoles(UserRoles.USER);
        return "User registered successfully";

}
}
