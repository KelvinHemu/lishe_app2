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

final cameraProvider =
    StateNotifierProvider<CameraNotifier, AsyncValue<List<FoodItem>>>((ref) {
  return CameraNotifier(FatSecretService());
});

class CameraNotifier extends StateNotifier<AsyncValue<List<FoodItem>>> {
  final FatSecretService _fatSecretService;
  CameraController? _controller;
  bool _isInitialized = false;
  double _currentZoom = 1.0;
  FlashMode _flashMode = FlashMode.off;

  // Min and max zoom levels
  final double _minZoom = 1.0;
  final double _maxZoom = 4.0;

  CameraNotifier(this._fatSecretService) : super(const AsyncValue.data([])) {
    _initializeFatSecret();
  }

  // Getters
  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;
  double get currentZoom => _currentZoom;
  FlashMode get flashMode => _flashMode;

  Future<void> _initializeFatSecret() async {
    try {
      // We'll properly initialize the service here, but our service now auto-initializes as needed
      await _fatSecretService.initialize();
      print('FatSecret service initialized successfully');
    } catch (e) {
      print('Warning: Failed to initialize FatSecret service: $e');
      // We don't set an error state here since the service will auto-initialize later
      // This prevents early errors before the user has even taken a photo
    }
  }

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
        print('Error capturing picture: $captureError');

        // Handle camera channel errors specifically
        if (captureError.toString().contains('channel-error') ||
            captureError
                .toString()
                .contains('Unable to establish connection')) {
          print('Camera channel error detected - attempting recovery');

          // Try to release and reinitialize the camera
          try {
            await _controller?.dispose();
            _controller = null;
            _isInitialized = false;

            // Short delay to allow camera resources to be released
            await Future.delayed(const Duration(milliseconds: 500));

            // Reinitialize the camera
            await initializeCamera();

            // If we successfully reinitialized, show a helpful message instead of error
            state = AsyncValue.error(
                'Camera connection was reset. Please try again.',
                StackTrace.current);
            return;
          } catch (recoveryError) {
            print(
                'Failed to recover from camera channel error: $recoveryError');
            state = AsyncValue.error(
                'Camera connection issue: Please restart the app',
                StackTrace.current);
            return;
          }
        }

