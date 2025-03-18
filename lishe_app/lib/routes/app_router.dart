import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lishe_app/views/screens/auth/complete_registration_page.dart';
import 'package:lishe_app/views/screens/auth/verification_page.dart';
import 'package:lishe_app/views/screens/profile_setup_page.dart';

import '../views/screens/auth/login_page.dart';
import '../views/screens/auth/register_page.dart';
import '../views/screens/auth/splash_screen.dart';
import '../views/screens/auth/welcome_page.dart';
import '../views/screens/home_page.dart';
import '../views/screens/auth/auth_selection_page.dart';

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
    ],

    errorBuilder:
        (context, state) => Scaffold(
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
