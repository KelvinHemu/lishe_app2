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

// Update _CameraViewState to implement WidgetsBindingObserver
class _CameraViewState extends ConsumerState<CameraView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraController = ref.read(cameraProvider).controller;

    // App going to background
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Release camera resources when app is inactive
      ref.read(cameraProvider.notifier).disposeCamera();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize camera when app is resumed
      ref.read(cameraProvider.notifier).initialize();
    }
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

          // Top row with info button and back button (when in preview mode)
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button - only visible in preview mode
                  if (cameraState.showingPreview &&
                      cameraState.imageFile != null)
                    Container(
                      height: 48,
                      width: 48,
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
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            ref.read(cameraProvider.notifier).retakePhoto();
                          },
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
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
