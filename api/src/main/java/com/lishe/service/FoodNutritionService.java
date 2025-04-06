package com.lishe.service;

import com.lishe.entity.FoodItem;
import com.lishe.models.Category;
import com.lishe.models.FoodDetailsResponse;
import com.lishe.repository.FoodNutritionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Objects;

@Service
@RequiredArgsConstructor
public class FoodNutritionService implements BaseService {

    private final FoodNutritionRepository foodNutritionRepository;

    @Override
    public ResponseEntity<FoodDetailsResponse> insertFoodDetails(String foodName, String description, String category, MultipartFile image) throws IOException {
           String imageName = null;
           if (!StringUtils.isEmpty(image)) {
               validateImageType(image);
               imageName = storeImages(image);
           }

           FoodItem foodItem = new FoodItem();
           foodItem.setName(foodName);
           foodItem.setDescription(description);
           foodItem.setImage(imageName);
           foodItem.setCategory(Category.valueOf(category));
           foodNutritionRepository.save(foodItem);

        return ResponseEntity.ok(FoodDetailsResponse.builder()
                .id(foodItem.getId())
                .message("Saved Successfully")
                .build());
    }

    private void validateImageType(MultipartFile image) {
        String contentType = image.getContentType();
        if (contentType == null || (!contentType.equals("image/png") &&
                !contentType.equals("image/jpeg") &&
                !contentType.equals("image/jpg"))) {
            throw new IllegalArgumentException("Invalid image format. Only PNG, JPG, and JPEG are allowed.");
        }
    }

    private String storeImages(MultipartFile image) throws IOException {
        if (image == null || image.isEmpty()) {
            throw new IllegalArgumentException("Image file is null or empty");
        }

        String uploadDirectory = "src/main/resources/static";
        String imageName = StringUtils.cleanPath(Objects.requireNonNull(image.getOriginalFilename()));

        if (imageName.contains("..")) {
            throw new IllegalArgumentException("Invalid file format");
        }

        Path uploadPath = Paths.get(uploadDirectory);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        Path filePath = uploadPath.resolve(imageName);
        Files.copy(image.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return imageName;
    }
}
