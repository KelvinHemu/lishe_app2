import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../models/food_item.dart';
import '../services/fatsecret_service.dart';
import '../services/gemini_service.dart';
import '../services/offline_storage_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final cameraProvider =
    StateNotifierProvider<CameraNotifier, AsyncValue<List<FoodItem>>>((ref) {
  return CameraNotifier(
    FatSecretService(),
    GeminiService(),
    OfflineStorageService(),
  );
});

class CameraNotifier extends StateNotifier<AsyncValue<List<FoodItem>>> {
  final FatSecretService _fatSecretService;
  final GeminiService _geminiService;
  final OfflineStorageService _offlineStorageService;
  CameraController? _controller;
  bool _isInitialized = false;
  double _currentZoom = 1.0;
  FlashMode _flashMode = FlashMode.off;

  // Min and max zoom levels
  final double _minZoom = 1.0;
  final double _maxZoom = 4.0;

  // For tracking pending offline tasks
  List<PendingImageTask>? _pendingTasks;

  CameraNotifier(
    this._fatSecretService,
    this._geminiService,
    this._offlineStorageService,
  ) : super(const AsyncValue.data([])) {
    _initializeServices();
    _checkPendingTasks();
  }

  // Getters
  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;
  double get currentZoom => _currentZoom;
  FlashMode get flashMode => _flashMode;
  List<PendingImageTask>? get pendingTasks => _pendingTasks;

  /// Initialize all services
  Future<void> _initializeServices() async {
    try {
      // Initialize FatSecret service
      try {
        await _fatSecretService.initialize();
        print('FatSecret service initialized successfully');
      } catch (e) {
        print('Warning: Failed to initialize FatSecret service: $e');
      }

      // Initialize Gemini service
      try {
        await _geminiService.initialize();
        print('Gemini service initialized successfully');
      } catch (e) {
        print('Warning: Failed to initialize Gemini service: $e');
      }
    } catch (e) {
      print('Error initializing services: $e');
    }
  }

