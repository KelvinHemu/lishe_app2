import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RandomRecipeWidget extends StatefulWidget {
  final VoidCallback onRandomPressed;
  final VoidCallback onExplorePressed;

  const RandomRecipeWidget({
    super.key,
    required this.onRandomPressed,
    required this.onExplorePressed,
  });

  @override
  State<RandomRecipeWidget> createState() => _RandomRecipeWidgetState();
}

class _RandomRecipeWidgetState extends State<RandomRecipeWidget> {
  bool isRolling = false;

  void _handleRoll() {
    setState(() {
      isRolling = true;
    });

    widget.onRandomPressed();

    // Reset rolling state after animation time
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          isRolling = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dice icon with background
          InkWell(
            onTap: _handleRoll,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.casino, color: Colors.green, size: 28)
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: false),
                  )
                  .then(delay: isRolling ? 0.seconds : 1.seconds)
                  .rotate(
                    duration: 1.seconds,
                    begin: 0,
                    end: isRolling ? 3 : 0.2,
                    curve: Curves.easeInOutBack,
                  ),
            ),
          ),
          Text(
            'Try Random Meal',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          // Explore icon with background
          InkWell(
            onTap: widget.onExplorePressed,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.explore, color: Colors.green, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
