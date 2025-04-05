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
      await dotenv.load();
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

  /// Search for food items using an image
  Future<List<FoodItem>> searchFoodByImage(String base64Image) async {
    // Create a mock food item for testing purposes
    final debugFood = {
      'food_id': '12345',
      'food_name': 'Test Food Item',
      'brand_name': '',
      'food_type': 'Generic',
      'food_url': '',
      'calories': 100.0,
      'protein': 10.0,
      'fat': 5.0,
      'carbohydrate': 20.0,
      'fiber': 2.0,
      'sugar': 5.0,
      'sodium': 200.0,
      'potassium': 300.0,
      'cholesterol': 0.0,
      'saturated_fat': 1.0,
      'unsaturated_fat': 3.0,
      'trans_fat': 0.0,
      'vitamin_a': 5.0,
      'vitamin_c': 10.0,
      'calcium': 100.0,
      'iron': 2.0,
      'serving_size': 1.0,
      'serving_unit': 'serving',
    };

    try {
      String processedBase64 = base64Image;

      // For debugging, log the length of the base64 image
      print('Base64 image length: ${processedBase64.length}');

      // Check if API key is available
      print(
          'Using API key: ${_apiKey.substring(0, math.min(5, _apiKey.length))}...');

      // If image is too large, truncate it
      if (processedBase64.length > 500 * 1024) {
        print(
            'Image too large (${processedBase64.length} bytes), truncating...');
        processedBase64 = _truncateBase64(processedBase64, 500 * 1024);
      }

      // According to documentation, we need to use the Image Recognition v1 endpoint
      final endpoint = 'https://platform.fatsecret.com/rest/server.api';
      final uri = Uri.parse(endpoint);

      // Create random nonce and timestamp for OAuth
      final random = math.Random();
      final nonce =
          base64.encode(List<int>.generate(32, (_) => random.nextInt(256)));
      final timestamp =
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

      // OAuth parameters
      final oauthParams = {
        'oauth_consumer_key': _apiKey,
        'oauth_nonce': nonce,
        'oauth_signature_method': 'HMAC-SHA1',
        'oauth_timestamp': timestamp,
        'oauth_version': '1.0',
      };

      // Create a JSON payload for the POST request
      final payload = json.encode({
        'method': 'food.find_id_for_barcode',
        'format': 'json',
        'food_image': processedBase64,
      });

      // Build base string for signature
      final baseStringParts = [
        'POST',
        Uri.encodeComponent(endpoint),
        Uri.encodeComponent(
            oauthParams.entries.map((e) => '${e.key}=${e.value}').join('&')),
      ];
      final baseString = baseStringParts.join('&');

      // Generate HMAC-SHA1 signature
      final signingKey = '$_apiSecret&';
      final hmacKey = utf8.encode(signingKey);
      final hmac = Hmac(sha1, hmacKey);
      final digest = hmac.convert(utf8.encode(baseString));
      final signature = base64.encode(digest.bytes);

      // Build the OAuth header
      final authHeader = 'OAuth ' +
          oauthParams.entries
              .map((e) => '${e.key}="${Uri.encodeComponent(e.value)}"')
              .join(', ') +
          ', oauth_signature="${Uri.encodeComponent(signature)}"';

      print(
          'Using OAuth header: ${authHeader.substring(0, math.min(100, authHeader.length))}...');

      // Make the API request with error handling and timeout
      http.Response response;
      try {
        // Use a timeout to avoid hanging if the server doesn't respond
        response = await http
            .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': authHeader,
          },
          body: payload,
        )
            .timeout(const Duration(seconds: 30), onTimeout: () {
          throw Exception('API request timed out after 30 seconds');
        });
      } catch (requestError) {
        print('Error during API request: $requestError');

        // Return mock data for debugging on connection issues
        print('Returning mock food data for debugging');
        return [FoodItem.fromJson(debugFood)];
      }

      // Check response status
      print('Response status code: ${response.statusCode}');

      // Parse the response based on status code
      if (response.statusCode == 200) {
        print('API call successful');

        try {
          final data = json.decode(response.body);
          print(
              'Response data: ${response.body.substring(0, math.min(500, response.body.length))}...');

          // Check for error response
          if (data.containsKey('error')) {
            print('API returned an error: ${data['error']}');
            return [FoodItem.fromJson(debugFood)];
          }

          // Parse the response according to the documentation
          if (data['food_responses'] == null ||
              data['food_responses'].isEmpty) {
            print('No foods found in response');
            return [];
          }

          List<FoodItem> foodItems = [];

          // Process food responses
          for (var foodResponse in data['food_responses']) {
            try {
              // Extract the food data
              final foodId = foodResponse['food_id'].toString();
              final foodName = foodResponse['food_entry_name'].toString();
              final brandName = foodResponse['brand_name']?.toString() ?? '';

              print('Found food: $foodName (ID: $foodId)');

              // Create a Map to pass to the fromJson constructor
              final Map<String, dynamic> foodJson = {
                'food_id': foodId,
                'food_name': foodName,
                'brand_name': brandName,
                // Default values for required fields if not available
                'food_type': 'Generic',
                'food_url': '',
                'calories': 0.0,
                'protein': 0.0,
                'fat': 0.0,
                'carbohydrate': 0.0,
                'fiber': 0.0,
                'sugar': 0.0,
                'sodium': 0.0,
                'potassium': 0.0,
                'cholesterol': 0.0,
                'saturated_fat': 0.0,
                'unsaturated_fat': 0.0,
                'trans_fat': 0.0,
                'vitamin_a': 0.0,
                'vitamin_c': 0.0,
                'calcium': 0.0,
                'iron': 0.0,
                'serving_size': 1.0,
                'serving_unit': 'serving',
              };

              // Get nutritional information if available
              if (foodResponse['servings'] != null &&
                  foodResponse['servings']['serving'] != null) {
                var servings = foodResponse['servings']['serving'];
                Map<String, dynamic> servingInfo;

                if (servings is List && servings.isNotEmpty) {
                  servingInfo = Map<String, dynamic>.from(servings[0]);
                } else if (servings is Map) {
                  servingInfo = Map<String, dynamic>.from(servings);
                } else {
                  servingInfo = {};
                }

                // Extract nutritional info if available
                if (servingInfo.containsKey('nutrition')) {
                  var nutrition = servingInfo['nutrition'];
                  if (nutrition is Map) {
                    // Update food JSON with nutritional data
                    for (var key in nutrition.keys) {
                      if (foodJson.containsKey(key)) {
                        try {
                          // Convert to double if possible
                          foodJson[key] =
                              double.tryParse(nutrition[key].toString()) ?? 0.0;
                        } catch (e) {
                          print('Error parsing nutrition data for $key: $e');
                        }
                      }
                    }
                  }
                }
              }

              // Create the food item using fromJson constructor
              foodItems.add(FoodItem.fromJson(foodJson));
            } catch (e) {
              print('Error processing food response: $e');
              // Continue with next item
            }
          }

          return foodItems;
        } catch (parseError) {
          print('Error parsing response: $parseError');
          // Return mock data on parsing error
          return [FoodItem.fromJson(debugFood)];
        }
      } else if (response.statusCode == 414) {
        // 414 URI Too Long - Try with smaller image
        print('414 URI Too Long error. Trying with smaller image...');

        // Truncate to 200KB
        if (processedBase64.length > 200 * 1024) {
          final smallerBase64 =
              processedBase64.substring(0, (200 * 1024 ~/ 4) * 4);
          // Recursive call with smaller image
          return searchFoodByImage(smallerBase64);
        } else {
          print(
              'Failed to search food: Image still too large even after reduction');
          // Return mock data on error
          return [FoodItem.fromJson(debugFood)];
        }
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        // Return mock data on error
        return [FoodItem.fromJson(debugFood)];
      }
    } catch (e) {
      print('Exception in searchFoodByImage: $e');

      // Return mock data for general errors
      print('Returning mock food data for debugging');
      return [FoodItem.fromJson(debugFood)];
    }
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

  /// Test the image recognition endpoint directly
  Future<String> testImageRecognition(String shortBase64Image) async {
    await _ensureInitialized();

    try {
      // First 100 characters of the base64 image for logging (truncated for brevity)
      final previewImage = shortBase64Image.length > 100
          ? "${shortBase64Image.substring(0, 100)}..."
          : shortBase64Image;

      print('Testing image recognition with sample: $previewImage');

      // Create the endpoint URL
      final uri =
          Uri.parse('https://platform.fatsecret.com/rest/image-recognition/v1');

      // Using direct HTTP request with proper OAuth headers
      // Generate random nonce and timestamp
      final nonce = _generateNonce();
      final timestamp = _generateTimestamp();

      // Specific parameters for this request
      final Map<String, String> oauthParams = {
        'oauth_consumer_key': _apiKey,
        'oauth_nonce': nonce,
        'oauth_signature_method': 'HMAC-SHA1',
        'oauth_timestamp': timestamp,
        'oauth_version': '1.0',
      };

      // Base string for signature
      final String baseString = 'POST&' +
          Uri.encodeComponent(uri.toString()) +
          '&' +
          Uri.encodeComponent(oauthParams.entries
              .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
              .join('&'));

      // Generate signature with HMAC-SHA1
      final Hmac hmacSha1 = Hmac(sha1, utf8.encode('${_apiSecret}&'));
      final Digest signature = hmacSha1.convert(utf8.encode(baseString));
      final String signatureBase64 = base64.encode(signature.bytes);

      // Create OAuth header
      final String authHeader = 'OAuth ' +
          'oauth_consumer_key="${Uri.encodeComponent(_apiKey)}", ' +
          'oauth_nonce="${Uri.encodeComponent(nonce)}", ' +
          'oauth_signature="${Uri.encodeComponent(signatureBase64)}", ' +
          'oauth_signature_method="HMAC-SHA1", ' +
          'oauth_timestamp="${timestamp}", ' +
          'oauth_version="1.0"';

      // Prepare the JSON payload
      final payload = json.encode({
        'image_b64': shortBase64Image,
        'region': 'US',
        'language': 'en',
        'include_food_data': true,
      });

      print(
          'Test API call with OAuth header: ${authHeader.substring(0, math.min(100, authHeader.length))}...');

      // Send the request
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': authHeader,
        },
        body: payload,
      );

      return "Status: ${response.statusCode}\nResponse: ${response.body.substring(0, math.min(200, response.body.length))}...";
    } catch (e) {
      return "Image recognition test failed: $e";
    }
  }
}
