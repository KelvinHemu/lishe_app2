// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      image: json['image'] as String,
      location: json['location'] as String,
      age: (json['age'] as num).toInt(),
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      goals: json['goals'] as String,
      memberSince: json['memberSince'] as String,
      streak: (json['streak'] as num).toInt(),
      level: json['level'] as String,
      points: (json['points'] as num).toInt(),
      nextLevel: (json['nextLevel'] as num).toInt(),
      waterIntake: (json['waterIntake'] as num).toDouble(),
      calories: (json['calories'] as num).toInt(),
      nutritionScore: (json['nutritionScore'] as num).toInt(),
      carbsPercentage: (json['carbsPercentage'] as num).toDouble(),
      proteinPercentage: (json['proteinPercentage'] as num).toDouble(),
      fatsPercentage: (json['fatsPercentage'] as num).toDouble(),
      fiberIntake: (json['fiberIntake'] as num).toDouble(),
      fiberGoal: (json['fiberGoal'] as num).toDouble(),
      sugarIntake: (json['sugarIntake'] as num).toDouble(),
      sugarGoal: (json['sugarGoal'] as num).toDouble(),
      vitaminsPercentage: (json['vitaminsPercentage'] as num).toInt(),
      mealConsistencyPercentage:
          (json['mealConsistencyPercentage'] as num).toInt(),
      targetWeight: (json['targetWeight'] as num?)?.toDouble(),
      birthYear: (json['birthYear'] as num?)?.toInt(),
      gender: json['gender'] as String?,
      mealFrequency: json['mealFrequency'] as String?,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'image': instance.image,
      'location': instance.location,
      'age': instance.age,
      'height': instance.height,
      'weight': instance.weight,
      'goals': instance.goals,
      'memberSince': instance.memberSince,
      'streak': instance.streak,
      'level': instance.level,
      'points': instance.points,
      'nextLevel': instance.nextLevel,
      'waterIntake': instance.waterIntake,
      'calories': instance.calories,
      'nutritionScore': instance.nutritionScore,
      'carbsPercentage': instance.carbsPercentage,
      'proteinPercentage': instance.proteinPercentage,
      'fatsPercentage': instance.fatsPercentage,
      'fiberIntake': instance.fiberIntake,
      'fiberGoal': instance.fiberGoal,
      'sugarIntake': instance.sugarIntake,
      'sugarGoal': instance.sugarGoal,
      'vitaminsPercentage': instance.vitaminsPercentage,
      'mealConsistencyPercentage': instance.mealConsistencyPercentage,
      'targetWeight': instance.targetWeight,
      'birthYear': instance.birthYear,
      'gender': instance.gender,
      'mealFrequency': instance.mealFrequency,
    };
