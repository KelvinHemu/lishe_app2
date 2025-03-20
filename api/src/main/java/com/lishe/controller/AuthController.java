package com.lishe.controller;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.*;
import com.lishe.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import com.lishe.dto.CreatePassword;
import com.lishe.dto.InitialSignUp;
import com.lishe.dto.BasicInfo;
import com.lishe.entity.Users;


@RequiredArgsConstructor
@RestController
@RequestMapping(path= "/api/v1")
public class AuthController {
    private final AuthService authService;

    @PostMapping("/initial-registration")
    public ResponseEntity<InitialSignUp> initialRegistration(@RequestBody InitialSignUp initialSignUpDto) {
        return authService.initialRegistration(initialSignUpDto);
    }

    @PostMapping("/create-password")
    public ResponseEntity<String> createPassword(@RequestBody CreatePassword createPasswordDto) {
        return authService.createPassword(createPasswordDto);
    }

    @PostMapping("/complete-sign-up")
    public ResponseEntity<Users> completeSignUp(@RequestBody BasicInfo basicInfoDto) {
        return authService.completeSignUp(basicInfoDto);
    }
}
