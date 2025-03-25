import 'package:lishe_app/models/nutrition_profile_model.dart';
import 'package:lishe_app/models/user_model.dart';
import 'package:lishe_app/services/api_service.dart';

class MockApiService implements ApiService {
  final Map<String, UserModel> _users = {};
  final Map<String, NutritionProfileModel> _profiles = {};

  

  @override
  Future<UserModel?> loginUser(String emailOrUsername, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return _users.values.firstWhere(
      (user) => user.phoneNumber == emailOrUsername || user.username == emailOrUsername,
      orElse: () => throw Exception('Invalid credentials'),
    );
  }

  @override
  Future<bool> updateUserProfile(String userId, NutritionProfileModel profile) async {
    await Future.delayed(const Duration(seconds: 1));
    _profiles[userId] = profile;
    return true;
  }

  @override
  Future<NutritionProfileModel?> getUserProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _profiles[userId];
  }

  @override
  Future<bool> initiateRegistration(String username, String phoneNumber) async => throw UnimplementedError();
  @override
  Future<String> verifyOtp(String phoneNumber, String otp) async => throw UnimplementedError();
  @override
  Future<UserModel?> createPassword(String token, String password) async => throw UnimplementedError();
}
