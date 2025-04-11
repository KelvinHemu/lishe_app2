import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/food_item.dart';
import 'oauth_utils.dart';

/// Service to handle FatSecret API integration for food recognition
/// This service implements OAuth 1.0 authentication and provides methods
/// for searching food items and getting nutritional information.
class FatSecretService {
  static FatSecretService? _instance;
  late String _apiKey;
  late String _apiSecret;
  late OAuthUtils _oauthUtils;
  bool _isInitialized = false;

  // Private constructor
  FatSecretService._();

  // Factory constructor for singleton
  factory FatSecretService() {
    _instance ??= FatSecretService._();
    return _instance!;
  }

  // API endpoint
  static const String _baseUrl =
      'https://platform.fatsecret.com/rest/server.api';

  /// Initialize the service with API credentials
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load API credentials from .env file
      _apiKey = dotenv.env['FATSECRET_API_KEY'] ?? '';
      _apiSecret = dotenv.env['FATSECRET_API_SECRET'] ?? '';

      if (_apiKey.isEmpty || _apiSecret.isEmpty) {
        throw Exception('FatSecret API credentials not found in .env file');
      }

      // Initialize OAuth utils
      _oauthUtils = OAuthUtils(
        consumerKey: _apiKey,
        consumerSecret: _apiSecret,
      );

