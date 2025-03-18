import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo and app name
                Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 120,
                      width: 120,
                      errorBuilder:
                          (context, error, stackTrace) => const Icon(
                            Icons.eco,
                            size: 120,
                            color: Color.fromRGBO(20, 49, 26, 1),
                          ),
                    ),
                    const Text(
                      "LISHE",
                      style: TextStyle(
                        fontSize: 32.0,
                        color: Color.fromRGBO(20, 49, 26, 1),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // App description
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Your personal nutrition companion for healthy eating habits and better lifestyle",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Feature highlights
                _buildFeatureItem(
                  Icons.restaurant_menu,
                  'Personalized Meal Plans',
                  'Get meal plans tailored to your nutritional needs',
                ),
                const SizedBox(height: 16),
                _buildFeatureItem(
                  Icons.track_changes,
                  'Track Your Progress',
                  'Monitor your nutrition goals and health metrics',
                ),
                const SizedBox(height: 16),
                _buildFeatureItem(
                  Icons.tips_and_updates,
                  'Expert Tips',
                  'Access nutrition advice from certified experts',
                ),

                const SizedBox(height: 60),

                // Get Started button
                ElevatedButton(
                  onPressed: () => context.go('/auth'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1,
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(
              76,
              175,
              80,
              0.1,
            ), // Green with 10% opacity
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.green, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                description,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
