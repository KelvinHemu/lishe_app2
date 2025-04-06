import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// GeminiService handles interactions with Google's Gemini API for image analysis
class GeminiService {
  static GeminiService? _instance;
  late String _apiKey;
  bool _isInitialized = false;

  // Private constructor
  GeminiService._();

  // Factory constructor for singleton
  factory GeminiService() {
    _instance ??= GeminiService._();
    return _instance!;
  }

  // API base URL
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta';

  /// Initialize the service with API key
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load API key from .env file
      _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

      if (_apiKey.isEmpty) {
        throw Exception('Gemini API key not found in .env file');
      }

      _isInitialized = true;
      print('Gemini service initialized successfully');
    } catch (e) {
      print('Error initializing Gemini service: $e');
      rethrow;
    }
  }

  /// Check if service is initialized and initialize if needed
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Analyze an image and identify the food items in it
  /// Returns a list of food item names detected in the image
  Future<List<String>> identifyFoodInImage(String base64Image) async {
    await _ensureInitialized();

    try {
      // API endpoint for Gemini Pro Vision
      final endpoint =
          '$_baseUrl/models/gemini-pro-vision:generateContent?key=$_apiKey';

      // Verify the image is not too large (Gemini has a 4MB limit)
      if (base64Image.length > 4000000) {
        // Simple truncation for large images (better approach would be to resize)
        print('Image too large for Gemini API, truncating...');
        base64Image = base64Image.substring(0, 4000000);
      }

      // Prepare the request payload
      final payload = {
        "contents": [
          {
            "parts": [
              {
                "text":
                    "Please identify all the food items in this image. Respond with a comma-separated list of food names only, no descriptions or explanations."
              },
              {
                "inline_data": {"mime_type": "image/jpeg", "data": base64Image}
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.2,
          "topK": 32,
          "topP": 0.95,
          "maxOutputTokens": 1024,
        }
      };

      // Log request information (without the full image data)
      print('Sending request to Gemini API for food identification');

      // Make the API request
      final response = await http
          .post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      )
          .timeout(const Duration(seconds: 30), onTimeout: () {
        throw Exception('Gemini API request timed out after 30 seconds');
      });

      // Log response status
      print('Gemini API response status: ${response.statusCode}');

      // Parse the response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extract the text response from Gemini
        final text =
            data['candidates'][0]['content']['parts'][0]['text'] as String;
        print('Gemini identified: $text');

        // Process the comma-separated list
        final foodItems = text
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toList();

        return foodItems;
      } else {
        // Handle error responses
        print('Gemini API error: ${response.body}');
        throw Exception(
            'Failed to analyze image with Gemini API: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in identifyFoodInImage: $e');
      throw Exception('Failed to identify food with Gemini API: $e');
    }
  }

  /// Test the Gemini API connection with a simple text prompt
  Future<String> testConnection() async {
    await _ensureInitialized();

    try {
      // API endpoint for Gemini Pro (text-only model)
      final endpoint =
          '$_baseUrl/models/gemini-pro:generateContent?key=$_apiKey';

      // Simple test request
      final payload = {
        "contents": [
          {
            "parts": [
              {"text": "Hello, can you please list 3 healthy foods?"}
            ]
          }
        ]
      };

      // Make the request
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      return "Status: ${response.statusCode}\nResponse: ${response.body.substring(0, 200)}...";
    } catch (e) {
      return "Test failed: $e";
    }
  }
}
