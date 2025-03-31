import '../../../features/auth/models/user_model.dart';
import '../../../features/meal_planner/models/nutrition_profile_model.dart';

/// Abstract class defining API service interface
abstract class ApiService {
  Future<UserModel?> registerUser(
    String username,
    String email,
    String password,
  );
  Future<UserModel?> loginUser(String emailOrUsername, String password);
  Future<bool> updateUserProfile(String userId, NutritionProfileModel profile);
  Future<NutritionProfileModel?> getUserProfile(String userId);
}

/// Mock implementation that simulates server responses
class MockApiService implements ApiService {
  // Simulated user database
  final Map<String, UserModel> _users = {};
  final Map<String, NutritionProfileModel> _profiles = {};

  @override
  Future<UserModel?> registerUser(
    String username,
    String email,
    String password,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check if user already exists
    if (_users.values.any(
      (user) => user.email == email || user.username == username,
    )) {
      throw Exception('User already exists');
    }

    // Create new user
    final String userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    final user = UserModel(uid: userId, username: username, email: email);

    _users[userId] = user;
    return user;
  }

  @override
  Future<UserModel?> loginUser(String emailOrUsername, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    // Find user by email or username
    try {
      return _users.values.firstWhere(
        (user) =>
            user.email == emailOrUsername || user.username == emailOrUsername,
      );
    } catch (e) {
      throw Exception('Invalid credentials');
    }
  }

  @override
  Future<bool> updateUserProfile(
    String userId,
    NutritionProfileModel profile,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    if (!_users.containsKey(userId)) {
      throw Exception('User not found');
    }

    _profiles[userId] = profile;
    return true;
  }

  @override
  Future<NutritionProfileModel?> getUserProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 800));

    return _profiles[userId];
  }
}
