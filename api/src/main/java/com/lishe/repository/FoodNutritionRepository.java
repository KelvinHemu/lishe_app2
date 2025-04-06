package com.lishe.repository;

import com.lishe.entity.FoodItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FoodNutritionRepository extends JpaRepository<FoodItem, Integer> {

}
