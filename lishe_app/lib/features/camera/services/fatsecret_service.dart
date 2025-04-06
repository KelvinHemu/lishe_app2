import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import '../models/food_item.dart';

/// Service to handle FatSecret API integration for food recognition
class FatSecretService {
  static FatSecretService? _instance;
  late String _apiKey;
  late String _apiSecret;
  late oauth1.Client _client;
  bool _isInitialized = false;

  // Private constructor
  FatSecretService._();

  // Factory constructor for singleton
  factory FatSecretService() {
    _instance ??= FatSecretService._();
    return _instance!;
  }

  // API endpoints
  static const String _baseUrl =
      'https://platform.fatsecret.com/rest/server.api';

  // Generate a random nonce for OAuth
  String _generateNonce() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = math.Random.secure();
    return List.generate(32, (_) => chars[random.nextInt(chars.length)]).join();
  }

  // Generate timestamp for OAuth
  String _generateTimestamp() {
    return (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
  }

  // Generate OAuth signature
  String _generateSignature(Map<String, String> params, String httpMethod) {
    // Sort parameters alphabetically by key
    final sortedParams = Map.fromEntries(
        params.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));

    // Create base string
    final baseString = httpMethod.toUpperCase() +
        '&' +
        Uri.encodeComponent(_baseUrl) +
        '&' +
        Uri.encodeComponent(Uri(queryParameters: sortedParams).query);

    // Create signing key
    final signingKey = Uri.encodeComponent(_apiSecret) + '&';

    // Generate HMAC-SHA1 signature
    final hmacSha1 = Hmac(sha1, utf8.encode(signingKey));
    final digest = hmacSha1.convert(utf8.encode(baseString));
    return base64.encode(digest.bytes);
  }

  /// Check if service is initialized and initialize if needed
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

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

      // Create OAuth client with platform.signatureMethod, credentials, and null token
      final platform = oauth1.Platform(
        'https://platform.fatsecret.com/rest/server.api',
        'https://platform.fatsecret.com/rest/server.api',
        'https://platform.fatsecret.com/rest/server.api',
        oauth1.SignatureMethods.hmacSha1,
      );

      final credentials = oauth1.ClientCredentials(_apiKey, _apiSecret);
      _client = oauth1.Client(platform.signatureMethod, credentials, null);

      _isInitialized = true;
      print('FatSecret service initialized successfully');
    } catch (e) {
      print('Error initializing FatSecret service: $e');
      rethrow;
    }
  }

  /// Helper method to truncate a base64 string to a specific size (keeping it valid)
  String _truncateBase64(String base64String, int maxSizeInBytes) {
    // Calculate the maximum size in characters that will keep the base64 valid
    // Base64 encoding: 4 chars = 3 bytes, so we ensure truncation maintains validity
    int maxChars = (maxSizeInBytes ~/ 3) * 4;

    // Ensure we truncate to a multiple of 4 to maintain valid base64
    maxChars = (maxChars ~/ 4) * 4;

    if (base64String.length <= maxChars) {
      return base64String;
    }

    return base64String.substring(0, maxChars);
  }

  /// A helper method to add detailed debugging for OAuth
  void _debugOAuth(String baseString, String signingKey, String signature,
      String authHeader) {
    print('==================== OAuth Debug ====================');
    print(
        'API Key (first 5 chars): ${_apiKey.substring(0, math.min(5, _apiKey.length))}...');
    print(
        'API Secret (first 3 chars): ${_apiSecret.substring(0, math.min(3, _apiSecret.length))}...');
    print('Base String: $baseString');
    print('Signing Key: $signingKey');
    print('Generated Signature: $signature');
    print('Auth Header: $authHeader');
    print('=====================================================');
  }

  /// Helper method to generate the OAuth authorization header
  String _generateOAuthHeader(
      String signature, String nonce, String timestamp) {
    return 'OAuth oauth_consumer_key="${Uri.encodeComponent(_apiKey)}",'
        'oauth_nonce="${Uri.encodeComponent(nonce)}",'
        'oauth_signature="${Uri.encodeComponent(signature)}",'
        'oauth_signature_method="HMAC-SHA1",'
        'oauth_timestamp="$timestamp",'
        'oauth_version="1.0"';
  }

  /// Get detailed nutritional information for a specific food item
  Future<FoodItem> getFoodDetails(String foodId) async {
    // Ensure service is initialized
    await _ensureInitialized();

    // Basic OAuth parameters
    final nonce = _generateNonce();
    final timestamp = _generateTimestamp();

    // Create parameters for the request
    final params = {
      'oauth_consumer_key': _apiKey,
      'oauth_nonce': nonce,
      'oauth_signature_method': 'HMAC-SHA1',
      'oauth_timestamp': timestamp,
      'oauth_version': '1.0',
      'method': 'food.get.v2',
      'food_id': foodId,
      'format': 'json',
    };

    // Generate signature
    final signature = _generateSignature(params, 'GET');
    params['oauth_signature'] = signature;

    // Create URL with query parameters
    final uri = Uri.parse(_baseUrl).replace(queryParameters: params);

    try {
      // Make GET request
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['food'] == null) {
          print('Food details not found: ${response.body}');
          throw Exception('Food details not found');
        }
        final foodData = data['food'] as Map<String, dynamic>;
        return FoodItem.fromJson(foodData);
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
      // Basic OAuth parameters
      final nonce = _generateNonce();
      final timestamp = _generateTimestamp();

      // Create parameters for a simple food.search request
      final params = {
        'oauth_consumer_key': _apiKey,
        'oauth_nonce': nonce,
        'oauth_signature_method': 'HMAC-SHA1',
        'oauth_timestamp': timestamp,
        'oauth_version': '1.0',
        'method': 'foods.search',
        'search_expression': 'apple',
        'max_results': '1',
        'format': 'json',
      };

      // Generate signature
      final signature = _generateSignature(params, 'GET');
      params['oauth_signature'] = signature;

      // Create URL with query parameters
      final uri = Uri.parse(_baseUrl).replace(queryParameters: params);

      print('Test API call to: $uri');

      // Make GET request
      final response = await http.get(uri);

      return "Status: ${response.statusCode}\nResponse: ${response.body.substring(0, math.min(200, response.body.length))}...";
    } catch (e) {
      return "Test failed: $e";
    }
  }

  /// Search for food items by name
  Future<List<FoodItem>> searchFoodByName(String foodName) async {
    await _ensureInitialized();

    try {
      print('Searching for food by name: $foodName');

      // Generate OAuth parameters
      final nonce = _generateNonce();
      final timestamp = _generateTimestamp();

      // Create parameters for the request
      final params = {
        'oauth_consumer_key': _apiKey,
        'oauth_nonce': nonce,
        'oauth_signature_method': 'HMAC-SHA1',
        'oauth_timestamp': timestamp,
        'oauth_version': '1.0',
        'method': 'foods.search',
        'search_expression': foodName,
        'max_results': '3',
        'format': 'json',
      };

      // Generate signature
      final signature = _generateSignature(params, 'GET');
      params['oauth_signature'] = signature;

      // Create URL with query parameters
      final uri = Uri.parse(_baseUrl).replace(queryParameters: params);

      print('Sending FatSecret search request for: $foodName');

      // Make GET request
      final response = await http.get(uri).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Food search request timed out after 15 seconds');
        },
      );

      // Check response status
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if foods were found
        if (data['foods'] == null || data['foods']['food'] == null) {
          print('No foods found for query: $foodName');
          return [];
        }

        // Parse the response
        final foodsData = data['foods']['food'];
        final List<FoodItem> foods = [];

        // Check if we have a single food item or a list
        if (foodsData is List) {
          for (final food in foodsData) {
            try {
              foods.add(FoodItem.fromJson(food));
            } catch (e) {
              print('Error parsing food item: $e');
            }
          }
        } else if (foodsData is Map<String, dynamic>) {
          // Single food item
          try {
            foods.add(FoodItem.fromJson(foodsData));
          } catch (e) {
            print('Error parsing single food item: $e');
          }
        }

        print('Found ${foods.length} food items for: $foodName');
        return foods;
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to search for food: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in searchFoodByName: $e');
      // Return empty list instead of throwing to handle gracefully
      return [];
    }
  }
}
