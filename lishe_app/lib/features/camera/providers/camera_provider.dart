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

  CameraState({
    this.controller,
    this.cameras,
    this.imageFile,
    this.isLoading = false,
    this.foodDetected = false,
    this.currentZoom = 1.0,
    this.errorMessage,
  });

  CameraState copyWith({
    CameraController? controller,
    List<CameraDescription>? cameras,
    File? imageFile,
    bool? isLoading,
    bool? foodDetected,
    double? currentZoom,
    String? errorMessage,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      cameras: cameras ?? this.cameras,
      imageFile: imageFile ?? this.imageFile,
      isLoading: isLoading ?? this.isLoading,
      foodDetected: foodDetected ?? this.foodDetected,
      currentZoom: currentZoom ?? this.currentZoom,
      errorMessage: errorMessage, // Pass null to clear error
    );
  }
}

// Camera provider using StateNotifier
class CameraStateNotifier extends StateNotifier<CameraState> {
  CameraStateNotifier() : super(CameraState());

  final double _minZoom = 1.0;
  final double _maxZoom = 5.0;

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
      final image = await state.controller!.takePicture();
      state = state.copyWith(
        imageFile: File(image.path),
        foodDetected: false, // Reset food detection
      );
      return;
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

    // Toggle between 1.0x, 2.0x, and 3.0x zoom
    double nextZoom = state.currentZoom + 1.0;
    if (nextZoom > _maxZoom) {
      nextZoom = _minZoom;
    }

    try {
      await state.controller!.setZoomLevel(nextZoom);
      state = state.copyWith(currentZoom: nextZoom);
    } catch (e) {
      print('Error adjusting zoom: $e');
    }
  }

  // Clear captured image
  void clearImage() {
    state = state.copyWith(imageFile: null);
  }

  // Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
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
