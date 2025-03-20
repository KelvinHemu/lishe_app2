package com.lishe.service;

import com.lishe.models.FoodDetailsResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface BaseService {
    ResponseEntity<FoodDetailsResponse> insertFoodDetails(String foodName, String description, String category, MultipartFile image) throws IOException;
}
