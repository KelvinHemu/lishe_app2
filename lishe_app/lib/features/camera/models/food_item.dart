// ignore_for_file: invalid_annotation_target

class FoodItem {
  final String foodId;
  final String foodName;
  final String brandName;
  final String foodType;
  final String foodUrl;
  final String? foodImageUrl;
  final double? calories;
  final double? protein;
  final double? fat;
  final double? carbs;
  final double? fiber;
  final double? sugar;
  final double? sodium;
  final double? potassium;
  final double? cholesterol;
  final double? saturatedFat;
  final double? unsaturatedFat;
  final double? transFat;
  final double? vitaminA;
  final double? vitaminC;
  final double? calcium;
  final double? iron;
  final double? servingSize;
  final String servingUnit;

  const FoodItem({
    required this.foodId,
    required this.foodName,
    required this.brandName,
    required this.foodType,
    required this.foodUrl,
    this.foodImageUrl,
    this.calories,
    this.protein,
    this.fat,
    this.carbs,
    this.fiber,
    this.sugar,
    this.sodium,
    this.potassium,
    this.cholesterol,
    this.saturatedFat,
    this.unsaturatedFat,
    this.transFat,
    this.vitaminA,
    this.vitaminC,
    this.calcium,
    this.iron,
    this.servingSize,
    required this.servingUnit,
  });

  // Create a copy of this FoodItem with the given values updated
  FoodItem copyWith({
    String? foodId,
    String? foodName,
    String? brandName,
    String? foodType,
    String? foodUrl,
    String? foodImageUrl,
    double? calories,
    double? protein,
    double? fat,
    double? carbs,
    double? fiber,
    double? sugar,
    double? sodium,
    double? potassium,
    double? cholesterol,
    double? saturatedFat,
    double? unsaturatedFat,
    double? transFat,
    double? vitaminA,
    double? vitaminC,
    double? calcium,
    double? iron,
    double? servingSize,
    String? servingUnit,
  }) {
    return FoodItem(
      foodId: foodId ?? this.foodId,
      foodName: foodName ?? this.foodName,
      brandName: brandName ?? this.brandName,
      foodType: foodType ?? this.foodType,
      foodUrl: foodUrl ?? this.foodUrl,
      foodImageUrl: foodImageUrl ?? this.foodImageUrl,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbs: carbs ?? this.carbs,
      fiber: fiber ?? this.fiber,
      sugar: sugar ?? this.sugar,
      sodium: sodium ?? this.sodium,
      potassium: potassium ?? this.potassium,
      cholesterol: cholesterol ?? this.cholesterol,
      saturatedFat: saturatedFat ?? this.saturatedFat,
      unsaturatedFat: unsaturatedFat ?? this.unsaturatedFat,
      transFat: transFat ?? this.transFat,
      vitaminA: vitaminA ?? this.vitaminA,
      vitaminC: vitaminC ?? this.vitaminC,
      calcium: calcium ?? this.calcium,
      iron: iron ?? this.iron,
      servingSize: servingSize ?? this.servingSize,
      servingUnit: servingUnit ?? this.servingUnit,
    );
  }

  // Helper to extract first image URL
  static String? extractFirstImageUrl(dynamic images) {
    if (images == null) return null;
    if (images is! Map<String, dynamic>) return null;

    final foodImages = images['food_image'];
    if (foodImages == null) return null;

    if (foodImages is List && foodImages.isNotEmpty) {
      final firstImage = foodImages.first;
      if (firstImage is Map && firstImage['image_url'] != null) {
        final imageUrl = firstImage['image_url'].toString();
        print('Found foodimagedb URL: $imageUrl');
        return imageUrl;
      }
    }

    return null;
  }

  // Get the image URL, falling back to the food URL if needed
  String? getImageUrl() {
    // First try the foodimagedb URL
    if (foodImageUrl != null) {
      return foodImageUrl;
    }

    // If no foodimagedb URL, use the FatSecret food URL
    if (foodUrl.isNotEmpty) {
      print('Using FatSecret food URL as fallback: $foodUrl');
      return foodUrl;
    }

    return null;
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    // Helper to safely convert dynamic to double, handling int and null
    double? toDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) {
        try {
          return double.parse(value);
        } catch (e) {
          print('Error parsing "$value" to double: $e');
          return null;
        }
      }
      print('Unexpected type for value "$value": ${value.runtimeType}');
      return null;
    }

    // Helper to safely convert dynamic to String
    String toString(dynamic value, {String defaultValue = ''}) {
      if (value == null) return defaultValue;
      if (value is String) return value;
      return value.toString();
    }

    // Create a safe copy of the input JSON
    final safeJson = Map<String, dynamic>.from(json);

    // Log the input JSON for debugging
    print('Creating FoodItem from JSON: $safeJson');
    print('Food URL in JSON: ${safeJson['food_url']}');
    print('Food Images in JSON: ${safeJson['food_images']}');

    return FoodItem(
      foodId: toString(safeJson['food_id'], defaultValue: '0'),
      foodName: toString(safeJson['food_name'], defaultValue: 'Unknown Food'),
      brandName: toString(safeJson['brand_name']),
      foodType: toString(safeJson['food_type'], defaultValue: 'Generic'),
      foodUrl: toString(safeJson['food_url']),
      foodImageUrl: extractFirstImageUrl(safeJson['food_images']),
      calories: toDouble(safeJson['calories']),
      protein: toDouble(safeJson['protein']),
      fat: toDouble(safeJson['fat']),
      carbs: toDouble(safeJson['carbs']),
      fiber: toDouble(safeJson['fiber']),
      sugar: toDouble(safeJson['sugar']),
      sodium: toDouble(safeJson['sodium']),
      potassium: toDouble(safeJson['potassium']),
      cholesterol: toDouble(safeJson['cholesterol']),
      saturatedFat: toDouble(safeJson['saturated_fat']),
      unsaturatedFat: toDouble(safeJson['unsaturated_fat']),
      transFat: toDouble(safeJson['trans_fat']),
      vitaminA: toDouble(safeJson['vitamin_a']),
      vitaminC: toDouble(safeJson['vitamin_c']),
      calcium: toDouble(safeJson['calcium']),
      iron: toDouble(safeJson['iron']),
      servingSize: toDouble(safeJson['serving_size']),
      servingUnit: toString(safeJson['serving_unit']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food_id': foodId,
      'food_name': foodName,
      'brand_name': brandName,
      'food_type': foodType,
      'food_url': foodUrl,
      'food_image_url': foodImageUrl,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'fiber': fiber,
      'sugar': sugar,
      'sodium': sodium,
      'potassium': potassium,
      'cholesterol': cholesterol,
      'saturated_fat': saturatedFat,
      'unsaturated_fat': unsaturatedFat,
      'trans_fat': transFat,
      'vitamin_a': vitaminA,
      'vitamin_c': vitaminC,
      'calcium': calcium,
      'iron': iron,
      'serving_size': servingSize,
      'serving_unit': servingUnit,
    };
  }

  @override
  String toString() {
    return 'FoodItem(foodName: $foodName, brandName: $brandName, calories: $calories)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FoodItem &&
        other.foodId == foodId &&
        other.foodName == foodName &&
        other.brandName == brandName;
  }

  @override
  int get hashCode => Object.hash(foodId, foodName, brandName);
}
