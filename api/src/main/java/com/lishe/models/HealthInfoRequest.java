package com.lishe.models;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.*;

import java.util.Set;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@Builder
public class HealthInfoRequest {
    @NotBlank(message = "username is required")
    private String identifier;
    @NotBlank(message = "personal goal is required")
    private Integer goals;
    @NotBlank
    private String activity;
    @Positive(message = "Height must be positive")
    private double height;
    @Positive(message = "Weight must be positive")
    private double weight;
    @PositiveOrZero
    private double bmiValue;
    @NotBlank(message = "Age group is required")
    private String groupAge;
    @NotBlank(message = "Gender is required")
    private String gender;
    @NotBlank(message = "diet type is required")
    private String dietType;
    private Set<String> foodAllergies;
    private Set<String> favoriteFoods;
}
