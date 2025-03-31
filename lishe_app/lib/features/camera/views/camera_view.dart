import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/camera_provider.dart';
import '../utils/camera_permissions.dart';
import '../widgets/camera_controls.dart';
import '../widgets/view_finder.dart'; // Keep this import

class CameraView extends ConsumerStatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  ConsumerState<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends ConsumerState<CameraView> {
  @override
  void initState() {
    super.initState();
    // Request camera permissions and initialize the camera when the view loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasPermission = await CameraPermissions.checkAndRequestPermission(
        context,
      );
      if (hasPermission) {
        ref.read(cameraProvider.notifier).initialize();
      }
    });
  }

  @override
  void dispose() {
    // Clean up camera resources when view is disposed
    ref.read(cameraProvider.notifier).disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Camera preview or captured image
          Positioned.fill(
            child:
                cameraState.showingPreview && cameraState.imageFile != null
                    ? Image.file(cameraState.imageFile!, fit: BoxFit.contain)
                    : (cameraState.controller != null &&
                        cameraState.controller!.value.isInitialized)
                    ? CameraPreview(cameraState.controller!)
                    : Container(color: Colors.black),
          ),

          // Add Viewfinder - only show when not in preview mode
          if (!cameraState.showingPreview)
            Center(
              child: Viewfinder(
                size: MediaQuery.of(context).size.width * 0.85,
                cornerLength: 40,
                lineWidth: 3,
                color: Colors.white.withOpacity(0.7),
              ),
            ),

          // Camera controls
          if (cameraState.controller != null &&
              cameraState.controller!.value.isInitialized)
            CameraControls(onClose: () => Navigator.of(context).pop()),

          // Error message
          if (cameraState.errorMessage != null)
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    cameraState.errorMessage!,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

          // Loading indicator
          if (cameraState.isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        ],
      ),
    );
  }
}