        state = AsyncValue.error(
            'Failed to capture photo: $captureError', StackTrace.current);
        return;
      }

      // Reset flash mode if it was torch
      if (currentFlashMode == FlashMode.torch) {
        await _controller!.setFlashMode(currentFlashMode);
      }

      // Create a File object from the XFile path
      final imageFile = File(pictureTaken.path);

      // Verify the file exists before proceeding
      if (!await imageFile.exists()) {
        print('Error: Image file not found at path: ${pictureTaken.path}');

        // Try to create a new temporary file
        try {
          final tempDir = Directory.systemTemp;
          if (await tempDir.exists()) {
            final altImagePath =
                '${tempDir.path}/temp_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
            final altFile = File(altImagePath);

            // Try to copy the XFile data to our new file
            final byteData = await pictureTaken.readAsBytes();
            if (byteData.isNotEmpty) {
              await altFile.writeAsBytes(byteData);
              print('Created alternative image file at: ${altFile.path}');

              if (await altFile.exists()) {
                // Use the alternative file
                await _processImage(altFile);
                return;
              }
            }
          }
        } catch (altError) {
          print('Error creating alternative file: $altError');
        }

        // If we got here, both attempts failed
        state = AsyncValue.error(
            'Image file not found after capture', StackTrace.current);
        return;
      }

      // Check file size
      final fileSize = await imageFile.length();
      print('Captured image file size: $fileSize bytes');

      if (fileSize <= 0) {
        print('Error: Empty image file at path: ${pictureTaken.path}');
        state = AsyncValue.error(
            'Captured image file is empty', StackTrace.current);
        return;
      }

      await _processImage(imageFile);
    } catch (e) {
      print('Exception in takePhoto: $e');
      state = AsyncValue.error('Failed to take photo: $e', StackTrace.current);
    }
  }

  // Process captured image
  Future<void> _processImage(File imageFile) async {
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

      try {
        final foods = await _fatSecretService.searchFoodByImage(base64Image);
        state = AsyncValue.data(foods);
      } catch (e) {
        print('Error calling FatSecret API: $e');
        if (e.toString().contains('has not been initialized')) {
          // Try to reinitialize and retry
          print('Attempting to reinitialize FatSecret service...');
          await _fatSecretService.initialize();
          // Retry the call
          final foods = await _fatSecretService.searchFoodByImage(base64Image);
          state = AsyncValue.data(foods);
        } else {
          // Other API errors
          state = AsyncValue.error(
              'Failed to analyze image: $e', StackTrace.current);
        }
      }
    } catch (e) {
      print('Error in _processImage: $e');
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

      await _processImage(file);
    } catch (e) {
      print('Error processing gallery image: $e');
      state = AsyncValue.error(
          'Failed to process gallery image: $e', StackTrace.current);
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

  // Diagnostic method to test FatSecret API connection
  Future<String> testFatSecretConnection() async {
    try {
      final result = StringBuffer();

      result.writeln('Testing FatSecret connection...');

      // Step 1: Test API key availability
      result.writeln('\n--- Step 1: Checking API keys ---');
      try {
        await _fatSecretService.initialize();
        final keyInfo = await _fatSecretService.getApiKeyInfo();
        result.writeln('API Keys: $keyInfo');
      } catch (e) {
        result.writeln('Failed to verify API keys: $e');
        return result.toString();
      }

      // Step 2: Test basic search
      result.writeln('\n--- Step 2: Testing simple food search ---');
      try {
        final testResult = await _fatSecretService.testApiCall();
        result.writeln('Basic search result: $testResult');
      } catch (e) {
        result.writeln('Failed basic search: $e');
      }

      // Step 3: Test image recognition with a test image
      result.writeln('\n--- Step 3: Testing image recognition ---');
      try {
        // Create a very simple test image (small white square)
        const testBase64 =
            'iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAIAAAACUFjqAAAAEUlEQVQY02NgGAWjYBSMAggAAAQQAAGFP6pyAAAAAElFTkSuQmCC';
        final testResult =
            await _fatSecretService.testImageRecognition(testBase64);
        result.writeln('Image recognition test: $testResult');
      } catch (e) {
        result.writeln('Failed image recognition test: $e');
      }

      result.writeln('\nDiagnostic test completed');
      return result.toString();
    } catch (e) {
      return 'Error running diagnostics: $e';
    }
  }

  // Process a default test image (bypasses camera completely)
  Future<void> processTestImage() async {
    try {
      state = const AsyncValue.loading();

      print('Processing predefined test image...');

      // Use a simple test image (this is a small black and white test pattern)
      const sampleBase64 =
          'iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAIAAAAC64paAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5QwFCgUYBRVFkgAAAB1pVFh0Q29tbWVudAAAAAAAQ3JlYXRlZCB3aXRoIEdJTVBkLmUHAAAAhUlEQVQ4y+2TwQ2AIAxFfw0DsYDO4EQO5EwO5CBexAWsF5RDoVr1IIme2rz8vDZpkVL6hHl6oSz53XT4BGMMC44hWCtZEKtLjuGiJoCqVtYcw02dADhfPt9wUicA2c6WhvM6g9SrZUgw5/gkAxLlJMthX3BcowDh2oR6yL7gHIeYf/iFXDR0Ud/eTwQ1pQAAAABJRU5ErkJggg==';

      // Test image recognition
      try {
        final foods = await _fatSecretService.searchFoodByImage(sampleBase64);
        state = AsyncValue.data(foods);

        if (foods.isEmpty) {
          print('No foods found in test image');
        } else {
          print('Found ${foods.length} foods in test image');
        }
      } catch (e) {
        print('Error analyzing test image: $e');
        state = AsyncValue.error(
            'Failed to analyze test image: $e', StackTrace.current);
      }
    } catch (e) {
      print('Error in processTestImage: $e');
      state = AsyncValue.error(
          'Error processing test image: $e', StackTrace.current);
    }
  }
}
