package com.lishe.models;

import com.lishe.service.JSONConverter;


import java.util.Map;


public enum Age implements JSONConverter {
    INFANCY("0-1 year: Focus on growth and development, vaccinations, nutrition, and identifying potential developmental delays."),
    CHILDHOOD("1-12 years: Emphasis on immunizations, healthy eating habits, physical activity, and addressing common childhood illnesses."),
    ADOLESCENCE("13-19 years: Concerns include puberty, mental health, substance use prevention, and promoting healthy behaviors."),
    YOUNG_ADULTHOOD("20-39 years: Focus on establishing healthy lifestyles, reproductive health, and managing chronic conditions that may emerge."),
    MIDDLE_ADULTHOOD("40-59 years: Emphasis on preventive screenings, managing chronic conditions, and maintaining a healthy weight."),
    OLDER_ADULTHOOD("60+ years: Prioritizes maintaining independence, managing age-related conditions, and promoting cognitive and physical well-being.");

    private final String description;
    Age(String s) {
        this.description = s;
    }

    @Override
    public Map<String, String> toMap() {
        return Map.of(
                "code", this.name(),
                "description", this.description
        );
    }
}
