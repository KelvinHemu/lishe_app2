import 'package:flutter/material.dart';

class ViewFinderGuide extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final int currentPage;

  const ViewFinderGuide({
    super.key,
    required this.onClose,
    required this.onBack,
    required this.onNext,
    required this.currentPage,
  });

  @override
  State<ViewFinderGuide> createState() => _ViewFinderGuideState();
}

class _ViewFinderGuideState extends State<ViewFinderGuide> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          // Header with title
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
            child: Column(
              children: [
                Text(
                  _getPageTitle(),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _getPageIcon(),
              ],
            ),
          ),
          // Main content area
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildPageContent(),
              ),
            ),
          ),
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                // Only show back button if not on first page
                if (widget.currentPage > 0)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onBack,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFFFE5E5,
                        ), // Light pink background
                        foregroundColor: const Color(0xFFFF4D4D), // Red text
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back_ios, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (widget.currentPage > 0) const SizedBox(width: 16),
                Expanded(
                  flex: widget.currentPage == 0
                      ? 2
                      : 1, // Take full width if no back button
                  child: ElevatedButton(
                    onPressed: widget.onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CD964), // Green color
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.currentPage < 3 ? 'Next' : 'Get Started',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (widget.currentPage < 3) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPageTitle() {
    switch (widget.currentPage) {
      case 0:
        return 'View Finder';
      case 1:
        return 'Food Not Food';
      case 2:
        return 'Save or Delete';
      case 3:
        return 'Custom Foods';
      default:
        return '';
    }
  }

  Widget _getPageIcon() {
    switch (widget.currentPage) {
      case 0:
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 24),
            SizedBox(width: 8),
            Icon(Icons.crop_free, size: 24),
          ],
        );
      case 1:
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.food_bank, size: 24),
            SizedBox(width: 8),
            Icon(Icons.not_interested, size: 24),
          ],
        );
      case 2:
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save_alt, size: 24),
            SizedBox(width: 8),
            Icon(Icons.delete_outline, size: 24),
          ],
        );
      case 3:
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_note, size: 24),
            SizedBox(width: 8),
            Icon(Icons.food_bank, size: 24),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPageContent() {
    switch (widget.currentPage) {
      case 0:
        return Column(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: Center(
                child: Icon(
                  Icons.camera_alt,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'To give Nutrify the best chance at identifying the correct food, make sure it\'s centered in the middle of the guidelines above.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.food_bank,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'No Food Detected',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Nutrify\'s Food Not Food AI looks for food or drinks in an image. Once it detects the presence of food, you\'ll see the camera button turn green and a "Food Detected" message.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.save_alt,
                      size: 48,
                      color: Colors.greenAccent.shade400,
                    ),
                    const SizedBox(width: 32),
                    Icon(
                      Icons.delete_outline,
                      size: 48,
                      color: Colors.red.shade300,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'After taking a photo, you can choose to save it to your food diary or delete it. Saved photos will appear in your journal and contribute to your nutrition stats.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 3:
        return Column(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit_note,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Custom Food Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'If a food isn\'t recognized or you want to add more details, you can easily rename it with custom text. This helps keep your food diary accurate and personalized.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
