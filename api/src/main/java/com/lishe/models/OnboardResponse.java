package com.lishe.models;

import lombok.*;

import java.util.Map;
import java.util.Set;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
public class OnboardResponse {
    private String username;
    private Map<String, String> goal;
    private String gender;
    private String dietType;
    private Map<String, String> level;
    private String mobile;
    private double height;
    private double weight;
    private Map<String, String> age;
    private Set<String> alleges;
    private Set<String> favorites;
}
