import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class WelcomeOnboardingPage extends StatelessWidget {
  const WelcomeOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    const primaryColor = Color(0xFF4CAF50);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.green.shade50,
                    Colors.white,
                  ],
                ),
              ),
            ),

            // Background pattern - subtle food icons
            ...List.generate(20, (index) {
              final random = math.Random(index);
              return Positioned(
                top: random.nextDouble() * size.height,
                left: random.nextDouble() * size.width,
                child: Opacity(
                  opacity: 0.08,
                  child: Transform.rotate(
                    angle: random.nextDouble() * math.pi * 2,
                    child: Icon(
                      [
                        Icons.restaurant,
                        Icons.local_dining,
                        Icons.egg_alt,
                        Icons.restaurant_menu,
                        Icons.lunch_dining,
                        Icons.local_pizza
                      ][random.nextInt(6)],
                      size: random.nextDouble() * 30 + 10,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
              );
            }),

            // Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 1),

                  // App logo/icon
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 80,
                      ),
                    ),
                  ).animate().fadeIn(duration: 800.ms, delay: 300.ms).scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1, 1),
                        duration: 1200.ms,
                        curve: Curves.elasticOut,
                      ),

                  const SizedBox(height: 40),

                  // Title
                  Text(
                    'Welcome to Lishe',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 800.ms, delay: 600.ms).slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 800.ms,
                        curve: Curves.easeOutQuad,
                      ),

                  const SizedBox(height: 16),

                  // Subtitle
                  Text(
                    'Your personalized nutrition companion',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 800.ms, delay: 800.ms).slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 800.ms,
                        curve: Curves.easeOutQuad,
                      ),

                  const Spacer(flex: 1),

                  // Features list
                  Column(
                    children: [
                      _buildFeatureItem(
                        icon: Icons.restaurant_menu,
                        text: 'Personalized meal plans',
                        delay: 1000,
                      ),
                      const SizedBox(height: 20),
                      _buildFeatureItem(
                        icon: Icons.monitor_weight_outlined,
                        text: 'Track your progress easily',
                        delay: 1200,
                      ),
                      const SizedBox(height: 20),
                      _buildFeatureItem(
                        icon: Icons.health_and_safety,
                        text: 'Expert nutrition advice',
                        delay: 1400,
                      ),
                    ],
                  ),

                  const Spacer(flex: 1),

                  // Page indicator
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPageIndicator(isActive: true),
                        _buildPageIndicator(isActive: false),
                        _buildPageIndicator(isActive: false),
                        _buildPageIndicator(isActive: false),
                      ],
                    ),
                  ).animate().fadeIn(duration: 800.ms, delay: 1500.ms),

                  const SizedBox(height: 32),

                  // Get Started Button
                  ElevatedButton(
                    onPressed: () {
                      // Add haptic feedback
                      HapticFeedback.mediumImpact();
                      // Navigate to the goal selection page
                      context.pushNamed('goalSelection');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 1600.ms)
                      .slideY(begin: 0.2, end: 0, duration: 800.ms),

                  const SizedBox(height: 16),

                  // Skip button
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.go('/home');
                      },
                      child: Text(
                        'Skip for now',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 800.ms, delay: 1700.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF4CAF50) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String text,
    required int delay,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.green.shade700,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: delay.ms)
        .slideX(begin: 0.2, end: 0, duration: 600.ms);
  }
}
