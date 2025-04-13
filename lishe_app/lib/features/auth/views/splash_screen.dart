import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();

    // Navigate to appropriate screen after the animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Delay navigation by a brief moment for better user experience
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _checkFirstLaunch();
          }
        });
      }
    });
  }

  Future<void> _checkFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool hasCompletedOnboarding =
          prefs.getBool('onboarding_completed') ?? false;
      final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

      if (!hasCompletedOnboarding) {
        // First time user - show onboarding
        context.pushNamed('welcomeOnboarding');
      } else if (!isLoggedIn) {
        // Onboarding completed but not logged in - show auth
        context.go('/auth');
      } else {
        // Logged in user - go to home
        context.go('/home');
      }
    } catch (e) {
      // Fallback in case of error
      context.go('/welcome');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo image
                Image.asset('assets/images/logo.png', width: 150, height: 150),
                const SizedBox(height: 20),
                const Text(
                  'Lishe App',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your nutrition companion',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
