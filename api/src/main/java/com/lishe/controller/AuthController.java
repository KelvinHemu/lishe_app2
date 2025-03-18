package com.lishe.controller;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.*;
import com.lishe.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import com.lishe.dto.UserDTO;


@RequiredArgsConstructor
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final AuthService authService;

    @PostMapping("/initial-registration")
    public ResponseEntity<String> initialRegistration(@RequestBody UserDTO userdto) {
        String response= authService.initialRegistration(userdto);
        if(response.contains("User registered successfully")){
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.badRequest().body(response);
    }

    @PostMapping("/create-password")
    public ResponseEntity<String> createPassword(@RequestBody UserDTO userdto) {
        String response= authService.createPassword(userdto);
        if(response.contains("Password created successfully")){
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.badRequest().body(response);
    }

    @PostMapping("/complete-sign-up")
    public ResponseEntity<String> completeSignUp(@RequestBody UserDTO userdto) {
        String response= authService.completeSignUp(userdto);
        if(response.contains("User details updated successfully")){
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.badRequest().body(response);
    }
}
