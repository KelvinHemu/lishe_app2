import 'dart:io';

/// Result of food detection containing confidence scores and classification information
class FoodDetectionResult {
  /// Whether food was detected with sufficient confidence
  final bool foodDetected;

  /// The source image file
  final File imageFile;

  /// List of detected food items with confidence scores
  final List<DetectedFood> detectedItems;

  /// Any error that occurred during detection
  final String? errorMessage;

  const FoodDetectionResult({
    required this.foodDetected,
    required this.imageFile,
    this.detectedItems = const [],
    this.errorMessage,
  });

  /// Creates a result indicating an error occurred
  factory FoodDetectionResult.error(File image, String message) {
    return FoodDetectionResult(
      foodDetected: false,
      imageFile: image,
      errorMessage: message,
    );
  }

  /// Whether this result contains an error
  bool get hasError => errorMessage != null;

  /// The top detected food item, if any
  DetectedFood? get topResult =>
      detectedItems.isNotEmpty ? detectedItems.first : null;
}

/// Information about a detected food item
class DetectedFood {
  /// The label/name of the detected food
  final String label;

  /// Confidence score (0-1) of the detection
  final double confidence;

  const DetectedFood({required this.label, required this.confidence});
}
