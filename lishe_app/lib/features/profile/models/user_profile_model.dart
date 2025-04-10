import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String name,
    required String email,
    required String image,
    required String location,
    required int age,
    required double height,
    required double weight,
    required String goals,
    required String memberSince,
    required int streak,
    required String level,
    required int points,
    required int nextLevel,
    required double waterIntake,
    required int calories,
    required int nutritionScore,
    required double carbsPercentage,
    required double proteinPercentage,
    required double fatsPercentage,
    required double fiberIntake,
    required double fiberGoal,
    required double sugarIntake,
    required double sugarGoal,
    required int vitaminsPercentage,
    required int mealConsistencyPercentage,
    double? targetWeight,
    int? birthYear,
    String? gender,
    String? mealFrequency,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
