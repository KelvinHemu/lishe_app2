import 'package:dio/dio.dart';

class SpoonacularService {
  final Dio _dio = Dio();
  final String apiKey = 'b317a79e49d14fd29b549ad8ea3bfb9b';

  Future<List<dynamic>> getMealPlan({int targetCalories = 2000}) async {
    final response = await _dio.get(
      'https://api.spoonacular.com/mealplanner/generate',
      queryParameters: {
        'timeFrame': 'day',
        'targetCalories': targetCalories,
        'apiKey': apiKey,
      },
    );

    return response.data['meals'];
  }

  Future<Map<String, dynamic>> getMealDetails(int mealId) async {
    final response = await _dio.get(
      'https://api.spoonacular.com/recipes/$mealId/information',
      queryParameters: {
        'includeNutrition': true,
        'apiKey': apiKey,
      },
    );

    return response.data;
  }
}
