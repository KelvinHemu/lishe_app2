import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/camera_permissions.dart';
import '../providers/camera_provider.dart';
import '../widgets/camera_controls.dart';
import '../../../core/common/widgets/bottom_nav_bar.dart'; // Add this import

class CameraView extends ConsumerStatefulWidget {
  const CameraView({super.key});

  @override
  ConsumerState<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends ConsumerState<CameraView> {
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final hasPermission = await CameraPermissions.checkAndRequestPermission(
      context,
    );
    if (hasPermission) {
      await ref.read(cameraProvider.notifier).initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraProvider);

    // Show error messages
    if (cameraState.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(cameraState.errorMessage!)));
        ref.read(cameraProvider.notifier).clearError();
      });
    }

    // Show loading indicator when performing operations
    if (cameraState.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    // If camera controller is still initializing or not available
    if (cameraState.controller == null ||
        !cameraState.controller!.value.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 20),
              Text(
                'Initializing camera...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    // Main camera UI when everything is ready
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview or captured image
          Positioned.fill(
            child:
                cameraState.showingPreview && cameraState.imageFile != null
                    // Show captured image when in preview mode
                    ? Image.file(cameraState.imageFile!, fit: BoxFit.contain)
                    // Otherwise show camera preview
                    : (cameraState.controller != null &&
                        cameraState.controller!.value.isInitialized)
                    ? CameraPreview(cameraState.controller!)
                    : Container(color: Colors.black),
          ),

          // Add a back button or other controls to exit image preview instead
          if (cameraState.showingPreview && cameraState.imageFile != null)
            Positioned(
              top: 60,
              left: 20,
              child: FloatingActionButton(
                mini: true,
                heroTag: 'back',
                backgroundColor: Colors.black.withOpacity(0.7),
                child: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  ref.read(cameraProvider.notifier).retakePhoto();
                },
              ),
            ),

          // Camera controls (only show when not in preview mode)
          if (!cameraState.showingPreview)
            CameraControls(onClose: () => Navigator.pop(context)),
        ],
      ),
      // Add bottom navigation bar
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
