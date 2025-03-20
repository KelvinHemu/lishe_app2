package com.lishe.models;

import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
public class FoodDetailsResponse {
    private String message;
    private Integer id;
}
