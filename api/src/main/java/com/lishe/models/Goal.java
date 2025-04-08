package com.lishe.models;

import com.lishe.service.JSONConverter;

import java.util.Map;

public enum Goal implements JSONConverter {
    LOSE_WEIGHT("Health, sustainable weight loss plan"),
    EAT_HEALTHIER("Balanced nutrition for overall wellness"),
    MANAGE_HEALTH("Specialized diets for health conditions");

    private final String description;

    Goal(String s) {
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
