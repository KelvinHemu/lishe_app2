import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'dart:io';

// Camera state class
class CameraState {
  final CameraController? controller;
  final List<CameraDescription>? cameras;
  final File? imageFile;
  final bool isLoading;
  final bool foodDetected;
  final double currentZoom;
  final String? errorMessage;
  final bool showingPreview;

  CameraState({
    this.controller,
    this.cameras,
    this.imageFile,
    this.isLoading = false,
    this.foodDetected = false,
    this.currentZoom = 1.0,
    this.errorMessage,
    this.showingPreview = false,
  });

  // Make sure copyWith handles all properties correctly
  CameraState copyWith({
    CameraController? controller,
    List<CameraDescription>? cameras,
    File? imageFile,
    bool? isLoading,
    bool? foodDetected,
    double? currentZoom,
    String? errorMessage,
    bool? showingPreview,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      cameras: cameras ?? this.cameras,
      imageFile: imageFile ?? this.imageFile,
      isLoading: isLoading ?? this.isLoading,
      foodDetected: foodDetected ?? this.foodDetected,
      currentZoom: currentZoom ?? this.currentZoom,
      errorMessage: errorMessage, // Pass null to clear error
      showingPreview: showingPreview ?? this.showingPreview,
    );
  }
}

// Camera provider using StateNotifier
class CameraStateNotifier extends StateNotifier<CameraState> {
  CameraStateNotifier() : super(CameraState());

  final double _minZoom = 1.0;
  final double _maxZoom =
      4.0; // Changed from 5.0 to 4.0 to match device capabilities

  // Initialize camera
  Future<void> initialize() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      print('Getting available cameras...');
      final cameras = await availableCameras();
      print('Available cameras: ${cameras.length}');

      if (cameras.isNotEmpty) {
        print('Creating camera controller...');
        final controller = CameraController(
          cameras[0],
          ResolutionPreset.high,
          enableAudio: false,
        );

        print('Initializing camera controller...');
        await controller.initialize();
        print('Camera controller initialized successfully');

        // Set initial zoom level
        await controller.setZoomLevel(state.currentZoom);
        print('Zoom level set to ${state.currentZoom}');

        state = state.copyWith(cameras: cameras, controller: controller);
      } else {
        state = state.copyWith(
          errorMessage: 'No cameras available on this device',
        );
        print('No cameras available on this device');
      }
    } catch (e) {
      print('Error initializing camera: $e');
      if (e is CameraException) {
        print('Camera error code: ${e.code}');
        print('Camera error description: ${e.description}');
      }
      print('Stack trace: ${StackTrace.current}');

      state = state.copyWith(errorMessage: 'Failed to initialize camera: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Take photo
  Future<void> takePhoto() async {
    if (state.controller == null || !state.controller!.value.isInitialized) {
      state = state.copyWith(errorMessage: 'Camera is not initialized');
      return;
    }

    try {
      print('Taking photo...');
      final image = await state.controller!.takePicture();
      final capturedImage = File(image.path);

      print('Photo captured: ${capturedImage.path}');

      // Set the image file and show preview flag
      state = state.copyWith(
        imageFile: capturedImage,
        showingPreview: true, // Show the preview
      );
      print('State updated with image and showingPreview=true');
    } catch (e) {
      print('Error taking photo: $e');
      state = state.copyWith(errorMessage: 'Error taking photo: $e');
    }
  }

  // Adjust zoom
  Future<void> adjustZoom() async {
    if (state.controller == null || !state.controller!.value.isInitialized) {
      return;
    }

    try {
      // Get the actual min/max zoom supported by the device
      final minZoomLevel = await state.controller!.getMinZoomLevel();
      final maxZoomLevel = await state.controller!.getMaxZoomLevel();

      print('Device zoom range: $minZoomLevel to $maxZoomLevel');

      // Toggle between 1.0x, 2.0x, 3.0x, 4.0x, then back to 1.0x
      double nextZoom;

      // If at or exceeding max zoom (or device max), reset to min zoom
      if (state.currentZoom >= _maxZoom || state.currentZoom >= maxZoomLevel) {
        nextZoom = _minZoom;
        print('Resetting zoom to minimum: $nextZoom');
      } else {
        // Otherwise increase by 1.0, but don't exceed device max
        nextZoom = state.currentZoom + 1.0;
        if (nextZoom > maxZoomLevel) {
          nextZoom = maxZoomLevel;
        }
        print('Increasing zoom to: $nextZoom');
      }

      await state.controller!.setZoomLevel(nextZoom);
      state = state.copyWith(currentZoom: nextZoom);
      print('Zoom level updated to: $nextZoom');
    } catch (e) {
      print('Error adjusting zoom: $e');
      // In case of error, don't update the state
    }
  }

  // Clear captured image
  void clearImage() {
    print('Clearing image');
    state = state.copyWith(imageFile: null, showingPreview: false);
  }

  // Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  // Cancel photo preview and return to camera
  void cancelPreview() {
    print('Canceling preview');
    state = state.copyWith(showingPreview: false);
    // Keep imageFile as is in case you need it later
  }

  // Clear image and return to camera
  void retakePhoto() {
    print('Retaking photo');
    state = state.copyWith(imageFile: null, showingPreview: false);
  }

  // Process the image (call this when user confirms the photo)
  void confirmPhoto() {
    print('Processing photo: ${state.imageFile?.path}');
    // For now, just keep showing the preview with the image
    // Later you can add actual processing logic
  }

  // Process image from gallery
  void processGalleryImage(String imagePath) {
    print('Processing gallery image: $imagePath');
    final galleryImage = File(imagePath);

    // Set the image file and show preview flag
    state = state.copyWith(
      imageFile: galleryImage,
      showingPreview: true, // Show the preview
    );
    print('State updated with gallery image and showingPreview=true');
  }

  @override
  void dispose() {
    state.controller?.dispose();
    super.dispose();
  }
}

// Create a provider
final cameraProvider = StateNotifierProvider<CameraStateNotifier, CameraState>((
  ref,
) {
  return CameraStateNotifier();
});
