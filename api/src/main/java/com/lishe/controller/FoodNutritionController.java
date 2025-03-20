package com.lishe.controller;

import com.lishe.models.FoodDetailsResponse;
import com.lishe.service.FoodNutritionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequestMapping(path = "/api/v1/dashboard")
@RequiredArgsConstructor
public class FoodNutritionController {

    private final FoodNutritionService foodNutritionService;

    @Operation(summary = "Insert food related details")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Food details saved successfully"),
            @ApiResponse(responseCode = "400", description = "Bad request"),
    })
    @PostMapping("/insert-food-details")
    public ResponseEntity<FoodDetailsResponse> insertFoodDetails(
            @RequestParam(name = "name") String foodName, @RequestParam(name = "description") String description,
            @RequestParam(name = "category") String category, @RequestParam(name = "image") MultipartFile image
    ) throws IOException {
        if (image.isEmpty()) {
            throw new NullPointerException("Oops! Image is empty!");
        }

        return foodNutritionService.insertFoodDetails(foodName, description, category, image);
    }
}
