import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class OnboardingCompletePage extends ConsumerStatefulWidget {
  const OnboardingCompletePage({super.key});

  @override
  ConsumerState<OnboardingCompletePage> createState() => _OnboardingCompletePageState();
}

class _OnboardingCompletePageState extends ConsumerState<OnboardingCompletePage> {
  Timer? _redirectTimer;
  
  @override
  void initState() {
    super.initState();
    
    // Redirect to home after 3 seconds
    _redirectTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }
  
  @override
  void dispose() {
    _redirectTimer?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success animation
                Lottie.asset(
                  'assets/animations/success.json',
                  width: 200,
                  height: 200,
                  repeat: false,
                ),
                
                const SizedBox(height: 32),
                
                // Success message
                Text(
                  "You're all set!",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 16),
                
                Text(
                  "Your healthy journey is about to begin. We've saved your preferences to customize your experience.",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 300.ms)
                .slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 40),
                
                // Redirect message
                Text(
                  "Redirecting to your dashboard...",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 600.ms),
                
                const SizedBox(height: 24),
                
                // Loading indicator
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.green.shade600,
                  ),
                  strokeWidth: 3,
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 800.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 