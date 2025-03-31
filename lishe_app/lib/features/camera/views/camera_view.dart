import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  File? _imageFile;
  bool _isLoading = false;
  bool _foodDetected = false;
  double _currentZoom = 1.0;
  final double _minZoom = 1.0;
  final double _maxZoom = 5.0;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  Future<void> initializeCamera() async {
    setState(() {
      _isLoading = true;
    });

    // Request camera permission
    print('Requesting camera permission...');
    var status = await Permission.camera.request();
    print('Camera permission status: $status');

    if (status.isGranted) {
      try {
        print('Getting available cameras...');
        cameras = await availableCameras();
        print('Available cameras: ${cameras?.length ?? 0}');

        if (cameras != null && cameras!.isNotEmpty) {
          print('Creating camera controller...');
          cameraController = CameraController(
            cameras![0],
            ResolutionPreset.high,
            enableAudio: false,
          );

          print('Initializing camera controller...');
          await cameraController!.initialize();
          print('Camera controller initialized successfully');

          // Set initial zoom level
          await cameraController!.setZoomLevel(_currentZoom);
          print('Zoom level set to $_currentZoom');
        } else {
          print('No cameras available on this device');
        }
      } catch (e) {
        print('Error initializing camera: $e');
        if (e is CameraException) {
          print('Camera error code: ${e.code}');
          print('Camera error description: ${e.description}');
        }
        // Log stack trace for more detailed debugging
        print('Stack trace: ${StackTrace.current}');
      }
    } else if (status.isDenied) {
      print('Camera permission was denied by the user');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera permission is required to use the camera'),
        ),
      );
    } else if (status.isPermanentlyDenied) {
      print('Camera permission is permanently denied, open app settings');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Camera permission is permanently denied. Please enable it in app settings.',
          ),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () => openAppSettings(),
          ),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> requestCameraPermission() async {
    print('Manually requesting camera permission...');
    var status = await Permission.camera.request();
    print('Camera permission status after manual request: $status');

    if (status.isGranted) {
      // Permission granted, initialize camera
      initializeCamera();
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Camera permission is required to use the camera',
          ),
          action: SnackBarAction(
            label: 'Try Again',
            onPressed: requestCameraPermission,
          ),
        ),
      );
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Camera permission is permanently denied. Please enable it in app settings.',
          ),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () => openAppSettings(),
          ),
        ),
      );
    }
  }

  Future<void> checkAndRequestCameraPermission() async {
    var status = await Permission.camera.status;

    // First time requesting (status is denied but not permanently)
    if (status.isDenied) {
      // Show explanation dialog before requesting permission
      bool shouldRequest =
          await showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Camera Permission'),
                  content: const Text(
                    'This app uses your camera to identify food items and provide nutritional information. '
                    'We need your permission to access the camera.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Deny'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Allow'),
                    ),
                  ],
                ),
          ) ??
          false;

      if (shouldRequest) {
        await Permission.camera.request();
        initializeCamera();
      }
    } else {
      // Not first time, proceed with normal flow
      initializeCamera();
    }
  }

  Future<void> _takePhoto() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera is not initialized')),
      );
      return;
    }

    try {
      final image = await cameraController!.takePicture();
      setState(() {
        _imageFile = File(image.path);
        // Simulate food detection (replace with actual AI logic)
        _foodDetected = false;
      });
    } catch (e) {
      print('Error taking photo: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error taking photo: $e')));
    }
  }

  Future<void> _adjustZoom() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    // Toggle between 1.0x, 2.0x, and 3.0x zoom
    double nextZoom = _currentZoom + 1.0;
    if (nextZoom > _maxZoom) {
      nextZoom = _minZoom;
    }

    try {
      await cameraController!.setZoomLevel(nextZoom);
      setState(() {
        _currentZoom = nextZoom;
      });
    } catch (e) {
      print('Error adjusting zoom: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator when performing operations
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    // If camera controller is still initializing or not available
    if (cameraController == null || !cameraController!.value.isInitialized) {
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
                _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                    : CameraPreview(cameraController!),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
                      _foodDetected ? 'Food Detected' : 'No Food Detected',
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

          // Bottom control bar
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Back to camera button (only shown if photo was taken)
                _imageFile != null
                    ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _imageFile = null;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    )
                    : const SizedBox(width: 60, height: 60),

                // Camera button
                GestureDetector(
                  onTap: _takePhoto,
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
                  onTap: _adjustZoom,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "${_currentZoom.toStringAsFixed(1)}x",
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
              onTap: () => Navigator.pop(context),
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

          // Add this to your camera view's build method somewhere
          Positioned(
            bottom: 100,
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
