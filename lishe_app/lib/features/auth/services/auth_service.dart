import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/initial_sign_up_dto.dart';

class AuthService {
  final Dio _dio;
  String? _authToken;

  AuthService({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl =
        dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api';
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  // Set the auth token for subsequent requests
  void setAuthToken(String token) {
    _authToken = token;
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Clear the auth token
  void clearAuthToken() {
    _authToken = null;
    _dio.options.headers.remove('Authorization');
  }

  // Initial signup verification
  Future<InitialSignUpDTO> verifyUser(String username) async {
    try {
      final response = await _dio.post(
        '/auth/signup/initial',
        data: {'username': username},
      );

      if (response.statusCode == 200) {
        return InitialSignUpDTO.fromJson(response.data);
      } else {
        throw Exception('Failed to verify user: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        throw Exception('Server error during verification');
      }
      throw Exception('Failed to verify user: ${e.message}');
    }
  }
}
