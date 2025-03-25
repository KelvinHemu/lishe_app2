import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile_model.dart';

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  UserProfileNotifier() : super(const AsyncValue.loading()) {
    // We start with loading state
  }

  Future<void> loadUserProfile(String userId) async {
    state = const AsyncValue.loading();

    try {
      // In a real app, fetch from API
      // For demo, we'll simulate a delay
      await Future.delayed(const Duration(seconds: 1));

      // Create a mock profile
      final profile = UserProfile(
        height: 175,
        weight: 70,
        birthYear: 1990,
        age: DateTime.now().year - 1990,
        gender: "Male",
        mealFrequency: "3 meals per day",
        goal: "Maintain Weight",
        targetWeight: 70,
        activityLevel:
            "Moderately Active (moderate exercise/sports 3-5 days/week)",
        dietType: "Everything (no restrictions)",
        allergies: ["Nuts"],
        preferredLocalFoods: ["Ugali", "Rice", "Beans", "Fish"],
        healthConditions: ["None"],
      );

      state = AsyncValue.data(profile);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      // In a real app, send to API
      await Future.delayed(const Duration(seconds: 1));

      // Update state with new profile
      state = AsyncValue.data(profile);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
      return UserProfileNotifier();
    });
