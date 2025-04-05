class UserProfile {
  // Basic info
  final double? height;
  final double? weight;
  final int? birthYear;
  final int? age;
  final String? gender;
  final String? mealFrequency;

  // Health goals
  final String? goal;
  final double? targetWeight;
  final String? activityLevel;

  // Dietary preferences
  final String? dietType;
  final List<String> allergies;
  final List<String> preferredLocalFoods;

  // Health info
  final List<String> healthConditions;

  UserProfile({
    this.height,
    this.weight,
    this.birthYear,
    this.age,
    this.gender,
    this.mealFrequency,
    this.goal,
    this.targetWeight,
    this.activityLevel,
    this.dietType,
    this.allergies = const [],
    this.preferredLocalFoods = const [],
    this.healthConditions = const [],
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      height: json['height'],
      weight: json['weight'],
      birthYear: json['birthYear'],
      age: json['age'],
      gender: json['gender'],
      mealFrequency: json['mealFrequency'],
      goal: json['goal'],
      targetWeight: json['targetWeight'],
      activityLevel: json['activityLevel'],
      dietType: json['dietType'],
      allergies: List<String>.from(json['allergies'] ?? []),
      preferredLocalFoods: List<String>.from(json['preferredLocalFoods'] ?? []),
      healthConditions: List<String>.from(json['healthConditions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'birthYear': birthYear,
      'age': age,
      'gender': gender,
      'mealFrequency': mealFrequency,
      'goal': goal,
      'targetWeight': targetWeight,
      'activityLevel': activityLevel,
      'dietType': dietType,
      'allergies': allergies,
      'preferredLocalFoods': preferredLocalFoods,
      'healthConditions': healthConditions,
    };
  }

  UserProfile copyWith({
    double? height,
    double? weight,
    int? birthYear,
    int? age,
    String? gender,
    String? mealFrequency,
    String? goal,
    double? targetWeight,
    String? activityLevel,
    String? dietType,
    List<String>? allergies,
    List<String>? preferredLocalFoods,
    List<String>? healthConditions,
  }) {
    return UserProfile(
      height: height ?? this.height,
      weight: weight ?? this.weight,
      birthYear: birthYear ?? this.birthYear,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      mealFrequency: mealFrequency ?? this.mealFrequency,
      goal: goal ?? this.goal,
      targetWeight: targetWeight ?? this.targetWeight,
      activityLevel: activityLevel ?? this.activityLevel,
      dietType: dietType ?? this.dietType,
      allergies: allergies ?? this.allergies,
      preferredLocalFoods: preferredLocalFoods ?? this.preferredLocalFoods,
      healthConditions: healthConditions ?? this.healthConditions,
    );
  }
}
