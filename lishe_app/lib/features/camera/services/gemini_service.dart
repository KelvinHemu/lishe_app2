import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// GeminiService handles interactions with Google's Gemini API for image analysis
class GeminiService {
  static GeminiService? _instance;
  late String _apiKey;
  bool _isInitialized = false;

  // Rate limiting properties
  static const int _maxRequestsPerMinute = 10;
  final List<DateTime> _requestTimestamps = [];
  int _rateLimitedExceptions = 0;

  // Retry settings
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);

  // Image size constraints for optimal API performance
  static const int _maxImageWidth = 1024;
  static const int _maxImageHeight = 1024;
  static const int _maxImageSizeBytes = 3500000; // ~3.5MB safety margin

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

  /// Check rate limit and throw exception if exceeded
  Future<void> _checkRateLimit() async {
    final now = DateTime.now();

    // Remove timestamps older than 1 minute
    _requestTimestamps
        .removeWhere((timestamp) => now.difference(timestamp).inMinutes >= 1);

    if (_requestTimestamps.length >= _maxRequestsPerMinute) {
      _rateLimitedExceptions++;
      throw Exception(
          'Rate limit exceeded. Maximum $_maxRequestsPerMinute requests per minute allowed.');
    }

    // Add current timestamp
    _requestTimestamps.add(now);
  }

  /// Make an HTTP request with retry logic
  Future<http.Response> _makeRequestWithRetry(
    String endpoint,
    Map<String, String> headers,
    String body,
  ) async {
    int retryCount = 0;
    while (true) {
      try {
        final response = await http
            .post(
              Uri.parse(endpoint),
              headers: headers,
              body: body,
            )
            .timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          return response;
        }

        // If we get a 429 (Too Many Requests) or 503 (Service Unavailable), retry
        if ((response.statusCode == 429 || response.statusCode == 503) &&
            retryCount < _maxRetries) {
          retryCount++;
          print('Retrying request (attempt $retryCount of $_maxRetries)');
          await Future.delayed(_retryDelay);
          continue;
        }

        return response;
      } catch (e) {
        if (e is SocketException || e is TimeoutException) {
          if (retryCount < _maxRetries) {
            retryCount++;
            print(
                'Connection error, retrying (attempt $retryCount of $_maxRetries)');
            await Future.delayed(_retryDelay);
            continue;
          }
        }
        rethrow;
      }
    }
  }

  /// Optimize an image file for API processing
  /// Returns pure base64 string (no data URI prefix)
  Future<String> _optimizeImageFile(File imageFile) async {
    try {
      // Get file size
      final fileSize = await imageFile.length();

      // If file is already small enough, just convert to base64
      if (fileSize < _maxImageSizeBytes) {
        final bytes = await imageFile.readAsBytes();
        print('Image already optimized, size: ${bytes.length} bytes');
        // Return pure base64 without data URI prefix
        return base64Encode(bytes);
      }

      print('Resizing image, original size: $fileSize bytes');

      // Create temp file for compressed image
      final dir = await getTemporaryDirectory();
      final targetPath =
          path.join(dir.path, 'resized_${path.basename(imageFile.path)}');

      // Determine if the image is PNG or JPEG
      final extension = path.extension(imageFile.path).toLowerCase();
      final format =
          extension == '.png' ? CompressFormat.png : CompressFormat.jpeg;

      // Compress the image with quality adjustment and size constraints
      final result = await FlutterImageCompress.compressAndGetFile(
        imageFile.path,
        targetPath,
        quality: 85, // Good balance of quality and size
        minWidth: 800, // Minimum width to maintain decent quality
        minHeight: 800,
        format: format,
      );

      if (result == null) {
        throw Exception('Failed to compress image');
      }

      // Read the compressed image
      final compressedBytes = await result.readAsBytes();
      final compressedSize = compressedBytes.length;
      print('Compressed image size: $compressedSize bytes');

      // If still too large, reduce quality further
      if (compressedSize > _maxImageSizeBytes) {
        print('Image still too large, applying additional compression');

        // Create new temp file with lower quality
        final lowerQualityPath = path.join(
            dir.path, 'lower_quality_${path.basename(imageFile.path)}');

        final lowerQualityResult =
            await FlutterImageCompress.compressAndGetFile(
          targetPath,
          lowerQualityPath,
          quality: 65, // Lower quality for very large images
          minWidth: 600,
          minHeight: 600,
          format: format,
        );

        if (lowerQualityResult == null) {
          throw Exception('Failed to compress image at lower quality');
        }

        final finalBytes = await lowerQualityResult.readAsBytes();
        print('Final compressed image size: ${finalBytes.length} bytes');

        // Return pure base64 without data URI prefix
        return base64Encode(finalBytes);
      }

      // Return pure base64 without data URI prefix
      return base64Encode(compressedBytes);
    } catch (e) {
      print('Error optimizing image: $e');
      // Fallback to original image if optimization fails
      final bytes = await imageFile.readAsBytes();
      return base64Encode(bytes);
    }
  }

  /// Process an existing base64 image string
  Future<String> _optimizeBase64Image(String base64Image) async {
    try {
      // Remove data URI prefix if present
      String cleanBase64 = base64Image;
      if (base64Image.contains(';base64,')) {
        cleanBase64 = base64Image.split(';base64,')[1];
      }

      // Check if we need to optimize
      if (cleanBase64.length <= _maxImageSizeBytes) {
        return cleanBase64;
      }

      print('Optimizing large base64 image: ${cleanBase64.length} bytes');

      // Decode base64 to bytes
      final bytes = base64Decode(cleanBase64);

      // Create a temporary file
      final dir = await getTemporaryDirectory();
      final tempFilePath = path.join(dir.path, 'temp_for_resize.jpg');
      final tempFile = File(tempFilePath);
      await tempFile.writeAsBytes(bytes);

      // Determine image format
      CompressFormat format = CompressFormat.jpeg;
      if (cleanBase64.startsWith('iVBOR')) {
        // It's likely a PNG
        format = CompressFormat.png;
      }

      // Optimize the temporary file
      return await _optimizeImageFile(tempFile);
    } catch (e) {
      print('Error optimizing base64 image: $e');
      // If optimization fails, truncate as fallback (not ideal but better than failing)
      if (base64Image.length > 4000000) {
        print('Falling back to truncation for base64 image');
        // Remove data URI prefix if present
        if (base64Image.contains(';base64,')) {
          String cleanBase64 = base64Image.split(';base64,')[1];
          return cleanBase64.substring(0, 4000000);
        }
        return base64Image.substring(0, 4000000);
      }
      return base64Image;
    }
  }

  /// Identify food in a base64 encoded image using Gemini Vision API
  Future<List<String>> identifyFoodInImage(String base64Image) async {
    await _ensureInitialized();
    await _checkRateLimit();
    _logRequest();

    try {
      // Determine the image format (default to JPEG if unsure)
      String mimeType = "image/jpeg";
      if (base64Image.length > 100) {
        // Try to detect PNG signature in base64 data
        final prefix = base64Image.substring(0, 10);
        if (prefix.contains('iVBORw0K')) {
          mimeType = "image/png";
        }
      }

      // The API endpoint for Gemini Vision
      final endpoint =
          '$_baseUrl/models/gemini-1.5-flash:generateContent?key=$_apiKey';

      // Construct the payload following Gemini API documentation exactly
      final payload = {
        "contents": [
          {
            "parts": [
              {
                "text":
                    "Analyze this image and identify the food items. For each food item, provide only the name without descriptions. Output each food name on a separate line."
              },
              {
                "inline_data": {"mime_type": mimeType, "data": base64Image}
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.1,
          "topK": 32,
          "topP": 0.95,
          "maxOutputTokens": 1024,
        }
      };

      // Log request details for debugging (partial info only)
      print('Sending request to Gemini Vision API');
      print('Endpoint: $endpoint');
      print('MIME type: $mimeType');
      print('Image data size: ${base64Image.length} bytes');
      print('Using API key: ${_apiKey.substring(0, 5)}...');

      // Make the request with retry logic
      final response = await _makeRequestWithRetry(
        endpoint,
        {
          'Content-Type': 'application/json',
        },
        json.encode(payload),
      );

      // Log response status
      print('Response status code: ${response.statusCode}');

      // Log partial response for debugging
      if (response.body.length > 300) {
        print('Response preview: ${response.body.substring(0, 300)}...');
      } else {
        print('Response: ${response.body}');
      }

      // Handle successful response
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Extract the text from the response
        final text =
            data['candidates'][0]['content']['parts'][0]['text'] as String;
        print('Identified food text: $text');

        // Parse the text into a list of food items
        final foods = text
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .map((line) => line.trim())
            .toList();

        print('Identified ${foods.length} food items: $foods');
        return foods;
      } else {
        // Try to extract detailed error message
        try {
          final errorData = json.decode(response.body);
          final errorMessage =
              errorData['error']?['message'] ?? 'Unknown error';
          final errorCode = errorData['error']?['code'] ?? response.statusCode;
          print('API Error: $errorCode - $errorMessage');
          throw Exception('API Error $errorCode: $errorMessage');
        } catch (parseError) {
          print('Failed to parse error response: $parseError');
          throw Exception('API Error ${response.statusCode}: ${response.body}');
        }
      }
    } catch (e) {
      print('Error in identifyFoodInImage: $e');
      _rateLimitedExceptions++;
      rethrow;
    }
  }

  /// Identify food in an image file directly
  Future<List<String>> identifyFoodInImageFile(File imageFile) async {
    try {
      // Optimize the image file
      final base64Image = await _optimizeImageFile(imageFile);

      print('Processing image file: ${imageFile.path}');
      print('Image size after optimization: ${base64Image.length} bytes');

      // Use the optimized base64 string
      return await identifyFoodInImage(base64Image);
    } catch (e, stackTrace) {
      print('Error in identifyFoodInImageFile: $e');
      print(stackTrace);
      throw Exception('Failed to process image file: $e');
    }
  }

  /// Test the Gemini API connection with a simple text prompt
  Future<String> testConnection() async {
    await _ensureInitialized();

    try {
      // API endpoint for Gemini Pro (text-only model)
      final endpoint =
          '$_baseUrl/models/gemini-pro:generateContent?key=$_apiKey';

      // Simple test request using the EXACT format from Gemini docs
      final payload = {
        "contents": [
          {
            "parts": [
              {"text": "Hello, can you please list 3 healthy foods?"}
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.2,
          "topK": 32,
          "topP": 0.95,
          "maxOutputTokens": 256,
        }
      };

      print('Sending test request to Gemini API');
      print('Request endpoint: $endpoint');
      print('Using API key: ${_apiKey.substring(0, 5)}...');

      // Make the request
      final response = await http
          .post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      )
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Gemini API test request timed out after 10 seconds');
      });

      print('Response status code: ${response.statusCode}');

      // Partially log response
      if (response.body.length > 300) {
        print('Response preview: ${response.body.substring(0, 300)}...');
      } else {
        print('Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final text =
            data['candidates'][0]['content']['parts'][0]['text'] as String;
        return "✅ Connection successful!\nStatus: ${response.statusCode}\nResponse: $text";
      } else {
        // Try to extract detailed error message
        try {
          final errorData = json.decode(response.body);
          final errorMessage =
              errorData['error']?['message'] ?? 'Unknown error';
          final errorCode = errorData['error']?['code'] ?? response.statusCode;

          return "❌ API Error: $errorCode\nMessage: $errorMessage";
        } catch (parseError) {
          return "❌ API Error: ${response.statusCode}\nResponse: ${response.body.substring(0, math.min(200, response.body.length))}...";
        }
      }
    } catch (e) {
      return "❌ Test failed: $e";
    }
  }

  /// Get current rate limit status
  Map<String, dynamic> getRateLimitStatus() {
    final requestsInLastMinute = _requestTimestamps.length;
    final remainingRequests = _maxRequestsPerMinute - requestsInLastMinute;

    return {
      'maxRequestsPerMinute': _maxRequestsPerMinute,
      'requestsInLastMinute': requestsInLastMinute,
      'remainingRequests': remainingRequests,
      'rateLimitExceptions': _rateLimitedExceptions,
    };
  }

  /// Track request for rate limiting
  void _logRequest() {
    final now = DateTime.now();
    _requestTimestamps.add(now);

    // Clean up old timestamps (older than 1 minute)
    _requestTimestamps
        .removeWhere((timestamp) => now.difference(timestamp).inMinutes > 1);

    print(
        'Request added to rate limit tracker. Current count: ${_requestTimestamps.length}');
  }
}
