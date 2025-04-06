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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Find Your Next Meal',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade300, width: 1),
                ),
                child: Text(
                  'Suggested',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.amber.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Random Meal Button
              Expanded(
                child: _buildButton(
                  icon: Icons.casino,
                  label: 'Random Meal',
                  onTap: _handleRoll,
                  animate: isRolling,
                  primaryColor: const Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(width: 12),
              // Search Button
              Expanded(
                child: _buildButton(
                  icon: Icons.search,
                  label: 'Search Meals',
                  onTap: widget.onExplorePressed,
                  animate: false,
                  primaryColor: const Color(0xFF1976D2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool animate,
    required Color primaryColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(0.8),
                primaryColor,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon with animation
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: animate
                        ? Icon(icon, color: Colors.white, size: 20)
                            .animate(
                              onPlay: (controller) =>
                                  controller.repeat(reverse: false),
                            )
                            .then(delay: 0.seconds)
                            .rotate(
                              duration: 1.seconds,
                              begin: 0,
                              end: 3,
                              curve: Curves.easeInOutBack,
                            )
                        : Icon(icon, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 8),
                // Button text
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
