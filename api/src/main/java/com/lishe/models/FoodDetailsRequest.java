package com.lishe.models;

import lombok.*;
import org.springframework.web.multipart.MultipartFile;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class FoodDetailsRequest {
    private String name;
    private String description;
    private String category;
    private MultipartFile image;
}
