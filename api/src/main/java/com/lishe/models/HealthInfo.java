package com.lishe.models;

import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
public class HealthInfo {
    private Integer goal;
    private Integer activityLevel;

}
