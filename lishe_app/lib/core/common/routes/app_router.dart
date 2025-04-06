import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/views/auth_selection_page.dart';
import '../../../features/auth/views/complete_registration_page.dart';
import '../../../features/auth/views/login_page.dart';
import '../../../features/auth/views/register_page.dart';
import '../../../features/auth/views/splash_screen.dart';
import '../../../features/auth/views/verification_page.dart';
import '../../../features/auth/views/welcome_page.dart';
import '../../../features/camera/views/camera_view.dart';
import '../../../features/home/views/home_page.dart';
import '../../../features/meal_planner/views/edit_profile_page.dart';
import '../../../features/meal_planner/views/meal_planner.dart';
import '../../../features/onboarding/views/activity_level_page.dart';
import '../../../features/onboarding/views/age_page.dart';
import '../../../features/onboarding/views/basic_info_page.dart';
import '../../../features/onboarding/views/budget_preference_page.dart';
import '../../../features/onboarding/views/dietary_preferences_page.dart';
import '../../../features/onboarding/views/goal_selection_page.dart';
import '../../../features/onboarding/views/welcome_onboarding_page.dart';
import '../../../features/profile/views/profile_page.dart';
import '../../../features/profile/views/profile_setup_page.dart';
import '../../../features/progress_tracker/views/progress_tracker_view.dart';
import '../../../features/setting/views/settings_page.dart';
import '../providers/navigation_provider.dart';
import '../widgets/bottom_nav_bar.dart';

// Create a global key that can be accessed throughout the app
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  // Use a static instance of NavigationProvider to manage navigation state
  static final NavigationProvider navigationProvider = NavigationProvider();
  
  // Define branch navigator keys for each tab
  static final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'homeNav');
  static final GlobalKey<NavigatorState> _progressTrackerNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'progressNav');
  static final GlobalKey<NavigatorState> _mealsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'mealsNav');
  static final GlobalKey<NavigatorState> _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profileNav');

  // Create the router instance
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    
    // Define route observers to listen to route changes
    observers: [
      GoRouterObserver(),
    ],
    
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

      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
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
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthSelectionPage(),
      ),

      // Onboarding routes
      GoRoute(
        path: '/onboarding/welcome',
        name: 'onboardingWelcome',
        builder: (context, state) => const WelcomeOnboardingPage(),
      ),
      GoRoute(
        path: '/onboarding/goals',
        name: 'goalSelection',
        builder: (context, state) => const GoalSelectionPage(),
      ),
      GoRoute(
        path: '/onboarding/basic-info',
        name: 'basicInfoStep',
        builder: (context, state) => const BasicInfoPage(),
      ),
      GoRoute(
        path: '/onboarding/activity-level',
        name: 'activityLevelStep',
        builder: (context, state) => const ActivityLevelPage(),
      ),
      GoRoute(
        path: '/onboarding/age',
        name: 'ageStep',
        builder: (context, state) => const AgePage(),
      ),
      GoRoute(
        path: '/onboarding/dietary-preferences',
        name: 'dietaryPreferencesStep',
        builder: (context, state) => const DietaryPreferencesPage(),
      ),
      GoRoute(
        path: '/onboarding/budget-preference',
        name: 'budgetPreferenceStep',
        builder: (context, state) => const BudgetPreferencePage(),
      ),
      
      // Settings page (outside the shell)
      GoRoute(
        path: '/settings',
        name: 'settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsPage(),
      ),
      
      // Camera route (outside the shell)
      GoRoute(
        path: '/camera',
        name: 'camera',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CameraView(),
      ),
      
      // Main app shell with stateful navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Home branch
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomePage(),
                // Add any nested home routes here
              ),
            ],
          ),
          
          // Progress tracker branch
          StatefulShellBranch(
            navigatorKey: _progressTrackerNavigatorKey,
            routes: [
              GoRoute(
                path: '/progress-tracker',
                name: 'progress_tracker',
                builder: (context, state) => const ProgressTrackerView(),
                // Add any nested progress routes here
              ),
            ],
          ),
          
          // Meals branch
          StatefulShellBranch(
            navigatorKey: _mealsNavigatorKey,
            routes: [
      GoRoute(
        path: '/meals',
        name: 'meals',
        builder: (context, state) => const MealPlannerView(),
                // Add any nested meal routes here
              ),
            ],
      ),

          // Profile branch
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
                routes: [
      GoRoute(
                    path: 'edit',
        name: 'editProfile',
                    parentNavigatorKey: _profileNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return EditProfilePage(
            userId: extra?['userId'] ?? 'current_user',
            username: extra?['username'],
          );
        },
      ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Profile setup route
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
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              'Route not found: ${state.matchedLocation}', 
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
    
    // Redirect logic
    redirect: (context, state) {
      final location = state.matchedLocation;
      
      // Don't redirect for authentication routes
      if (location == '/' || 
          location.startsWith('/welcome') || 
          location.startsWith('/login') || 
          location.startsWith('/register') || 
          location.startsWith('/auth') || 
          location.startsWith('/verification') ||
          location.startsWith('/profile-setup')) {
        return null;
      }
      
      // Handle routing for search (redirect to progress tracker)
      if (location == '/search') {
        return '/progress-tracker';
      }
      
      return null;
    },
  );
}

// Observer to watch route changes
class GoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Update navigation state if needed
    _updateNavigationIndex(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      _updateNavigationIndex(newRoute);
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
  
  void _updateNavigationIndex(Route<dynamic> route) {
    final path = _getRoutePath(route);
    if (path != null) {
      if (path.startsWith('/home')) {
        AppRouter.navigationProvider.setIndex(0);
      } else if (path.startsWith('/progress-tracker')) {
        AppRouter.navigationProvider.setIndex(1);
      } else if (path.startsWith('/camera')) {
        AppRouter.navigationProvider.setIndex(2);
      } else if (path.startsWith('/meals')) {
        AppRouter.navigationProvider.setIndex(3);
      } else if (path.startsWith('/profile')) {
        AppRouter.navigationProvider.setIndex(4);
      }
    }
  }
  
  String? _getRoutePath(Route<dynamic> route) {
    if (route.settings.name != null && route.settings.name!.startsWith('/')) {
      return route.settings.name;
    }
    return null;
  }
}

// Custom scaffold with the imported bottom navigation bar
class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key, 
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavBar(
        currentIndex: navigationShell.currentIndex,
        // Use a simple anonymous function to handle tab taps 
        onTabTapped: (index) {
          // Special handling for camera tab (index 2)
          if (index == 2) {
            context.go('/camera');
            return;
          }
          
          // When navigating to a new tab, switch to that tab's branch
          navigationShell.goBranch(
            // Adjust for camera tab being in the middle
            index > 2 ? index - 1 : index,
            // Use initialLocation to reset the navigation stack if on same tab
            initialLocation: index == navigationShell.currentIndex
          );
          // Update the navigation provider state
          AppRouter.navigationProvider.setIndex(index);
        },
      ),
    );
  }
} 