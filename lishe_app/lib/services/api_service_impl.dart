import 'dart:convert';
import 'package:lishe_app/services/api_service.dart';
import 'http_helper.dart';
import 'api_endpoints.dart';
import '../models/user_model.dart';
import '../models/nutrition_profile_model.dart';

class ApiServiceImpl implements ApiService {
  @override
  Future<bool> initiateRegistration(String username, String phoneNumber) async {
    final response = await makePostRequest(ApiEndpoints.initiateRegistration, {
      'username': username,
      'phoneNumber': phoneNumber,
    });

    if (response.statusCode == 200) return true;
    throw Exception('Registration failed: ${response.body}');
  }

  @override
  Future<String> verifyOtp(String phoneNumber, String otp) async {
    final response = await makePostRequest(ApiEndpoints.verifyOtp, {
      'phoneNumber': phoneNumber,
      'otp': otp,
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    }
    throw Exception('OTP verification failed: ${response.body}');
  }

  @override
  Future<UserModel?> createPassword(String token, String password) async {
    final response = await makePostRequest(
      ApiEndpoints.createPassword,
      {'password': password},
      {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return UserModel(
        uid: data['id'],
        username: data['username'],
        phoneNumber: data['phoneNumber'],
      );
    }
    throw Exception('Password creation failed: ${response.body}');
  }

  @override
  Future<UserModel?> loginUser(String emailOrUsername, String password) async {
    final response = await makePostRequest(ApiEndpoints.login, {
      'emailOrUsername': emailOrUsername,
      'password': password,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel(
        uid: data['id'],
        username: data['username'],
        phoneNumber: data['phoneNumber'],
      );
    }
    throw Exception('Login failed: ${response.body}');
  }

  @override
  Future<bool> updateUserProfile(
    String userId,
    NutritionProfileModel profile,
  ) async {
    final response = await makePutRequest(
      ApiEndpoints.userProfile(userId),
      profile.toJson(),
    );

    if (response.statusCode == 200) return true;
    throw Exception('Profile update failed: ${response.body}');
  }

  @override
  Future<NutritionProfileModel?> getUserProfile(String userId) async {
    final response = await makeGetRequest(ApiEndpoints.userProfile(userId));

    if (response.statusCode == 200) {
      return NutritionProfileModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Profile fetch failed: ${response.body}');
  }
}
