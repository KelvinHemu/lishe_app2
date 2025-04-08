package com.lishe.models;

import com.lishe.service.JSONConverter;

import java.util.Map;

public enum ActivityLevel implements JSONConverter {
    SEDENTARY("Little or no exercise"),
    LIGHTLY_ACTIVE("Light exercise 1-3 days/week"),
    MODERATELY_ACTIVE("Moderate exercise 3-5 days/week"),
    VERY_ACTIVE("Hard exercise 6-7 days/week");

    private final String description;

    ActivityLevel(String s) {
        this.description = s;
    }

    public String description() {
        return description;
    }

    @Override
    public Map<String, String> toMap() {
        return Map.of(
                "code", this.name(),
                "description", this.description
        );
    }
}
