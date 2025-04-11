import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../providers/camera_provider.dart';
import '../views/food_detection_results.dart';
import '../models/food_detection_result.dart';

class CameraView extends ConsumerStatefulWidget {
  final bool showGalleryOption;
  final bool showTestButton;
  final bool showSimpleTestButton;

  const CameraView({
    Key? key,
    this.showGalleryOption = true,
    this.showTestButton = true,
    this.showSimpleTestButton = true,
  }) : super(key: key);

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
              const SnackBar(
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
    });

    try {
      final results = await ref.read(cameraProvider.notifier).runDiagnostics();

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
            final pendingTasks =
                ref.watch(cameraProvider.notifier).pendingTasks;

            // Check if we have pending offline tasks
            final hasPendingTasks =
                pendingTasks != null && pendingTasks.isNotEmpty;

            return Stack(
              fit: StackFit.expand,
              children: [
                // Camera preview or loading screen
                Container(
                  color: Colors.black,
                  child: _isInitializing
                      ? _buildLoadingView()
                      : _buildCameraPreview(),
                ),

                // UI overlays
                Container(
                  child: Column(
                    children: [
                      // Top app bar
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        title: const Text('Lishe App'),
                        actions: [
                          // Flash toggle button
                          IconButton(
                            icon: Icon(
                              ref.read(cameraProvider.notifier).flashMode ==
                                      FlashMode.off
                                  ? Icons.flash_off
                                  : ref
                                              .read(cameraProvider.notifier)
                                              .flashMode ==
                                          FlashMode.auto
                                      ? Icons.flash_auto
                                      : Icons.flash_on,
                            ),
                            onPressed: () {
                              ref.read(cameraProvider.notifier).toggleFlash();
                            },
                          ),

                          // Zoom toggle button
                          IconButton(
                            icon: Text(
                              '${ref.read(cameraProvider.notifier).currentZoom.toStringAsFixed(1)}x',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                            onPressed: () {
                              ref.read(cameraProvider.notifier).adjustZoom();
                            },
                          ),
                        ],
                      ),

                      // If we have pending tasks, show a banner
                      if (hasPendingTasks)
                        Container(
                          color: Colors.orange.withOpacity(0.8),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Row(
                            children: [
                              const Icon(Icons.cloud_off, color: Colors.white),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${pendingTasks.length} image${pendingTasks.length != 1 ? 's' : ''} waiting for internet',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  ref
                                      .read(cameraProvider.notifier)
                                      .checkConnectivityAndProcessPending();
                                },
                                child: const Text('Try Now',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),

                      const Spacer(),

                      // Show the loading, error, or success state
                      foodItemsState.when(
                        loading: () => _buildLoadingView(),
                        error: (error, stack) =>
                            _buildErrorView(error.toString()),
                        data: (foods) {
                          // If no foods and not in loading/error state, show the camera controls
                          if (foods.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Information text
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      'Point your camera at food to analyze it',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  // AI-powered info
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0),
                                    child: Text(
                                      'Powered by Gemini AI for accurate food recognition',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.white70,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  const SizedBox(height: 8.0),

                                  // Quick debug buttons for development
                                  if (_showDiagnosticInfo)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: _runDiagnostics,
                                            icon: const Icon(Icons.bug_report),
                                            label:
                                                const Text('Run Diagnostics'),
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
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                      _buildGalleryButton(),

                                      // Camera button - either use our camera controller or fallback to image picker
                                      _buildCaptureButton(),

                                      // Debug button
                                      IconButton(
                                        icon: const Icon(Icons.info_outline),
                                        color: _showDiagnosticInfo
                                            ? Colors.yellow
                                            : Colors.white,
                                        iconSize: 32,
                                        onPressed: _toggleDiagnosticInfo,
                                      ),

                                      // Simple API test button
                                      if (widget.showSimpleTestButton)
                                        _buildSimpleTestButton(),

                                      // Food test button
                                      _buildFoodTestButton(),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Show the results screen if we have food items
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: FoodDetectionResults(
                                foodItems: foods,
                                detectedFoods: foods
                                    .map((food) => DetectedFood(
                                          label: food.foodName,
                                          confidence: 1.0, // Default confidence
                                        ))
                                    .toList(),
                                onRetake: () {
                                  // Clear the results and return to camera view
                                  ref
                                      .read(cameraProvider.notifier)
                                      .clearError();
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
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

  Widget _buildGalleryButton() {
    return GestureDetector(
      onTap: _pickImageFromGallery,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.photo_library,
          color: Colors.white,
          size: 28.0,
        ),
      ),
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: _useImagePickerFallback
          ? _takePhotoWithImagePicker
          : () => ref.read(cameraProvider.notifier).takePhoto(),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey, width: 2.0),
        ),
        child: const Icon(
          Icons.camera_alt,
          color: Colors.black,
          size: 40.0,
        ),
      ),
    );
  }

  Widget _buildTestButton() {
    return GestureDetector(
      onTap: () {
        ref.read(cameraProvider.notifier).processTestImage();
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Text(
          'Test',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSimpleTestButton() {
    return GestureDetector(
      onTap: () {
        ref.read(cameraProvider.notifier).processSimpleTestImage();
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Text(
          'Test API',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildFoodTestButton() {
    return GestureDetector(
      onTap: () {
        // Use category 1 (Fruits) by default, this could be made selectable
        ref.read(cameraProvider.notifier).testFoodRecognition(1);
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Text(
          'Test Food',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
