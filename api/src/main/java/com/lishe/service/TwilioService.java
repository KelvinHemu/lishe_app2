package com.lishe.service;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;
import jakarta.annotation.PostConstruct;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
@Log4j2
public class TwilioService {

    @Value("${twilio.account.sid}")
    private String accountSid;

    @Value("${twilio.auth.token}")
    private String authToken;

    @Value("${twilio.phone.number}")
    private String fromNumber;

    @PostConstruct
    public void initTwilio() {
        Twilio.init(accountSid, authToken);
    }

    public void sendOtp(String to, String otp) {
        String messageBody = String.format(
                "Lishe App - Verify your identity\n\n" +
                        "We noticed a sign-in attempt to your account.\n" +
                        "Use this code to complete the sign-in:\n\n" +
                        "Verification Code: %s\n\n" +
                        "This code will expire in 10 minutes.\n" +
                        "If this wasn't you, please secure your account.",otp);

        Message message = Message.creator(
                        new PhoneNumber(to),
                        new PhoneNumber(fromNumber),
                        messageBody)
                .create();
        log.info(message);
    }

}
