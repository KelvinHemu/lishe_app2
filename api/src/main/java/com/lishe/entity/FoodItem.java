package com.lishe.entity;


import com.lishe.models.Category;
import jakarta.persistence.*;
import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@Builder
@Entity
@Table(name = "food_items")
public class FoodItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String name;// name of the food
    private String description;
    @Enumerated(EnumType.STRING)
    private Category category;
    private String image;//name of the image/url
    private int views;
    private int likes;

}
