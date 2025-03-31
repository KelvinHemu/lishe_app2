import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/camera_provider.dart';

class CameraControls extends ConsumerWidget {
  final VoidCallback onClose;

  const CameraControls({super.key, required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraProvider);
    final cameraNotifier = ref.read(cameraProvider.notifier);

    print(
      'Building CameraView. showingPreview=${cameraState.showingPreview}, hasImage=${cameraState.imageFile != null}',
    );

    return Stack(
      children: [
        // Bottom control bar
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Spacer or gallery button
              const SizedBox(width: 60, height: 60),

              // Camera button
              GestureDetector(
                onTap: () {
                  print('Camera button tapped');
                  print('Taking photo...');
                  cameraNotifier.takePhoto();
                  print(
                    'State updated with showingPreview=${cameraState.showingPreview}',
                  );
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                ),
              ),

              // Zoom button
              GestureDetector(
                onTap: cameraNotifier.adjustZoom,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "${cameraState.currentZoom.toStringAsFixed(1)}x",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Close button in top right
        Positioned(
          top: 60,
          right: 20,
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
