package com.lishe.controller;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.*;
import com.lishe.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import com.lishe.dto.CreatePassword;
import com.lishe.dto.InitialSignUp;
import com.lishe.dto.BasicInfo;


@RequiredArgsConstructor
@RestController
@RequestMapping(path= "/api/v1")
public class AuthController {
    private final AuthService authService;

    @PostMapping("/initial-registration")
    public ResponseEntity<String> initialRegistration(@RequestBody InitialSignUp initialSignUpDto) {
        String response= authService.initialRegistration(initialSignUpDto);
        if(response.contains("User registered successfully")){
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.badRequest().body(response);
    }

    @PostMapping("/create-password")
    public ResponseEntity<String> createPassword(@RequestBody CreatePassword createPasswordDto) {
        String response= authService.createPassword(createPasswordDto);
        if(response.contains("Password created successfully")){
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.badRequest().body(response);
    }

    @PostMapping("/complete-sign-up")
    public ResponseEntity<String> completeSignUp(@RequestBody BasicInfo basicInfoDto) {
        String response= authService.completeSignUp(basicInfoDto);
        if(response.contains("User details updated successfully")){
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.badRequest().body(response);
    }
}
