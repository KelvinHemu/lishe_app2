package com.lishe.controller;
import ClickSend.ApiException;
import com.lishe.models.HealthInfoRequest;
import com.lishe.models.OnboardResponse;
import com.lishe.service.BaseService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.*;
import com.lishe.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import com.lishe.models.CreatePassword;
import com.lishe.models.BasicInfo;


@RestController
@RequestMapping(path= "/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;
    private final BaseService baseService;

    @Operation(summary = "Create an account")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "An account created successfully"),
            @ApiResponse(responseCode = "409", description = "Conflict: The username or mobile number is already in use"),
    })
    @PostMapping("/create-account")
    public ResponseEntity<String> createAccount(@RequestBody BasicInfo basicInfo) throws ApiException {
        if (basicInfo == null || basicInfo.getMobile() == null || basicInfo.getMobile().isEmpty()) {
            return ResponseEntity.badRequest().body("Please provide a valid information");
        }

        final String response = authService.signUp(basicInfo);
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

    @Operation(summary = "Create account password")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Password created successfully"),
            @ApiResponse(responseCode = "401", description = "Bad request: \nUsername provided does not exist"),
    })
    @PostMapping("/create-password")
    public ResponseEntity<String> createPassword(@RequestBody @Valid CreatePassword createPassword) {
        final String username = createPassword.getUsername();
        final String password = createPassword.getPassword();
        final String response = authService.signUp(username, password);
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "Complete on boarding")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Password created successfully"),
            @ApiResponse(responseCode = "401", description = "Bad request: \nUsername provided does not exist"),
    })
    @PostMapping("/onboarding")
    public ResponseEntity<OnboardResponse> completeOnBoarding(@RequestBody HealthInfoRequest infoRequest){

    }

}
