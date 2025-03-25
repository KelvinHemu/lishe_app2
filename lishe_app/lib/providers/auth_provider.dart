import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/service_locator.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  AuthState({required this.status, this.user, this.errorMessage});

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(status: AuthStatus.initial));

  Future<void> login(String emailOrUsername, String password) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final user = await serviceLocator.apiService.loginUser(
        emailOrUsername,
        password,
      );

      if (user != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          errorMessage: null,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Invalid credentials',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> initiateRegistration(String username, String phoneNumber) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final success = await serviceLocator.apiService.initiateRegistration(
        username,
        phoneNumber,
      );

      if (success) {
        state = state.copyWith(status: AuthStatus.initial, errorMessage: null);
        return true;
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Failed to send OTP',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final token = await serviceLocator.apiService.verifyOtp(phoneNumber, otp);

      if (token.isNotEmpty) {
        state = state.copyWith(status: AuthStatus.initial, errorMessage: null);
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Invalid OTP',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> createPassword(String token, String password) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final user = await serviceLocator.apiService.createPassword(
        token,
        password,
      );

      if (user != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          errorMessage: null,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Failed to create password',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void logout() {
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
