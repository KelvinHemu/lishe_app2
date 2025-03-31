import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/camera_permissions.dart';
import '../providers/camera_provider.dart';
import '../widgets/camera_controls.dart';
import '../widgets/camera_preview_widget.dart';

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
          // Camera preview with frame and status
          const CameraPreviewWidget(),

          // Camera controls
          CameraControls(onClose: () => Navigator.pop(context)),

          // Permission status check button
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  final status = await Permission.camera.status;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Camera permission status: $status'),
                    ),
                  );
                },
                child: const Text('Check permission status'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
