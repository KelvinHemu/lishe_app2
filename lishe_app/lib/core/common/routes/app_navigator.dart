import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../features/camera/views/camera_view.dart';

class AppNavigator {
  // Navigate to a named route
  static void navigateTo(
    BuildContext context,
    String routeName, {
    Object? extra,
  }) {
    GoRouter.of(context).pushNamed(routeName, extra: extra);
  }

  // Navigate to a named route and remove all previous routes
  static void navigateToAndRemoveAll(
    BuildContext context,
    String routeName, {
    Object? extra,
  }) {
    GoRouter.of(context).goNamed(routeName, extra: extra);
  }

  // Go back to previous screen
  static void goBack(BuildContext context) {
    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    }
  }

  // Navigate and replace current route
  static void navigateAndReplace(
    BuildContext context,
    String routeName, {
    Object? extra,
  }) {
    GoRouter.of(context).replaceNamed(routeName, extra: extra);
  }

  // Navigate to home
  static void navigateToHome(BuildContext context) {
    GoRouter.of(context).goNamed('home');
  }

  // Navigate to login
  static void navigateToLogin(BuildContext context) {
    GoRouter.of(context).goNamed('login');
  }

  // Navigate to profile
  static void navigateToProfile(BuildContext context) {
    GoRouter.of(context).goNamed('profile');
  }

  // Navigate to meal planner
  static void navigateToMealPlanner(BuildContext context) {
    GoRouter.of(context).goNamed('meal_planner');
  }

  // Add this new method to your AppNavigator class
  static void navigateToCamera(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const CameraView()));
  }
}
