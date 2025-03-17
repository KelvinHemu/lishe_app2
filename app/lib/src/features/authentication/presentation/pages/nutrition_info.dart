import 'package:flutter/material.dart';

class NutritionInfo extends StatelessWidget {
  const NutritionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Lishe',
            style: TextStyle(
              fontSize: 40,
              color: Color.fromARGB(255, 13, 95, 133),
              fontFamily: 'Inter',
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Track Your Nutrition',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // First initialize the database
                        await Navigator.pushNamed(context, '/food_tracking_setup');
                        // Then navigate to the food tracking page
                        Navigator.pushNamed(context, '/food_tracking');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        backgroundColor: const Color.fromARGB(255, 13, 95, 133),
                      ),
                      child: Text(
                        'Start Food Tracking',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
