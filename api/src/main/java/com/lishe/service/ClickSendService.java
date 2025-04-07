package com.lishe.service;

import ClickSend.Api.SmsApi;
import ClickSend.ApiClient;
import ClickSend.ApiException;
import ClickSend.Model.SmsMessage;
import ClickSend.Model.SmsMessageCollection;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClickSendService {
    private final ApiClient apiClient;

    @Autowired
    public ClickSendService(ApiClient apiClient) {
        this.apiClient = apiClient;
    }

    public void sendOtp(String to, String otp) throws ApiException {
        SmsApi smsApi = new SmsApi(apiClient);
        String messageBody = String.format(
                """
                        Lishe App - Verify your identity
                        
                        We noticed a sign-in attempt to your account.
                        Use this code to complete the sign-in:
                        
                        Verification Code: %s
                        
                        This code will expire in 10 minutes.
                        If this wasn't you, please secure your account.""",otp);
        SmsMessage message = new SmsMessage();
        message.setBody(messageBody);
        message.setFrom("Lishe App");
        message.setTo(to);
        message.setSource("Lishe Application");

        List<SmsMessage> messages = List.of(message);
        SmsMessageCollection smsMessages = new SmsMessageCollection();
        smsMessages.messages(messages);
        smsApi.smsSendPost(smsMessages);
    }
}
