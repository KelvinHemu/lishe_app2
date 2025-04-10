import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile_model.dart';

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  return UserProfileNotifier();
});

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  UserProfileNotifier() : super(const AsyncValue.loading()) {
    // Load initial data
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      // TODO: Replace with actual API call
      // For now, using mock data
      const mockProfile = UserProfile(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        image: 'https://xsgames.co/randomusers/assets/avatars/male/1.jpg',
        location: 'New York',
        age: 30,
        height: 175,
        weight: 70,
        goals: 'Weight Loss',
        memberSince: '2024-01-01',
        streak: 7,
        level: 'Intermediate',
        points: 1500,
        nextLevel: 2000,
        waterIntake: 2.5,
        calories: 1800,
        nutritionScore: 85,
        carbsPercentage: 40,
        proteinPercentage: 30,
        fatsPercentage: 30,
        fiberIntake: 25,
        fiberGoal: 30,
        sugarIntake: 20,
        sugarGoal: 25,
        vitaminsPercentage: 90,
        mealConsistencyPercentage: 95,
        // New fields with default values
        targetWeight: 65,
        birthYear: 1994,
        gender: 'Male',
        mealFrequency: '3 meals per day',
      );

      state = const AsyncValue.data(mockProfile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateUserProfile(UserProfile updatedProfile) async {
    try {
      // TODO: Replace with actual API call
      state = AsyncValue.data(updatedProfile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateWaterIntake(double amount) async {
    if (state.value == null) return;

    try {
      final updatedProfile = state.value!.copyWith(
        waterIntake: amount,
      );
      state = AsyncValue.data(updatedProfile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateCalories(int calories) async {
    if (state.value == null) return;

    try {
      final updatedProfile = state.value!.copyWith(
        calories: calories,
      );
      state = AsyncValue.data(updatedProfile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
