

import 'package:lishe_app/features/meal_planner/services/meal_service.dart';

import 'api_service.dart';

/// Service locator singleton to manage dependencies
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() {
    return _instance;
  }

  ServiceLocator._internal();

  // Services
  late ApiService apiService;

  /// Initialize all services
  void setup() {
    // Use mock services for now - easy to replace with real implementation later
    apiService = MockApiService();
  }
}

final serviceLocator = ServiceLocator();
