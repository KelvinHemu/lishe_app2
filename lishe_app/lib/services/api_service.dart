import '../models/user_model.dart';
import '../models/nutrition_profile_model.dart';

/// Abstract class defining API service interface
abstract class ApiService {
  
  Future<UserModel?> loginUser(String emailOrUsername, String password);
  Future<bool> updateUserProfile(String userId, NutritionProfileModel profile);
  Future<NutritionProfileModel?> getUserProfile(String userId);
  Future<bool> initiateRegistration(String username, String phoneNumber);
  Future<String> verifyOtp(String phoneNumber, String otp);
  Future<UserModel?> createPassword(String token, String password);
}


   