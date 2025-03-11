import 'package:flutter/material.dart';

import '../../utils/initialize_food_database.dart';

class FoodTrackingSetupPage extends StatefulWidget {
  const FoodTrackingSetupPage({Key? key}) : super(key: key);

  @override
  State<FoodTrackingSetupPage> createState() => _FoodTrackingSetupPageState();
}

class _FoodTrackingSetupPageState extends State<FoodTrackingSetupPage> {
  bool _isInitializing = false;
  String _status = '';

  Future<void> _initializeDatabase() async {
    setState(() {
      _isInitializing = true;
      _status = 'Initializing food database...';
    });

    try {
      final initializer = FoodDatabaseInitializer();
      await initializer.initializeFoodDatabase();
      setState(() {
        _status = 'Database initialized successfully!';
      });
      
      // Navigate back after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } catch (e) {
      setState(() {
        _status = 'Error initializing database: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Setup Food Tracking',
          style: TextStyle(
            fontSize: 24,
            color: const Color.fromARGB(255, 13, 95, 133),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Initialize Food Database',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16.0),
              Text(
                'This will create a database of common foods that you can track.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32.0),
              if (_isInitializing)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _initializeDatabase,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 16.0,
                    ),
                    backgroundColor: const Color.fromARGB(255, 13, 95, 133),
                  ),
                  child: const Text(
                    'Initialize Database',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(height: 16.0),
              if (_status.isNotEmpty)
                Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _status.contains('Error')
                            ? Colors.red
                            : Colors.green,
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 