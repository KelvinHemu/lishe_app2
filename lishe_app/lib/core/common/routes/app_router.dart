import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lishe_app/features/auth/views/complete_registration_page.dart';
import 'package:lishe_app/features/auth/views/verification_page.dart';
import 'package:lishe_app/features/meal_planner/views/edit_profile_page.dart';
import 'package:lishe_app/features/profile/views/profile_page.dart';
import 'package:lishe_app/features/profile/views/profile_setup_page.dart';
import 'package:lishe_app/features/setting/views/settings_page.dart';

import '../../../features/auth/views/login_page.dart';
import '../../../features/auth/views/register_page.dart';
import '../../../features/auth/views/splash_screen.dart';
import '../../../features/auth/views/welcome_page.dart';
import '../../../features/profile/views/home_page.dart';
import '../../../features/auth/views/auth_selection_page.dart';
import '../../../features/meal_planner/views/meal_planner.dart';
import '../../../features/onboarding/views/welcome_onboarding_page.dart';
import '../../../features/onboarding/views/goal_selection_page.dart';
import '../../../features/onboarding/views/activity_level_page.dart';
import '../../../features/onboarding/views/basic_info_page.dart';
import '../../../features/onboarding/views/dietary_preferences_page.dart';
import '../../../features/onboarding/views/budget_preference_page.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      // Splash screen
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Welcome page
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomePage(),
      ),

      // Login page
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // Register page
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),

      // Home page
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      // Verification page
      GoRoute(
        path: '/verification',
        name: 'verification',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return VerificationPage(
            username: extra?['username'],
            contact: extra?['contact'],
          );
        },
      ),

      // Complete registration page
      GoRoute(
        path: '/register/complete',
        name: 'completeRegister',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return CompleteRegistrationPage(
            username: extra?['username'],
            contact: extra?['contact'],
          );
        },
      ),

      // Auth selection page
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthSelectionPage(),
      ),

      // Profile Setup page
      GoRoute(
        path: '/profile-setup',
        name: 'profileSetup',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ProfileSetupPage(
            userId: extra?['userId'] ?? '',
            username: extra?['username'],
            currentStep: extra?['step'] ?? 0,
          );
        },
      ),

      // Meals page
      GoRoute(
        path: '/meals',
        name: 'meals',
        builder: (context, state) => const MealPlannerView(),
      ),

      // Profile page
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),

      // Edit Profile page
      GoRoute(
        path: '/profile/edit',
        name: 'editProfile',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return EditProfilePage(
            userId: extra?['userId'] ?? 'current_user',
            username: extra?['username'],
          );
        },
      ),

      // Settings page
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),

      // Onboarding welcome page
      GoRoute(
        path: '/onboarding/welcome',
        name: 'welcomeOnboarding',
        builder: (context, state) => const WelcomeOnboardingPage(),
      ),

      // Goal selection page
      GoRoute(
        path: '/onboarding/goals',
        name: 'goalSelection',
        builder: (context, state) => const GoalSelectionPage(),
      ),

      // Activity level selection page
      GoRoute(
        path: '/onboarding/activity',
        name: 'activityLevelStep',
        builder: (context, state) => const ActivityLevelPage(),
      ),

      // Basic info page
      GoRoute(
        path: '/onboarding/basic-info',
        name: 'basicInfoStep',
        builder: (context, state) => const BasicInfoPage(),
      ),

      // Dietary preferences page
      GoRoute(
        path: '/onboarding/dietary-preferences',
        name: 'dietaryPreferences',
        builder: (context, state) => const DietaryPreferencesPage(),
      ),

      // Budget preference page
      GoRoute(
        path: '/onboarding/budget-preference',
        name: 'budgetPreferenceStep',
        builder: (context, state) => const BudgetPreferencePage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Error: ${state.error?.toString() ?? "Page not found"}',
        ),
      ),
    ),
  );
}

// Scaffold with bottom navigation for the main app shell
class ScaffoldWithBottomNav extends StatelessWidget {
  final Widget child;

  const ScaffoldWithBottomNav({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/profile')) {
      return 1;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/home');
        break;
      case 1:
        GoRouter.of(context).go('/profile');
        break;
    }
  }
}
