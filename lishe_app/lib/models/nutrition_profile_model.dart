class NutritionProfileModel {
  // Physical attributes
  final double? height; // in cm
  final double? weight; // in kg
  final int? age;
  final String? gender;

  // Health goals
  final String? goal; // weight loss, maintenance, muscle gain
  final double? targetWeight;
  final String?
  activityLevel; // sedentary, light, moderate, active, very active

  // Dietary preferences
  final String? dietType; // omnivore, vegetarian, vegan, etc.
  final List<String>? allergies;
  final List<String>? preferredCuisines;

  // Health considerations
  final List<String>? healthConditions;

  NutritionProfileModel({
    this.height,
    this.weight,
    this.age,
    this.gender,
    this.goal,
    this.targetWeight,
    this.activityLevel,
    this.dietType,
    this.allergies,
    this.preferredCuisines,
    this.healthConditions,
  });

  // For when you integrate with the real API
  factory NutritionProfileModel.fromJson(Map<String, dynamic> json) {
    return NutritionProfileModel(
      height: json['height'],
      weight: json['weight'],
      age: json['age'],
      gender: json['gender'],
      goal: json['goal'],
      targetWeight: json['targetWeight'],
      activityLevel: json['activityLevel'],
      dietType: json['dietType'],
      allergies: List<String>.from(json['allergies'] ?? []),
      preferredCuisines: List<String>.from(json['preferredCuisines'] ?? []),
      healthConditions: List<String>.from(json['healthConditions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'age': age,
      'gender': gender,
      'goal': goal,
      'targetWeight': targetWeight,
      'activityLevel': activityLevel,
      'dietType': dietType,
      'allergies': allergies,
      'preferredCuisines': preferredCuisines,
      'healthConditions': healthConditions,
    };
  }
}
