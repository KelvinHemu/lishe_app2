package com.lishe.controller;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.*;
import com.lishe.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import com.lishe.dto.CreatePassword;
import com.lishe.dto.InitialSignUp;
import com.lishe.dto.BasicInfo;
import com.lishe.entity.Users;


@RestController
@RequestMapping(path= "/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @Operation(summary = "Create an account")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "An account created successfully"),
            @ApiResponse(responseCode = "409", description = "Conflict: The username or mobile number is already in use"),
    })
    @PostMapping("/create-account")
    public ResponseEntity<String> createAccount(@RequestBody BasicInfo basicInfo) {
        if (basicInfo == null || basicInfo.getMobile() == null || basicInfo.getMobile().isEmpty()) {
            return ResponseEntity.badRequest().body("Please provide a valid information");
        }
        String username = basicInfo.getUsername();
        String mobile = basicInfo.getMobile();
        final String response = authService.signUp(username, mobile);
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "Verify OTP codes to activate account")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "An account created successfully"),
            @ApiResponse(responseCode = "401", description = "Bad request: \nUsername provided does not exist\nOTP code has expired or invalid"),
    })
    @PostMapping("/verify-otp")
    public ResponseEntity<String> verifyOtp(@RequestParam(name = "mobile", required = false) String mobile, @RequestParam(name = "otp", required = false) String otp) {
        if (mobile == null || otp == null) {
            return ResponseEntity.badRequest().body("Please provide a valid mobile number");
        }
        final String response = authService.verifyOtpCode(mobile, otp);
        return ResponseEntity.ok(response);
    }

}
