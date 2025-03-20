package com.lishe.dto;
import lombok.*;


@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class UserDTO {
    private String username;
    private String password;
    private String token;
    private String phoneNumber;
    private float height;
    private float weight;
    private Integer birthYear;
    private String gender;
    private String mealFrequency;
    private String primaryGoal;
    private float targetWeight;
    private String activityLevel;
    private String healthGoals;
    private String dietType;
    private String foodallergies;
    private String regularFoods;
    private String healthConditions;
    
}