      _isInitialized = true;
      print('FatSecret service initialized successfully');
    } catch (e) {
      print('Error initializing FatSecret service: $e');
      rethrow;
    }
  }

  /// Check if service is initialized and initialize if needed
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Search for food items by name and return the best match
  /// Returns a single FoodItem object containing nutritional information
  Future<FoodItem?> searchFoodByName(String foodName) async {
    await _ensureInitialized();

    try {
      print('Searching for food by name: $foodName');

      // Create parameters for the request
      final params = {
        'method': 'foods.search.v3',
        'search_expression': foodName,
        'max_results': '1',
        'include_sub_categories': 'false',
        'include_food_images': 'true',
        'include_food_attributes': 'true',
        'flag_default_serving': 'true',
        'region': 'US',
        'format': 'json',
      };

      print('Request parameters: $params');

      // Make request using OAuth utils
      final response = await _oauthUtils.makeRequest(
        method: 'GET',
        url: _baseUrl,
        parameters: params,
      );

      // Check response status
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Raw response: ${response.body}');
        print('Decoded data: $data');

        // Log the structure of the response for debugging
        print('Response keys: ${data.keys.join(', ')}');

        // Try different possible response structures
        dynamic foodsData;
        if (data['foods'] != null) {
          print('Found foods key');
          foodsData = data['foods']['food'];
        } else if (data['foods_search'] != null) {
          print('Found foods_search key');
          foodsData = data['foods_search']['results']['food'];
        } else {
          print('No known food data structure found');
          print('Available keys: ${data.keys.join(', ')}');
          return null;
        }

        if (foodsData == null) {
          print('No foods found for query: $foodName');
          return null;
        }

        print('Found foods data: $foodsData');
        print('Foods data type: ${foodsData.runtimeType}');

        // Handle single food item
        if (foodsData is Map<String, dynamic>) {
          try {
            print('Processing single food item: ${foodsData['food_name']}');
            final safeFoodData = _createSafeFoodData(foodsData);
            print('Created safe food data for single item');
            final foodItem = FoodItem.fromJson(safeFoodData);
            print('Successfully created FoodItem from single item');
            return foodItem;
          } catch (e, stackTrace) {
            print('Error processing single food item: $e');
            print('Stack trace: $stackTrace');
            return null;
          }
        }

        // Handle multiple food items
        if (foodsData is List) {
          print('Processing list of ${foodsData.length} foods');

          // Process all foods
          final List<FoodItem> foods = [];
          for (final food in foodsData) {
            try {
              print('Processing food: ${food['food_name']}');
              final safeFoodData = _createSafeFoodData(food);
              print('Created safe food data for: ${food['food_name']}');
              final foodItem = FoodItem.fromJson(safeFoodData);
              if (foodItem != null) {
                print('Successfully created FoodItem: ${foodItem.foodName}');
                foods.add(foodItem);
              } else {
                print('Failed to create FoodItem for: ${food['food_name']}');
              }
            } catch (e, stackTrace) {
              print('Error processing food: $e');
              print('Stack trace: $stackTrace');
              continue;
            }
          }

          if (foods.isEmpty) {
            print('No valid food items found');
            return null;
          }

          print('Found ${foods.length} valid food items');

          // Find the best match based on:
          // 1. Name similarity (weighted more heavily)
          // 2. Completeness of nutritional information
          // 3. Brand name (prefer branded items for better accuracy)
          FoodItem? bestMatch;
          double bestScore = -1;

          for (final food in foods) {
            double score = 0;

            // Name similarity score (0-1) - weighted more heavily
            final nameSimilarity = _calculateNameSimilarity(
              foodName.toLowerCase(),
              food.foodName.toLowerCase(),
            );
            score += nameSimilarity * 0.6; // Increased weight for name matching

            // Nutritional completeness score (0-1)
            final nutritionScore = _calculateNutritionCompleteness(food);
            score += nutritionScore *
                0.2; // Reduced weight for nutrition completeness

            // Brand preference score (0-1)
            final brandScore = food.brandName.isNotEmpty ? 0.2 : 0.1;
            score += brandScore;

            print(
                'Food: ${food.foodName}, Score: $score, Brand: ${food.brandName}');
            if (score > bestScore) {
              bestScore = score;
              bestMatch = food;
            }
          }

          print(
              'Best match found: ${bestMatch?.foodName} with score: $bestScore');
          return bestMatch;
        }

        print('Unexpected foods data type: ${foodsData.runtimeType}');
        return null;
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to search for food: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Exception in searchFoodByName: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Calculate similarity between search query and food name
  double _calculateNameSimilarity(String query, String foodName) {
    // Simple similarity calculation based on word matching
    final queryWords = query.split(' ');
    final foodWords = foodName.split(' ');

    int matches = 0;
    for (final queryWord in queryWords) {
      for (final foodWord in foodWords) {
        if (foodWord.contains(queryWord) || queryWord.contains(foodWord)) {
          matches++;
          break;
        }
      }
    }

    return matches / queryWords.length;
  }

  /// Calculate completeness of nutritional information
  double _calculateNutritionCompleteness(FoodItem food) {
    int filledFields = 0;
    int totalFields = 0;

    // Check each nutritional field
    void checkField(dynamic value) {
      totalFields++;
      if (value != null && value > 0) filledFields++;
    }

    checkField(food.calories);
    checkField(food.protein);
    checkField(food.fat);
    checkField(food.carbs);
    checkField(food.fiber);
    checkField(food.sugar);
    checkField(food.sodium);
    checkField(food.potassium);
    checkField(food.cholesterol);
    checkField(food.saturatedFat);
    checkField(food.unsaturatedFat);
    checkField(food.transFat);
    checkField(food.vitaminA);
    checkField(food.vitaminC);
    checkField(food.calcium);
    checkField(food.iron);

    return filledFields / totalFields;
  }

  /// Get detailed nutritional information for a specific food item
  Future<FoodItem> getFoodDetails(String foodId) async {
    await _ensureInitialized();

    try {
      // Create parameters for the request
      final params = {
        'method': 'food.get.v2',
        'food_id': foodId,
        'format': 'json',
      };

      // Make request using OAuth utils
      final response = await _oauthUtils.makeRequest(
        method: 'GET',
        url: _baseUrl,
        parameters: params,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['food'] == null) {
          print('Food details not found: ${response.body}');
          throw Exception('Food details not found');
        }
        final foodData = data['food'] as Map<String, dynamic>;
        return FoodItem.fromJson(_createSafeFoodData(foodData));
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get food details: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in getFoodDetails: $e');
      throw Exception('Failed to get food details: $e');
    }
  }

  /// Get API key information for diagnostics
  Future<String> getApiKeyInfo() async {
    await _ensureInitialized();

    // Return masked API key for security
    if (_apiKey.isNotEmpty) {
      final maskedKey = _apiKey.length > 8
          ? "${_apiKey.substring(0, 4)}...${_apiKey.substring(_apiKey.length - 4)}"
          : "****";

      return "API Key: $maskedKey (length: ${_apiKey.length})";
    } else {
      return "API Key not found";
    }
  }

  /// Test API connection with a simple call
  Future<String> testApiCall() async {
    await _ensureInitialized();

    try {
      // Create parameters for a simple food.search request
      final params = {
        'method': 'foods.search',
        'search_expression': 'apple',
        'max_results': '1',
        'format': 'json',
      };

      // Make request using OAuth utils
      final response = await _oauthUtils.makeRequest(
        method: 'GET',
        url: _baseUrl,
        parameters: params,
      );

      return "Status: ${response.statusCode}\nResponse: ${response.body.substring(0, math.min(200, response.body.length))}...";
    } catch (e) {
      return "Test failed: $e";
    }
  }

  /// Creates a safe food data map with proper type handling
  Map<String, dynamic> _createSafeFoodData(Map<String, dynamic> food) {
    // Helper function to safely parse numbers with default value
    num safeParseNumber(dynamic value,
        {num defaultValue = 0, String fieldName = ''}) {
      if (value == null) return defaultValue;
      if (value is num) return value;
      if (value is String) {
        try {
          return num.parse(value);
        } catch (e) {
          return defaultValue;
        }
      }
      return defaultValue;
    }

    // Helper function to safely parse strings with default value
    String safeParseString(dynamic value,
        {String defaultValue = '', String fieldName = ''}) {
      if (value == null) return defaultValue;
      if (value is String) return value;
      return value.toString();
    }

    // Helper function to safely parse servings
    Map<String, dynamic>? getDefaultServing(dynamic servings) {
      if (servings == null) return null;

      // Handle case where servings is a list
      if (servings is List) {
        if (servings.isEmpty) return null;
        // Try to find the default serving (is_default: "1") or use the first one
        try {
          final defaultServing = servings.firstWhere(
            (s) => s['is_default'] == "1",
            orElse: () => servings.first,
          );
          return Map<String, dynamic>.from(defaultServing);
        } catch (e) {
          return null;
        }
      }

      // Handle case where servings is a map
      if (servings is Map) {
        return Map<String, dynamic>.from(servings);
      }

      return null;
    }

    // Get the default serving data
    final servings = food['servings'];
    final serving = servings?['serving'];
    final defaultServing = getDefaultServing(serving) ?? {};

    // Create the safe food data map
    final safeFoodData = {
      'food_id': safeParseString(food['food_id'], defaultValue: '0'),
      'food_name':
          safeParseString(food['food_name'], defaultValue: 'Unknown Food'),
      'brand_name': safeParseString(food['brand_name']),
      'food_type': safeParseString(food['food_type'], defaultValue: 'Generic'),
      'food_url': safeParseString(food['food_url']),
      'calories': safeParseNumber(defaultServing['calories']),
      'protein': safeParseNumber(defaultServing['protein']),
      'fat': safeParseNumber(defaultServing['fat']),
      'carbs': safeParseNumber(defaultServing['carbohydrate']),
      'fiber': safeParseNumber(defaultServing['fiber']),
      'sugar': safeParseNumber(defaultServing['sugar']),
      'sodium': safeParseNumber(defaultServing['sodium']),
      'potassium': safeParseNumber(defaultServing['potassium']),
      'cholesterol': safeParseNumber(defaultServing['cholesterol']),
      'saturated_fat': safeParseNumber(defaultServing['saturated_fat']),
      'unsaturated_fat':
          safeParseNumber(defaultServing['polyunsaturated_fat'] ?? 0) +
              safeParseNumber(defaultServing['monounsaturated_fat'] ?? 0),
      'trans_fat': safeParseNumber(defaultServing['trans_fat']),
      'vitamin_a': safeParseNumber(defaultServing['vitamin_a']),
      'vitamin_c': safeParseNumber(defaultServing['vitamin_c']),
      'calcium': safeParseNumber(defaultServing['calcium']),
      'iron': safeParseNumber(defaultServing['iron']),
      'serving_size': safeParseNumber(defaultServing['metric_serving_amount']),
      'serving_unit': safeParseString(defaultServing['metric_serving_unit']),
    };

    return safeFoodData;
  }

  /// Start the OAuth 1.0 3-legged authentication flow
  Future<String> startAuthentication() async {
    await _ensureInitialized();

    try {
      // Get request token
      final tokenData = await _oauthUtils.getRequestToken();
      final requestToken = tokenData['oauth_token'];
      final requestTokenSecret = tokenData['oauth_token_secret'];

      if (requestToken == null || requestTokenSecret == null) {
        throw Exception('Failed to get request token');
      }

      // Return authorization URL
      return _oauthUtils.getAuthorizationUrl(requestToken);
    } catch (e) {
      print('Error starting authentication: $e');
      rethrow;
    }
  }

  /// Complete the OAuth 1.0 3-legged authentication flow
  Future<void> completeAuthentication(String verifier) async {
    await _ensureInitialized();

    try {
      // Exchange request token for access token
      await _oauthUtils.getAccessToken(
        requestToken: _oauthUtils.accessToken,
        requestTokenSecret: _oauthUtils.accessTokenSecret,
        verifier: verifier,
      );

      print('Authentication completed successfully');
    } catch (e) {
      print('Error completing authentication: $e');
      rethrow;
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _oauthUtils.isAuthenticated;

  /// Clear authentication state
  void clearAuthentication() {
    _oauthUtils.clearAuthentication();
  }

  /// Get user's food diary entries
  Future<List<Map<String, dynamic>>> getFoodDiaryEntries({
    required DateTime date,
  }) async {
    await _ensureInitialized();

    if (!isAuthenticated) {
      throw Exception('User must be authenticated to access food diary');
    }

    try {
      final params = {
        'method': 'food_entries.get',
        'date':
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        'format': 'json',
      };

      final response = await _oauthUtils.makeRequest(
        method: 'GET',
        url: _baseUrl,
        parameters: params,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['food_entries'] == null ||
            data['food_entries']['food_entry'] == null) {
          return [];
        }

        final entries = data['food_entries']['food_entry'];
        if (entries is List) {
          return entries.cast<Map<String, dynamic>>();
        } else if (entries is Map<String, dynamic>) {
          return [entries];
        }
        return [];
      } else {
        throw Exception(
            'Failed to get food diary entries: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting food diary entries: $e');
      rethrow;
    }
  }

  /// Add food entry to user's diary
  Future<void> addFoodDiaryEntry({
    required String foodId,
    required String servingId,
    required double numberOfUnits,
    required String meal,
    required DateTime date,
  }) async {
    await _ensureInitialized();

    if (!isAuthenticated) {
      throw Exception('User must be authenticated to add food diary entries');
    }

    try {
      final params = {
        'method': 'food_entry.create',
        'food_id': foodId,
        'serving_id': servingId,
        'number_of_units': numberOfUnits.toString(),
        'meal': meal,
        'date':
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        'format': 'json',
      };

      final response = await _oauthUtils.makeRequest(
        method: 'POST',
        url: _baseUrl,
        parameters: params,
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to add food diary entry: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding food diary entry: $e');
      rethrow;
    }
  }

  /// Create a new custom food item
  /// This method requires 3-legged OAuth authentication
  Future<String> createFood({
    required String brandType,
    required String brandName,
    required String foodName,
    required String servingSize,
    required double calories,
    required double fat,
    required double carbohydrate,
    required double protein,
    String? servingAmount,
    String? servingAmountUnit,
    double? caloriesFromFat,
    double? saturatedFat,
    double? polyunsaturatedFat,
    double? monounsaturatedFat,
    double? transFat,
    double? cholesterol,
    double? sodium,
    double? potassium,
    double? fiber,
    double? sugar,
    double? addedSugars,
    double? vitaminD,
    double? vitaminA,
    double? vitaminC,
    double? calcium,
    double? iron,
    String? region,
    String? language,
  }) async {
    await _ensureInitialized();

    if (!isAuthenticated) {
      throw Exception('User must be authenticated to create custom foods');
    }

    try {
      // Base parameters
      final params = {
        'method': 'food.create.v2',
        'brand_type': brandType,
        'brand_name': brandName,
        'food_name': foodName,
        'serving_size': servingSize,
        'calories': calories.toString(),
        'fat': fat.toString(),
        'carbohydrate': carbohydrate.toString(),
        'protein': protein.toString(),
        'format': 'json',
      };

      // Optional parameters
      if (servingAmount != null) params['serving_amount'] = servingAmount;
      if (servingAmountUnit != null) {
        params['serving_amount_unit'] = servingAmountUnit;
      }
      if (caloriesFromFat != null) {
        params['calories_from_fat'] = caloriesFromFat.toString();
      }
      if (saturatedFat != null) {
        params['saturated_fat'] = saturatedFat.toString();
      }
      if (polyunsaturatedFat != null) {
        params['polyunsaturated_fat'] = polyunsaturatedFat.toString();
      }
      if (monounsaturatedFat != null) {
        params['monounsaturated_fat'] = monounsaturatedFat.toString();
      }
      if (transFat != null) params['trans_fat'] = transFat.toString();
      if (cholesterol != null) params['cholesterol'] = cholesterol.toString();
      if (sodium != null) params['sodium'] = sodium.toString();
      if (potassium != null) params['potassium'] = potassium.toString();
      if (fiber != null) params['fiber'] = fiber.toString();
      if (sugar != null) params['sugar'] = sugar.toString();
      if (addedSugars != null) params['added_sugars'] = addedSugars.toString();
      if (vitaminD != null) params['vitamin_d'] = vitaminD.toString();
      if (vitaminA != null) params['vitamin_a'] = vitaminA.toString();
      if (vitaminC != null) params['vitamin_c'] = vitaminC.toString();
      if (calcium != null) params['calcium'] = calcium.toString();
      if (iron != null) params['iron'] = iron.toString();
      if (region != null) params['region'] = region;
      if (language != null) params['language'] = language;

      // Make request using OAuth utils
      final response = await _oauthUtils.makeRequest(
        method: 'POST',
        url: _baseUrl,
        parameters: params,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['food_id'] == null) {
          throw Exception('Failed to create food: No food_id returned');
        }
        return data['food_id'].toString();
      } else {
        throw Exception('Failed to create food: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating food: $e');
      rethrow;
    }
  }
}
