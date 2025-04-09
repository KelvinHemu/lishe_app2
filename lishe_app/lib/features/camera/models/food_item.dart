// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_item.freezed.dart';
part 'food_item.g.dart';

@freezed
class FoodItem with _$FoodItem {
  const FoodItem._();

  const factory FoodItem({
    @JsonKey(name: 'food_id') required String foodId,
    @JsonKey(name: 'food_name') required String foodName,
    @JsonKey(name: 'brand_name') required String brandName,
    @JsonKey(name: 'food_type') required String foodType,
    @JsonKey(name: 'food_url') required String foodUrl,
    @JsonKey(name: 'calories') required double calories,
    @JsonKey(name: 'protein') required double protein,
    @JsonKey(name: 'fat') required double fat,
    @JsonKey(name: 'carbohydrate') required double carbs,
    @JsonKey(name: 'fiber') required double fiber,
    @JsonKey(name: 'sugar') required double sugar,
    @JsonKey(name: 'sodium') required double sodium,
    @JsonKey(name: 'potassium') required double potassium,
    @JsonKey(name: 'cholesterol') required double cholesterol,
    @JsonKey(name: 'saturated_fat') required double saturatedFat,
    @JsonKey(name: 'unsaturated_fat') required double unsaturatedFat,
    @JsonKey(name: 'trans_fat') required double transFat,
    @JsonKey(name: 'vitamin_a') required double vitaminA,
    @JsonKey(name: 'vitamin_c') required double vitaminC,
    @JsonKey(name: 'calcium') required double calcium,
    @JsonKey(name: 'iron') required double iron,
    @JsonKey(name: 'serving_size') required double servingSize,
    @JsonKey(name: 'serving_unit') required String servingUnit,
  }) = _FoodItem;

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);
}