  /// Check and load pending offline tasks
  Future<void> _checkPendingTasks() async {
    try {
      _pendingTasks = await _offlineStorageService.getPendingTasks();
      print('Found ${_pendingTasks?.length ?? 0} pending offline images');

      // If we have pending tasks and internet is available, process them
      if (_pendingTasks != null && _pendingTasks!.isNotEmpty) {
        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult != ConnectivityResult.none) {
          print('Internet connection available, processing pending images');
          _processPendingImages();
        }
      }
    } catch (e) {
      print('Error checking pending tasks: $e');
    }
  }

  /// Process all pending offline images
  Future<void> _processPendingImages() async {
    if (_pendingTasks == null || _pendingTasks!.isEmpty) return;

    print('Processing ${_pendingTasks!.length} pending images');

    // Sort tasks by timestamp (oldest first)
    _pendingTasks!.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    for (final task in List.from(_pendingTasks!)) {
      try {
        print('Processing offline image: ${task.id}');

        // Get the image file
        final imageFile = await _offlineStorageService.getImageFile(task.id);
        if (imageFile == null) {
          print('Image file not found, removing task: ${task.id}');
          await _offlineStorageService.removeTask(task.id);
          continue;
        }

        // Process the image using our regular flow
        await _processImageWithGemini(imageFile);

        // Remove the task once processed
        await _offlineStorageService.removeTask(task.id);

        // Update the pending tasks list
        _pendingTasks!.remove(task);
      } catch (e) {
        print('Error processing pending image ${task.id}: $e');
        // We'll keep the task in the list to try again later
      }
    }

    print(
        'Finished processing pending images. ${_pendingTasks!.length} remain');
  }

  // Initialize camera controller
  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        state = AsyncValue.error('No cameras found', StackTrace.current);
        return;
      }

      _controller = CameraController(
        cameras.first,
        ResolutionPreset.medium, // Use medium resolution to save memory
        enableAudio: false,
      );

      await _controller!.initialize();

      // Set initial zoom and flash mode
      try {
        await _controller!.setZoomLevel(_currentZoom);
        await _controller!.setFlashMode(_flashMode);
      } catch (e) {
        // Ignore errors with zoom/flash - they're not critical
        print('Warning: Could not set initial zoom/flash: $e');
      }

      _isInitialized = true;
      state = const AsyncValue.data([]);
    } catch (e) {
      state = AsyncValue.error(
          'Failed to initialize camera: $e', StackTrace.current);
      _isInitialized = false;
    }
  }

  // Simple method to truncate base64 string to a manageable size
  String _truncateBase64(String base64String, int maxLength) {
    if (base64String.length <= maxLength) {
      return base64String;
    }

    // Truncate and ensure the string is still valid base64
    // Base64 characters come in groups of 4, so truncate to a multiple of 4
    final truncatedLength = (maxLength ~/ 4) * 4;
    return base64String.substring(0, truncatedLength);
  }

  // Optimize the image for API transmission
  Future<String> _optimizeImage(File imageFile) async {
    try {
      print('Optimizing image at path: ${imageFile.path}');

      // Verify file exists and is readable before proceeding
      if (!await imageFile.exists()) {
        throw FileSystemException('File not found', imageFile.path);
      }

      // Maximum base64 string length (500KB worth of base64)
      const maxBase64Length = 500 * 1024;

      // Read the file bytes
      Uint8List bytes;
      try {
        bytes = await imageFile.readAsBytes();
        print('Successfully read image file: ${bytes.length} bytes');
      } catch (readError) {
        print('Error reading image file: $readError');
        throw FileSystemException('Failed to read file', imageFile.path);
      }

      if (bytes.isEmpty) {
        print('Error: Image file is empty');
        throw FileSystemException('Image file is empty', imageFile.path);
      }

      // If the image is already small enough, just return it
      final initialBase64 = base64Encode(bytes);
      if (initialBase64.length <= maxBase64Length) {
        print('Image already small enough: ${initialBase64.length} characters');
        return initialBase64;
      }

      print('Original image too large: ${initialBase64.length} characters');

      // Try using flutter_image_compress if available
      try {
        print('Attempting to compress image with flutter_image_compress');
        final compressedBytes = await FlutterImageCompress.compressWithFile(
          imageFile.absolute.path,
          quality: 70,
          minWidth: 800,
          minHeight: 800,
        );

        if (compressedBytes != null && compressedBytes.isNotEmpty) {
          final compressedBase64 = base64Encode(compressedBytes);
          print('Compressed image size: ${compressedBase64.length} characters');

          if (compressedBase64.length <= maxBase64Length) {
            return compressedBase64;
          }

          // If still too large, truncate
          print('Compressed image still too large, truncating');
          return _truncateBase64(compressedBase64, maxBase64Length);
        } else {
          print(
              'Compression returned empty result, falling back to truncation');
        }
      } catch (compressionError) {
        print('Error using FlutterImageCompress: $compressionError');
        // Continue to fallback method
      }

      // Fallback: just truncate the base64 string
      print('Using fallback: truncating base64 string');
      return _truncateBase64(initialBase64, maxBase64Length);
    } catch (e) {
      print('Error in _optimizeImage: $e');
      // Rethrow with more context rather than using a fallback
      // This will help identify the specific error
      throw Exception('Failed to optimize image: $e');
    }
  }

  // Take photo method (for backward compatibility with existing app)
  Future<void> takePhoto() async {
    if (!_isInitialized ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      state = AsyncValue.error('Camera not initialized', StackTrace.current);
      return;
    }

    try {
      state = const AsyncValue.loading();

      // Save current flash mode
      final currentFlashMode = _flashMode;

      // If using torch mode, switch to flash for photo
      if (currentFlashMode == FlashMode.torch) {
        await _controller!.setFlashMode(FlashMode.always);
      }

      // Take the picture with channel error handling
      XFile? pictureTaken;
      try {
        pictureTaken = await _controller!.takePicture();
        print('Picture taken at path: ${pictureTaken.path}');
      } catch (captureError) {
        print('Error taking picture: $captureError');
        state = AsyncValue.error(
            'Failed to take photo: $captureError', StackTrace.current);
        return;
      }

      // Restore flash mode if we changed it
      if (currentFlashMode == FlashMode.torch) {
        await _controller!.setFlashMode(FlashMode.torch);
      }

      // Create a File object from the XFile
      final imageFile = File(pictureTaken.path);

      // Check for connectivity before processing
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        print('No internet connection, saving image for later processing');
        await _saveImageForLaterProcessing(imageFile);
        state = const AsyncValue.data([]);
        return;
      }

      // Process the image with Gemini
      await _processImageWithGemini(imageFile);
    } catch (e) {
      print('Error in takePhoto: $e');
      state =
          AsyncValue.error('Failed to process photo: $e', StackTrace.current);
    }
  }

  /// Save image for later processing when offline
  Future<void> _saveImageForLaterProcessing(File imageFile) async {
    try {
      final task =
          await _offlineStorageService.saveImageForLaterProcessing(imageFile);

      // Update the pending tasks list
      if (_pendingTasks == null) {
        _pendingTasks = [task];
      } else {
        _pendingTasks!.add(task);
      }

      print('Image saved for later processing (ID: ${task.id})');
    } catch (e) {
      print('Error saving image for later: $e');
      state = AsyncValue.error(
          'Failed to save image for later: $e', StackTrace.current);
    }
  }

  /// Process image with Gemini API for food identification
  Future<void> _processImageWithGemini(File imageFile) async {
    try {
      // Verify the image file exists
      if (!await imageFile.exists()) {
        print('Error: Image file does not exist at path: ${imageFile.path}');
        state = AsyncValue.error('Image file not found', StackTrace.current);
        return;
      }

      // Check file size and permissions
      try {
        final fileSize = await imageFile.length();
        print(
            'Processing image file size: $fileSize bytes at path: ${imageFile.path}');

        if (fileSize <= 0) {
          print('Error: Empty image file');
          state = AsyncValue.error('Image file is empty', StackTrace.current);
          return;
        }

        // Test file read access
        await imageFile.readAsBytes();
      } catch (fileError) {
        print('Error accessing image file: $fileError');
        state = AsyncValue.error(
            'Cannot access image file: $fileError', StackTrace.current);
        return;
      }

      // Optimize the image for API transmission
      String base64Image;
      try {
        base64Image = await _optimizeImage(imageFile);
        print(
            'Successfully converted image to base64: ${base64Image.length} characters');
      } catch (optimizeError) {
        print('Error optimizing image: $optimizeError');
        state = AsyncValue.error(
            'Failed to optimize image: $optimizeError', StackTrace.current);
        return;
      }

      // Log image size for debugging
      print('Sending image with ${base64Image.length} base64 characters');

      // Step 1: Send image to Gemini for food identification
      try {
        // Use Gemini API to identify food items in the image
        final foodNames = await _geminiService.identifyFoodInImage(base64Image);

        if (foodNames.isEmpty) {
          print('No food items identified in the image by Gemini');
          state = AsyncValue.error(
              'No food items could be identified in this image',
              StackTrace.current);
          return;
        }

        print('Gemini identified food items: ${foodNames.join(", ")}');

        // Step 2: Get nutritional information for each identified food
        final List<FoodItem> foodItems = [];
        final List<String> failedItems = [];

        for (final foodName in foodNames) {
          try {
            // Use the food name to get nutritional information
            final searchResults =
                await _fatSecretService.searchFoodByName(foodName);
            if (searchResults.isNotEmpty) {
              foodItems.add(searchResults.first);
            } else {
              failedItems.add(foodName);
            }
          } catch (e) {
            print('Error getting nutrition for $foodName: $e');
            failedItems.add(foodName);
          }
        }

        if (foodItems.isEmpty) {
          state = AsyncValue.error(
              'Could not retrieve nutritional information for the identified food items',
              StackTrace.current);
          return;
        }

        // If we got some items but not all, add a log
        if (failedItems.isNotEmpty) {
          print('Failed to get nutrition for: ${failedItems.join(", ")}');
        }

        // Update state with the food items
        state = AsyncValue.data(foodItems);
      } catch (e) {
        print('Error in Gemini food identification: $e');
        state =
            AsyncValue.error('Failed to analyze image: $e', StackTrace.current);
      }
    } catch (e) {
      print('Error in _processImageWithGemini: $e');
      state =
          AsyncValue.error('Failed to analyze image: $e', StackTrace.current);
    }
  }

  // Process image from gallery
  Future<void> processGalleryImage(String imagePath) async {
    try {
      state = const AsyncValue.loading();
      final file = File(imagePath);

      // Verify image from gallery exists
      if (!await file.exists()) {
        print('Error: Gallery image not found at path: $imagePath');
        state = AsyncValue.error(
            'Gallery image file not found', StackTrace.current);
        return;
      }

      // Check for connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        print(
            'No internet connection, saving gallery image for later processing');
        await _saveImageForLaterProcessing(file);
        state = const AsyncValue.data([]);
        return;
      }

      await _processImageWithGemini(file);
    } catch (e) {
      print('Error processing gallery image: $e');
      state = AsyncValue.error(
          'Failed to process gallery image: $e', StackTrace.current);
    }
  }

  /// Check connectivity and process pending images if online
  Future<void> checkConnectivityAndProcessPending() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        // We have internet, process any pending images
        await _processPendingImages();
      }
    } catch (e) {
      print('Error checking connectivity: $e');
    }
  }

  // Existing method - kept for backward compatibility
  Future<void> captureAndAnalyzeImage() async {
    await takePhoto();
  }

  Future<void> getFoodDetails(String foodId) async {
    try {
      state = const AsyncValue.loading();
      final foodDetails = await _fatSecretService.getFoodDetails(foodId);
      state = AsyncValue.data([foodDetails]);
    } catch (e) {
      state = AsyncValue.error(
          'Failed to get food details: $e', StackTrace.current);
    }
  }

  // Toggle flash mode
  Future<void> toggleFlash() async {
    if (!_isInitialized ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      return;
    }

    try {
      FlashMode newMode;

      // Cycle through flash modes: off -> auto -> torch -> off
      if (_flashMode == FlashMode.off) {
        newMode = FlashMode.auto;
      } else if (_flashMode == FlashMode.auto) {
        newMode = FlashMode.torch;
      } else {
        newMode = FlashMode.off;
      }

      await _controller!.setFlashMode(newMode);
      _flashMode = newMode;
    } catch (e) {
      print('Error toggling flash: $e');
    }
  }

  // Adjust zoom level
  Future<void> adjustZoom() async {
    if (!_isInitialized ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      return;
    }

    try {
      // Get device min/max zoom levels
      final minZoomLevel = await _controller!.getMinZoomLevel();
      final maxZoomLevel = await _controller!.getMaxZoomLevel();

      // Calculate next zoom level (toggle between 1.0x, 2.0x, 3.0x, 4.0x)
      double nextZoom;

      // If at max zoom, reset to min
      if (_currentZoom >= _maxZoom || _currentZoom >= maxZoomLevel) {
        nextZoom = _minZoom;
      } else {
        // Increase by 1.0 but don't exceed device max
        nextZoom = _currentZoom + 1.0;
        if (nextZoom > maxZoomLevel) {
          nextZoom = maxZoomLevel;
        }
      }

      await _controller!.setZoomLevel(nextZoom);
      _currentZoom = nextZoom;
    } catch (e) {
      print('Error adjusting zoom: $e');
    }
  }

  // Clear any error state and reset to an empty list
  void clearError() {
    state = const AsyncValue.data([]);
  }

  // Dispose camera resources but keep the notifier alive
  void disposeCamera() {
    try {
      print('Explicitly disposing camera controller');
      _controller?.dispose();
      _controller = null;
      _isInitialized = false;
    } catch (e) {
      print('Error disposing camera: $e');
    }
  }

  @override
  void dispose() {
    disposeCamera();
    super.dispose();
  }

  // Diagnostic method to test API connection
  Future<String> runDiagnostics() async {
    try {
      final result = StringBuffer();

      result.writeln('Running complete API diagnostics...');

      // Step 1: Test FatSecret API key availability
      result.writeln('\n--- Step 1: Checking FatSecret API keys ---');
      try {
        await _fatSecretService.initialize();
        final keyInfo = await _fatSecretService.getApiKeyInfo();
        result.writeln('FatSecret API Keys: $keyInfo');
      } catch (e) {
        result.writeln('Failed to verify FatSecret API keys: $e');
      }

      // Step 2: Test Gemini API key availability
      result.writeln('\n--- Step 2: Checking Gemini API key ---');
      try {
        await _geminiService.initialize();
        result.writeln('Gemini API key loaded successfully');
      } catch (e) {
        result.writeln('Failed to verify Gemini API key: $e');
      }

      // Step 3: Test Gemini API connection
      result.writeln('\n--- Step 3: Testing Gemini API connection ---');
      try {
        final testResult = await _geminiService.testConnection();
        result.writeln('Gemini test result: $testResult');
      } catch (e) {
        result.writeln('Failed Gemini connection test: $e');
      }

      // Step 4: Test FatSecret basic search
      result.writeln('\n--- Step 4: Testing FatSecret food search ---');
      try {
        final testResult = await _fatSecretService.testApiCall();
        result.writeln('FatSecret search result: $testResult');
      } catch (e) {
        result.writeln('Failed FatSecret search: $e');
      }

      // Step 5: Check offline storage
      result.writeln('\n--- Step 5: Checking offline storage ---');
      try {
        final pendingTasks = await _offlineStorageService.getPendingTasks();
        result.writeln('Pending offline tasks: ${pendingTasks.length}');
        if (pendingTasks.isNotEmpty) {
          result.writeln('Oldest task from: ${pendingTasks.first.timestamp}');
        }
      } catch (e) {
        result.writeln('Failed to check offline storage: $e');
      }

      result.writeln('\nDiagnostic test completed');
      return result.toString();
    } catch (e) {
      return 'Error running diagnostics: $e';
    }
  }

  // Test methods for debugging - kept for development and testing
  Future<void> processTestImage() async {
    try {
      state = const AsyncValue.loading();
      print('Processing predefined test image...');

      // Use a simple test image (this is a small black and white test pattern)
      const sampleBase64 =
          'iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAIAAAAC64paAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5QwFCgUYBRVFkgAAAB1pVFh0Q29tbWVudAAAAAAAQ3JlYXRlZCB3aXRoIEdJTVBkLmUHAAAAhUlEQVQ4y+2TwQ2AIAxFfw0DsYDO4EQO5EwO5CBexAWsF5RDoVr1IIme2rz8vDZpkVL6hHl6oSz53XT4BGMMC44hWCtZEKtLjuGiJoCqVtYcw02dADhfPt9wUicA2c6WhvM6g9SrZUgw5/gkAxLlJMthX3BcowDh2oR6yL7gHIeYf/iFXDR0Ud/eTwQ1pQAAAABJRU5ErkJggg==';

      try {
        // Try Gemini for food identification
        final foodNames =
            await _geminiService.identifyFoodInImage(sampleBase64);
        print('Gemini test result - identified foods: ${foodNames.join(", ")}');

        if (foodNames.isNotEmpty) {
          // Get nutrition info for the first item
          final foods =
              await _fatSecretService.searchFoodByName(foodNames.first);
          if (foods.isNotEmpty) {
            state = AsyncValue.data(foods);
          } else {
            state = AsyncValue.error(
                'No nutrition data found for test image', StackTrace.current);
          }
        } else {
          state = AsyncValue.error(
              'No foods identified in test image', StackTrace.current);
        }
      } catch (e) {
        print('Error in test image analysis: $e');
        state = AsyncValue.error(
            'Failed to analyze test image: $e', StackTrace.current);
      }
    } catch (e) {
      print('Error in processTestImage: $e');
      state = AsyncValue.error(
          'Error processing test image: $e', StackTrace.current);
    }
  }

  /// Process a simple test image to verify API connectivity
  Future<void> processSimpleTestImage() async {
    try {
      state = const AsyncValue.loading();
      print('Processing minimal test image to verify API connectivity');

      // Create a very small test image (just a few pixels)
      final Uint8List miniTestImage = Uint8List.fromList([
        0x89,
        0x50,
        0x4E,
        0x47,
        0x0D,
        0x0A,
        0x1A,
        0x0A,
        0x00,
        0x00,
        0x00,
        0x0D,
        0x49,
        0x48,
        0x44,
        0x52,
        0x00,
        0x00,
        0x00,
        0x01,
        0x00,
        0x00,
        0x00,
        0x01,
        0x08,
        0x02,
        0x00,
        0x00,
        0x00,
        0x90,
        0x77,
        0x53,
        0xDE,
        0x00,
        0x00,
        0x00,
        0x0C,
        0x49,
        0x44,
        0x41,
        0x54,
        0x08,
        0xD7,
        0x63,
        0xF8,
        0xFF,
        0xFF,
        0x3F,
        0x00,
        0x05,
        0xFE,
        0x02,
        0xFE,
        0xDC,
        0xCC,
        0x59,
        0xE7,
        0x00,
        0x00,
        0x00,
        0x00,
        0x49,
        0x45,
        0x4E,
        0x44,
        0xAE,
        0x42,
        0x60,
        0x82
      ]); // This is a 1x1 pixel PNG

      // Convert to base64
      final String base64Image = base64Encode(miniTestImage);
      print('Mini test image base64 length: ${base64Image.length}');

      // Test the Gemini service
      try {
        final geminiResult = await _geminiService.testConnection();
        print('Gemini API test result: $geminiResult');

        state = const AsyncValue.data([]);
      } catch (e) {
        print('Error in API test: $e');
        state = AsyncValue.error('API test failed: $e', StackTrace.current);
      }
    } catch (e, stackTrace) {
      print('Error in processSimpleTestImage: $e');
      state = AsyncValue.error(e.toString(), stackTrace);
    }
  }
}
