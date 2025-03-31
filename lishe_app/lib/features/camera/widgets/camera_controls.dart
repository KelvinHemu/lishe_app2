import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart'; // Make sure this package is added to pubspec.yaml
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
        // Bottom control bar - Replace your existing Positioned and Row setup
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Camera button in center
                Center(
                  child: GestureDetector(
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
                ),

                // Gallery button - more to the left
                Positioned(
                  left: 40, // Adjust this to move further left
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
                        print('Error picking image from gallery: $e');
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

                // Zoom button - more to the right
                Positioned(
                  right: 40, // Adjust this to move further right
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
                            color: Colors.black,
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
