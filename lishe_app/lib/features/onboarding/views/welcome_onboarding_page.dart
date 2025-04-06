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
            
            // Background pattern
            ...List.generate(20, (index) {
              final random = math.Random(index);
              return Positioned(
                top: random.nextDouble() * size.height,
                left: random.nextDouble() * size.width,
                child: Opacity(
                  opacity: 0.1,
                  child: Transform.rotate(
                    angle: random.nextDouble() * math.pi * 2,
                    child: Icon(
                      [Icons.restaurant, Icons.local_dining, Icons.egg_alt, 
                       Icons.restaurant_menu, Icons.lunch_dining, Icons.local_pizza]
                          [random.nextInt(6)],
                      size: random.nextDouble() * 30 + 10,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
              );
            }),
            
            // Decorative food icons
            Positioned(
              top: size.height * 0.1,
              left: 20,
              child: _buildFoodIcon(Icons.lunch_dining, Colors.orange.shade300, 0.9),
            ),
            
            Positioned(
              top: size.height * 0.25,
              right: 30,
              child: _buildFoodIcon(Icons.local_pizza, Colors.red.shade300, 1.2),
            ),
            
            Positioned(
              bottom: size.height * 0.3,
              left: 40,
              child: _buildFoodIcon(Icons.local_dining, Colors.green.shade300, 1.1),
            ),
            
            Positioned(
              bottom: size.height * 0.15,
              right: 50,
              child: _buildFoodIcon(Icons.egg_alt, Colors.amber.shade300, 0.8),
            ),
            
            // Confetti overlay at the top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: size.height * 0.4,
              child: IgnorePointer(
                child: _buildConfetti(),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 1),
                  
                  // Title
                  Text(
                    'Welcome to Lishe!',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 300.ms)
                  .slideY(begin: 0.3, end: 0, duration: 800.ms, curve: Curves.easeOutQuad),
                  
                  const SizedBox(height: 16),
                  
                  // Subtitle
                  Text(
                    'Let\'s personalize your healthy journey 🍽️',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 600.ms)
                  .slideY(begin: 0.3, end: 0, duration: 800.ms, curve: Curves.easeOutQuad),
                  
                  const Spacer(flex: 1),
                  
                  // Animation or illustration
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 180,
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 1000.ms, delay: 900.ms)
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 1200.ms, curve: Curves.elasticOut),
                  
                  const Spacer(flex: 2),
                  
                  // Features list
                  Column(
                    children: [
                      _buildFeatureItem(
                        icon: Icons.restaurant_menu, 
                        text: 'Personalized meal plans',
                        delay: 1100,
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureItem(
                        icon: Icons.monitor_weight_outlined, 
                        text: 'Track your progress',
                        delay: 1300,
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureItem(
                        icon: Icons.health_and_safety, 
                        text: 'Expert nutrition advice',
                        delay: 1500,
                      ),
                    ],
                  ),
                  
                  const Spacer(flex: 2),
                  
                  // Page indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPageIndicator(isActive: true),
                      _buildPageIndicator(isActive: false),
                      _buildPageIndicator(isActive: false),
                      _buildPageIndicator(isActive: false),
                    ],
                  )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 1600.ms),
                  
                  const SizedBox(height: 20),
                  
                  // Get Started Button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add haptic feedback
                        HapticFeedback.mediumImpact();
                        // Navigate to the goal selection page
                        context.pushNamed('goalSelection');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 1700.ms)
                  .slideY(begin: 0.3, end: 0, duration: 800.ms),
                  
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
                  )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 1900.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildConfetti() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: List.generate(30, (index) {
            final random = math.Random(index);
            final size = random.nextDouble() * 10 + 5;
            final initialPosition = Offset(
              random.nextDouble() * constraints.maxWidth,
              random.nextDouble() * 10 - 40,
            );
            final fallDuration = (random.nextDouble() * 2000 + 3000).toInt();
            final rotations = random.nextDouble() * 3;
            
            return Positioned(
              left: initialPosition.dx,
              top: initialPosition.dy,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: [
                    Colors.red.shade300,
                    Colors.green.shade300,
                    Colors.blue.shade300,
                    Colors.yellow.shade300,
                    Colors.orange.shade300,
                  ][random.nextInt(5)],
                  shape: random.nextBool() ? BoxShape.circle : BoxShape.rectangle,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .custom(
                duration: Duration(milliseconds: fallDuration),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(
                      initialPosition.dx + math.sin(value * math.pi * 2) * 30,
                      initialPosition.dy + value * constraints.maxHeight * 1.2,
                    ),
                    child: Transform.rotate(
                      angle: value * math.pi * 2 * rotations,
                      child: child,
                    ),
                  );
                },
              ),
            );
          }),
        );
      },
    );
  }
  
  Widget _buildPageIndicator({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
  
  Widget _buildFoodIcon(IconData icon, Color color, double animationMultiplier) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    )
    .animate(
      onPlay: (controller) => controller.repeat(),
    )
    .moveY(
      begin: 0, 
      end: 10, 
      duration: Duration(milliseconds: (2000 * animationMultiplier).toInt()),
      curve: Curves.easeInOut,
    )
    .then()
    .moveY(
      begin: 10, 
      end: 0, 
      duration: Duration(milliseconds: (2000 * animationMultiplier).toInt()),
      curve: Curves.easeInOut,
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
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(12),
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
    .fadeIn(duration: 800.ms, delay: delay.ms)
    .slideX(begin: 0.3, end: 0, duration: 800.ms);
  }
} 