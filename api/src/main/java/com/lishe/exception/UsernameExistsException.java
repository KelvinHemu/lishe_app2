package com.lishe.exception;

import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper=true)
@Data
public class UsernameExistsException extends RuntimeException {
    private final String errorCode;
    private final String message;

    public UsernameExistsException(String errorCode, String message) {
        super(message);
        this.errorCode = errorCode;
        this.message = message;
    }
}
