import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Helper class for navigating within the app
class AppNavigator {
  /// Navigate to a named route
  static void navigateTo(
    BuildContext context,
    String routeName, {
    Object? extra,
  }) {
    GoRouter.of(context).pushNamed(routeName, extra: extra);
  }

  /// Navigate to a named route and remove all previous routes
  static void navigateToAndRemoveAll(
    BuildContext context,
    String routeName, {
    Object? extra,
  }) {
    GoRouter.of(context).goNamed(routeName, extra: extra);
  }

  /// Go back to previous screen
  static void goBack(BuildContext context) {
    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    }
  }

  /// Navigate and replace current route
  static void navigateAndReplace(
    BuildContext context,
    String routeName, {
    Object? extra,
  }) {
    GoRouter.of(context).replaceNamed(routeName, extra: extra);
  }

  /// Navigate to home
  static void navigateToHome(BuildContext context) {
    context.go('/home');
  }

  /// Navigate to login
  static void navigateToLogin(BuildContext context) {
    context.go('/login');
  }

  /// Navigate to profile
  static void navigateToProfile(BuildContext context) {
    context.go('/profile');
  }

  /// Navigate to progress tracker
  static void navigateToProgressTracker(BuildContext context) {
    context.go('/progress-tracker');
  }

  /// Navigate to meal planner
  static void navigateToMealPlanner(BuildContext context) {
    context.go('/meals');
  }

  /// Navigate to settings
  static void navigateToSettings(BuildContext context) {
    context.go('/settings');
  }
} 