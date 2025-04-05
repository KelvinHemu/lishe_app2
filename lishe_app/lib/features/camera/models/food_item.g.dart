// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodItemImpl _$$FoodItemImplFromJson(Map<String, dynamic> json) =>
    _$FoodItemImpl(
      foodId: json['food_id'] as String,
      foodName: json['food_name'] as String,
      brandName: json['brand_name'] as String,
      foodType: json['food_type'] as String,
      foodUrl: json['food_url'] as String,
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      carbs: (json['carbohydrate'] as num).toDouble(),
      fiber: (json['fiber'] as num).toDouble(),
      sugar: (json['sugar'] as num).toDouble(),
      sodium: (json['sodium'] as num).toDouble(),
      potassium: (json['potassium'] as num).toDouble(),
      cholesterol: (json['cholesterol'] as num).toDouble(),
      saturatedFat: (json['saturated_fat'] as num).toDouble(),
      unsaturatedFat: (json['unsaturated_fat'] as num).toDouble(),
      transFat: (json['trans_fat'] as num).toDouble(),
      vitaminA: (json['vitamin_a'] as num).toDouble(),
      vitaminC: (json['vitamin_c'] as num).toDouble(),
      calcium: (json['calcium'] as num).toDouble(),
      iron: (json['iron'] as num).toDouble(),
      servingSize: (json['serving_size'] as num).toDouble(),
      servingUnit: json['serving_unit'] as String,
    );

Map<String, dynamic> _$$FoodItemImplToJson(_$FoodItemImpl instance) =>
    <String, dynamic>{
      'food_id': instance.foodId,
      'food_name': instance.foodName,
      'brand_name': instance.brandName,
      'food_type': instance.foodType,
      'food_url': instance.foodUrl,
      'calories': instance.calories,
      'protein': instance.protein,
      'fat': instance.fat,
      'carbohydrate': instance.carbs,
      'fiber': instance.fiber,
      'sugar': instance.sugar,
      'sodium': instance.sodium,
      'potassium': instance.potassium,
      'cholesterol': instance.cholesterol,
      'saturated_fat': instance.saturatedFat,
      'unsaturated_fat': instance.unsaturatedFat,
      'trans_fat': instance.transFat,
      'vitamin_a': instance.vitaminA,
      'vitamin_c': instance.vitaminC,
      'calcium': instance.calcium,
      'iron': instance.iron,
      'serving_size': instance.servingSize,
      'serving_unit': instance.servingUnit,
    };
