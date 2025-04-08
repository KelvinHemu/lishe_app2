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
    @NotBlank
    private String identifier;
    @NotBlank
    private Integer goals;
    @NotBlank
    private String activity;
    @Positive
    private double height;
    @Positive
    private double weight;
    @PositiveOrZero
    private double bmiValue;
    @NotBlank
    private String groupAge;
    @NotBlank
    private String gender;
    @NotBlank
    private String dietType;
    private Set<String> foodAllergies;
    private Set<String> favoriteFoods;
}
