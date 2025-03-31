import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lishe_app/features/camera/providers/camera_provider.dart';
import 'package:lishe_app/features/camera/widgets/sliding_info_panel.dart';

class CameraControls extends ConsumerWidget {
  final VoidCallback onClose;

  const CameraControls({super.key, required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraProvider);
    final cameraNotifier = ref.read(cameraProvider.notifier);

    return Stack(
      children: [
        // Flash control button at top right
        Positioned(
          top: 40,
          right: 20,
          child: GestureDetector(
            onTap: () => cameraNotifier.toggleFlash(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                cameraState.flashMode == null ||
                        cameraState.flashMode == FlashMode.off
                    ? Icons.flash_off
                    : cameraState.flashMode == FlashMode.auto
                    ? Icons.flash_auto
                    : Icons.flash_on,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),

        // Info button with improved styling
        Positioned(
          top: 40,
          left: 20,
          child: GestureDetector(
            onTap: () {
              // Use the custom guide panel with improved styling
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder:
                    (context) => NutrifyGuidePanel(
                      onClose: () => Navigator.of(context).pop(),
                      onSkip: () => Navigator.of(context).pop(),
                      onNext: () {
                        Navigator.of(context).pop();
                        // Add any additional navigation logic here
                        // For example: Navigate to the next screen or show a different guide
                      },
                    ),
              );
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.8),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'i',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'serif',
                  ),
                ),
              ),
            ),
          ),
        ),

        // Bottom control bar
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Camera button in center
                Center(
                  child: GestureDetector(
                    onTap: () {
                      cameraNotifier.takePhoto();
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
                ),

                // Gallery button
                Positioned(
                  left: 40,
                  child: GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      try {
                        final pickedFile = await picker.pickImage(
                          source: ImageSource.gallery,
                          maxWidth: 1200,
                          maxHeight: 1200,
                          imageQuality: 85,
                        );

                        if (pickedFile != null) {
                          cameraNotifier.processGalleryImage(pickedFile.path);
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not select image: $e')),
                        );
                      }
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.photo_library,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),

                // Zoom button
                Positioned(
                  right: 40,
                  child: GestureDetector(
                    onTap: cameraNotifier.adjustZoom,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          "${cameraState.currentZoom.toStringAsFixed(1)}x",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
