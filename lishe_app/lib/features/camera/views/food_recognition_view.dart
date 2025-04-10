import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/food_recognition_provider.dart';
import '../widgets/food_details_card.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/error_message.dart';
import '../widgets/retry_button.dart';

class FoodRecognitionView extends ConsumerStatefulWidget {
  const FoodRecognitionView({super.key});

  @override
  ConsumerState<FoodRecognitionView> createState() =>
      _FoodRecognitionViewState();
}

class _FoodRecognitionViewState extends ConsumerState<FoodRecognitionView> {
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();
  File? _imageFile;
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
          _errorMessage = null;
        });
        _processImage();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to pick image: $e';
      });
    }
  }

  Future<void> _processImage() async {
    if (_imageFile == null) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final inputImage = InputImage.fromFile(_imageFile!);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      if (recognizedText.text.isEmpty) {
        setState(() {
          _errorMessage =
              'No text found in image. Please try again with better lighting or a clearer image.';
          _isProcessing = false;
        });
        return;
      }

      // Process the recognized text with our food recognition provider
      await ref
          .read(foodRecognitionProvider.notifier)
          .processImageText(recognizedText.text);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error processing image: $e';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final foodState = ref.watch(foodRecognitionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Recognition'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // TODO: Navigate to recognition history
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image preview or placeholder
                  if (_imageFile != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          Image.file(
                            _imageFile!,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                          if (_isProcessing)
                            Container(
                              height: 300,
                              color: Colors.black54,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  else
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Take a photo of your food',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Camera button
                  ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _pickImage,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Results section
                  if (foodState.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (foodState.error != null)
                    ErrorMessage(message: foodState.error!)
                  else if (foodState.foods.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recognized Foods',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...foodState.foods.map((food) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: FoodDetailsCard(food: food),
                            )),
                      ],
                    )
                  else if (_errorMessage != null)
                    ErrorMessage(message: _errorMessage!)
                  else
                    const Center(
                      child: Text(
                        'Take a photo of your food to get started',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (_isProcessing) const LoadingOverlay(),
        ],
      ),
      floatingActionButton: foodState.error != null || _errorMessage != null
          ? RetryButton(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                });
                ref.read(foodRecognitionProvider.notifier).clear();
                _processImage();
              },
            )
          : null,
    );
  }
}
