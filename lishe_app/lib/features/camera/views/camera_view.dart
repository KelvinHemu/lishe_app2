import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../providers/camera_provider.dart';
import '../widgets/camera_controls.dart';
import '../views/food_detection_results.dart';

class CameraView extends ConsumerStatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  ConsumerState<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends ConsumerState<CameraView>
    with WidgetsBindingObserver {
  bool _isInitializing = true;
  bool _useImagePickerFallback = false;
  bool _showDiagnosticInfo = false; // Track whether to show diagnostic info

  // State for diagnostic results
  String _diagnosticResults = '';
  bool _runningDiagnostics = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes
    final cameraNotifier = ref.read(cameraProvider.notifier);

    // Check if the controller is initialized
    if (cameraNotifier.controller == null) {
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      // App inactive or paused, stop camera preview
      print('App lifecycle changed to $state - disposing camera');
      cameraNotifier.disposeCamera();
    } else if (state == AppLifecycleState.resumed) {
      // App resumed, reinitialize camera
      print('App lifecycle changed to $state - reinitializing camera');
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      if (mounted) {
        setState(() {
          _isInitializing = true;
        });
      }

      // Request camera permission using the latest API
      final status = await Permission.camera.request();

      if (status.isGranted) {
        // Permission granted, initialize the camera
        try {
          await ref.read(cameraProvider.notifier).initializeCamera();
          // Reset fallback flag if successful
          if (_useImagePickerFallback && mounted) {
            setState(() {
              _useImagePickerFallback = false;
            });
          }
        } catch (cameraError) {
          print('Camera initialization error: $cameraError');
          // If we have a channel error, switch to fallback mode
          if (cameraError.toString().contains('channel-error') ||
              cameraError
                  .toString()
                  .contains('Unable to establish connection')) {
            if (mounted) {
              setState(() {
                _useImagePickerFallback = true;
              });
            }
          }

          // Show error but don't prevent fallback UI
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Camera init failed: Using system camera instead'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      } else if (status.isPermanentlyDenied) {
        // User permanently denied camera permission
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Camera permission permanently denied. Please enable it in app settings.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Settings',
                onPressed: openAppSettings,
                textColor: Colors.white,
              ),
            ),
          );
        }
      } else {
        // Permission denied but not permanently
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Camera permission is required to use this feature'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to initialize camera: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        await ref
            .read(cameraProvider.notifier)
            .processGalleryImage(pickedFile.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not select image: $e')),
        );
      }
    }
  }

  // Use image picker as fallback for taking photos
  Future<void> _takePhotoWithImagePicker() async {
    final ImagePicker picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        await ref
            .read(cameraProvider.notifier)
            .processGalleryImage(pickedFile.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not take photo: $e')),
        );
      }
    }
  }

  // Run diagnostic tests
  Future<void> _runDiagnostics() async {
    if (_runningDiagnostics) return;

    setState(() {
      _runningDiagnostics = true;
      _diagnosticResults = 'Running diagnostics...';
      _showDiagnosticInfo = true;
    });

    try {
      final results =
          await ref.read(cameraProvider.notifier).testFatSecretConnection();
      if (mounted) {
        setState(() {
          _diagnosticResults = results;
          _runningDiagnostics = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _diagnosticResults = 'Error running diagnostics: $e';
          _runningDiagnostics = false;
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ref.read(cameraProvider.notifier).disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final foodItemsState = ref.watch(cameraProvider);

            return Stack(
              children: [
                // Camera preview
                _buildCameraPreview(),

                // Initial loading indicator
                if (_isInitializing)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),

                // Handle different states using when
                foodItemsState.when(
                  loading: () => _buildLoadingView(),
                  error: (error, stackTrace) =>
                      _buildErrorView(error.toString()),
                  data: (foodItems) {
                    // Check if we have detected food items
                    if (foodItems.isNotEmpty) {
                      // Navigate to results screen using microtask
                      // to avoid build phase navigation
                      Future.microtask(() {
                        // Clear state to avoid infinite navigation
                        ref.read(cameraProvider.notifier).clearError();

                        // Navigate to results
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FoodDetectionResults(
                              foodItems: foodItems,
                              onRetake: () {
                                // Return to camera view
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        );
                      });
                    }

                    // Check if camera is initialized
                    final hasFoods = foodItems.isNotEmpty;

                    return Stack(
                      children: [
                        // Camera controls
                        if (!_isInitializing)
                          CameraControls(
                            onClose: () => Navigator.of(context).pop(),
                          ),

                        // Camera capture and gallery buttons
                        if (!_isInitializing && !hasFoods)
                          Positioned(
                            bottom: 32,
                            left: 0,
                            right: 0,
                            child: Column(
                              children: [
                                // Diagnostic button for troubleshooting
                                if (_showDiagnosticInfo)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: _runningDiagnostics
                                              ? null
                                              : _runDiagnostics,
                                          icon: _runningDiagnostics
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                          strokeWidth: 2))
                                              : const Icon(Icons.bug_report),
                                          label: Text(_runningDiagnostics
                                              ? 'Testing...'
                                              : 'Test API'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.purple,
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            ref
                                                .read(cameraProvider.notifier)
                                                .processTestImage();
                                          },
                                          icon: const Icon(Icons.image),
                                          label: const Text('Test Image'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                // Diagnostic results
                                if (_showDiagnosticInfo &&
                                    _diagnosticResults.isNotEmpty)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.purpleAccent),
                                      ),
                                      height: 100,
                                      child: SingleChildScrollView(
                                        child: Text(
                                          _diagnosticResults,
                                          style: const TextStyle(
                                            color: Colors.greenAccent,
                                            fontFamily: 'monospace',
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Gallery button
                                    IconButton(
                                      icon: const Icon(Icons.photo_library),
                                      color: Colors.white,
                                      iconSize: 32,
                                      onPressed: _pickImageFromGallery,
                                    ),

                                    // Camera button - either use our camera controller or fallback to image picker
                                    GestureDetector(
                                      onTap: () {
                                        if (_useImagePickerFallback) {
                                          _takePhotoWithImagePicker();
                                        } else {
                                          ref
                                              .read(cameraProvider.notifier)
                                              .takePhoto();
                                        }
                                      },
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: _useImagePickerFallback
                                                  ? Colors.orange
                                                  : Colors.white,
                                              width: 4),
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: _useImagePickerFallback
                                                ? Colors.orange
                                                : Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Debug button
                                    IconButton(
                                      icon: const Icon(Icons.info_outline),
                                      color: _showDiagnosticInfo
                                          ? Colors.yellow
                                          : Colors.white,
                                      iconSize: 32,
                                      onPressed: _toggleDiagnosticInfo,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    // If we're using the fallback camera mode, just show a black background
    if (_useImagePickerFallback) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Icon(
            Icons.camera_alt,
            color: Colors.white54,
            size: 64,
          ),
        ),
      );
    }

    final cameraNotifier = ref.read(cameraProvider.notifier);
    final controller = cameraNotifier.controller;

    if (controller == null || !controller.value.isInitialized) {
      return Container(color: Colors.black);
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  String _getReadableErrorMessage(String errorMessage) {
    // Convert technical error messages into user-friendly messages
    if (errorMessage.contains('FileSystemException') ||
        errorMessage.contains('FileNotFoundError') ||
        errorMessage.contains('Failed to read file') ||
        errorMessage.contains('file not found')) {
      return 'Could not access the image file. Please try taking another photo.';
    }

    if (errorMessage.contains('channel-error') ||
        errorMessage.contains('Unable to establish connection')) {
      return 'Camera connection issue. The app will now use your phone\'s built-in camera instead.';
    }

    if (errorMessage.contains('timeout') ||
        errorMessage.contains('timed out')) {
      return 'Connection timed out. Check your internet connection and try again.';
    }

    if (errorMessage.contains('SocketException') ||
        errorMessage.contains('Connection failed')) {
      return 'Network connection issue. Check your internet and try again.';
    }

    if (errorMessage.contains('ApiError') ||
        errorMessage.contains('status code 4')) {
      return 'Could not reach the food recognition service. Please try again later.';
    }

    // Default message
    return 'Something went wrong. Please try again or use a clearer image.';
  }

  // Toggle diagnostic info display
  void _toggleDiagnosticInfo() {
    setState(() {
      _showDiagnosticInfo = !_showDiagnosticInfo;
    });
  }

  // Loading view to display when camera state is loading
  Widget _buildLoadingView() {
    return Container(
      color: Colors.black54,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // Error view to display when camera state has an error
  Widget _buildErrorView(String errorMessage) {
    return Container(
      color: Colors.black54,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Could not analyze image',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getReadableErrorMessage(errorMessage),
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Reset the state and try again
                ref.read(cameraProvider.notifier).clearError();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
