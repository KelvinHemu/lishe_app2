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
  static const int _maxRequestsPerMinute = 60;
  final List<DateTime> _requestTimestamps = [];
  final Map<String, FoodItem> _foodCache = {};

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

  /// Search for food items by name
  /// Returns a list of FoodItem objects containing nutritional information
  Future<List<FoodItem>> searchFoodByName(String foodName) async {
    await _ensureInitialized();

    try {
      print('Searching for food by name: $foodName');

      // Create parameters for the request
      final params = {
        'method': 'foods.search',
        'search_expression': foodName,
        'max_results': '5',
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
        print('Raw response: ${response.body}');
        final data = json.decode(response.body);
        print('Decoded data: $data');

        // Check if foods were found
        if (data['foods'] == null || data['foods']['food'] == null) {
          print('No foods found for query: $foodName');
          return [];
        }

        // Parse the response
        final foodsData = data['foods']['food'];
        print('Foods data structure: ${foodsData.runtimeType}');
        print('Foods data content: $foodsData');

        final List<FoodItem> foods = [];

        // Check if we have a single food item or a list
        if (foodsData is List) {
          print('Processing list of foods');
          for (final food in foodsData) {
            try {
              print('Processing food item: $food');
              // Get detailed food information
              final detailedFood =
                  await getFoodDetails(food['food_id'].toString());
              foods.add(detailedFood);
            } catch (e, stackTrace) {
              print('Error parsing food item: $e');
              print('Stack trace: $stackTrace');
            }
          }
        } else if (foodsData is Map<String, dynamic>) {
          print('Processing single food item');
          try {
            print('Processing food item: $foodsData');
            // Get detailed food information
            final detailedFood =
                await getFoodDetails(foodsData['food_id'].toString());
            foods.add(detailedFood);
          } catch (e, stackTrace) {
            print('Error parsing single food item: $e');
            print('Stack trace: $stackTrace');
          }
        }

        print('Found ${foods.length} food items for: $foodName');
        return foods;
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to search for food: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Exception in searchFoodByName: $e');
      print('Stack trace: $stackTrace');
      // Return empty list instead of throwing to handle gracefully
      return [];
    }
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
    print('Creating safe food data for: $food');

    // Helper function to safely parse numbers with default value
    num safeParseNumber(dynamic value, {num defaultValue = 0}) {
      print('Parsing number value: $value (type: ${value?.runtimeType})');
      if (value == null) return defaultValue;
      if (value is num) return value;
      if (value is String) {
        try {
          return num.parse(value);
        } catch (e) {
          print('Error parsing number: $e');
          return defaultValue;
        }
      }
      return defaultValue;
    }

    // Helper function to safely parse strings with default value
    String safeParseString(dynamic value, {String defaultValue = ''}) {
      print('Parsing string value: $value (type: ${value?.runtimeType})');
      if (value == null) return defaultValue;
      if (value is String) return value;
      return value.toString();
    }

    // Helper function to safely parse lists
    List<Map<String, dynamic>> safeParseServings(dynamic value) {
      print('Parsing servings value: $value (type: ${value?.runtimeType})');
      if (value == null) return [];
      if (value is List) {
        return value.map((item) {
          if (item is Map<String, dynamic>) {
            final serving = {
              'serving_id': safeParseString(item['serving_id']),
              'serving_description':
                  safeParseString(item['serving_description']),
              'serving_url': safeParseString(item['serving_url']),
              'metric_serving_amount':
                  safeParseNumber(item['metric_serving_amount']),
              'metric_serving_unit':
                  safeParseString(item['metric_serving_unit']),
              'number_of_units':
                  safeParseNumber(item['number_of_units'], defaultValue: 1),
              'measurement_description':
                  safeParseString(item['measurement_description']),
              'calories': safeParseNumber(item['calories']),
              'carbohydrate': safeParseNumber(item['carbohydrate']),
              'protein': safeParseNumber(item['protein']),
              'fat': safeParseNumber(item['fat']),
              'saturated_fat': safeParseNumber(item['saturated_fat']),
              'polyunsaturated_fat':
                  safeParseNumber(item['polyunsaturated_fat']),
              'monounsaturated_fat':
                  safeParseNumber(item['monounsaturated_fat']),
              'trans_fat': safeParseNumber(item['trans_fat']),
              'cholesterol': safeParseNumber(item['cholesterol']),
              'sodium': safeParseNumber(item['sodium']),
              'potassium': safeParseNumber(item['potassium']),
              'fiber': safeParseNumber(item['fiber']),
              'sugar': safeParseNumber(item['sugar']),
              'vitamin_a': safeParseNumber(item['vitamin_a']),
              'vitamin_c': safeParseNumber(item['vitamin_c']),
              'calcium': safeParseNumber(item['calcium']),
              'iron': safeParseNumber(item['iron']),
            };
            print('Parsed serving: $serving');
            return serving;
          }
          return <String, dynamic>{};
        }).toList();
      }
      return [];
    }

    final result = {
      'food_id': safeParseString(food['food_id']),
      'food_name': safeParseString(food['food_name']),
      'food_type': safeParseString(food['food_type'], defaultValue: 'Generic'),
      'food_url': safeParseString(food['food_url']),
      'brand_name': safeParseString(food['brand_name']),
      'servings': safeParseServings(food['servings']?['serving']),
    };

    print('Final safe food data: $result');
    return result;
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
      if (servingAmountUnit != null)
        params['serving_amount_unit'] = servingAmountUnit;
      if (caloriesFromFat != null)
        params['calories_from_fat'] = caloriesFromFat.toString();
      if (saturatedFat != null)
        params['saturated_fat'] = saturatedFat.toString();
      if (polyunsaturatedFat != null)
        params['polyunsaturated_fat'] = polyunsaturatedFat.toString();
      if (monounsaturatedFat != null)
        params['monounsaturated_fat'] = monounsaturatedFat.toString();
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
