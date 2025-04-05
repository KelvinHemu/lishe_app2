import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import '../providers/camera_provider.dart';

class CameraPreviewWidget extends ConsumerWidget {
  const CameraPreviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the camera controller from the notifier
    final cameraNotifier = ref.read(cameraProvider.notifier);
    final foodItemsState = ref.watch(cameraProvider);

    // Check if foods are detected
    final bool foodDetected = foodItemsState.maybeWhen(
      data: (foods) => foods.isNotEmpty,
      orElse: () => false,
    );

    return Stack(
      children: [
        // Camera preview
        Positioned.fill(
          child: _buildCameraPreview(cameraNotifier),
        ),

        // Camera frame outline
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),

        // Top status bar with detection status
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.white),
                    onPressed: () {
                      // Show info dialog
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    foodDetected ? 'Food Detected' : 'No Food Detected',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCameraPreview(CameraNotifier cameraNotifier) {
    final controller = cameraNotifier.controller;

    if (controller == null || !controller.value.isInitialized) {
      return Container(color: Colors.black);
    }

    return CameraPreview(controller);
  }
}
