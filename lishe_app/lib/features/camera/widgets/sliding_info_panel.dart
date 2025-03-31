import 'package:flutter/material.dart';

class NutrifyGuidePanel extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  const NutrifyGuidePanel({
    Key? key,
    required this.onClose,
    required this.onSkip,
    required this.onNext,
  }) : super(key: key);

  @override
  State<NutrifyGuidePanel> createState() => _NutrifyGuidePanelState();
}

class _NutrifyGuidePanelState extends State<NutrifyGuidePanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Start the animation when widget builds
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta! > 0) {
      // Only respond to downward drag
      final newValue = _controller.value - (details.primaryDelta! / 300);
      _controller.value = newValue.clamp(0.0, 1.0);
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dy > 200 || _controller.value < 0.5) {
      // If dragged downward fast or more than halfway down, close the panel
      _controller.reverse().then((_) => widget.onClose());
    } else {
      // Otherwise, snap back to fully open
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: GestureDetector(
        onVerticalDragUpdate: _handleDragUpdate,
        onVerticalDragEnd: _handleDragEnd,
        child: Container(
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
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 30, 24, 20),
                child: Column(
                  children: [
                    Text(
                      'How to use Nutrify',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 24),
                        SizedBox(width: 8),
                        Icon(Icons.food_bank, size: 24),
                      ],
                    ),
                  ],
                ),
              ),
              // Guide Items
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildGuideItem(
                          icon: Icons.camera_alt,
                          title: 'FoodVision',
                          content:
                              'Nutrify identifies one food/drink per image. Centre the item within the screen guidelines for the best results.',
                        ),
                        const SizedBox(height: 16),
                        _buildGuideItem(
                          icon: Icons.edit,
                          title: 'Food Not Food',
                          content:
                              'Nutrify looks for whole foods, dishes and drinks rather than barcodes, objects, plants or people.',
                        ),
                        const SizedBox(height: 16),
                        _buildGuideItem(
                          icon: Icons.bookmark,
                          title: 'Saving and Deleting',
                          content:
                              'Save food photos for your journal and stats tab, or delete them for tidiness.',
                        ),
                        const SizedBox(height: 16),
                        _buildGuideItem(
                          icon: Icons.note_alt,
                          title: 'Custom Foods',
                          content:
                              "If a food isn't in Nutrify's database, you can rename it with custom text.",
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              // Action buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _controller.reverse().then((_) => widget.onSkip());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black54,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _controller.reverse().then((_) => widget.onNext());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent.shade400,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// Example of how to use this widget in your app
class ExampleApp extends StatefulWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  bool _showGuide = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrify App'),
        backgroundColor: Colors.greenAccent.shade400,
      ),
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showGuide = true;
                });
              },
              child: const Text('Show Guide'),
            ),
          ),
          if (_showGuide)
            NutrifyGuidePanel(
              onClose: () {
                setState(() {
                  _showGuide = false;
                });
              },
              onSkip: () {
                setState(() {
                  _showGuide = false;
                });
                // Add any additional skip logic here
              },
              onNext: () {
                setState(() {
                  _showGuide = false;
                });
                // Add navigation to next page here
              },
            ),
        ],
      ),
    );
  }
}
