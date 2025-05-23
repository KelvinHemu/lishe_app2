import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MealActionButtons extends StatefulWidget {
  final void Function(String) onButtonTap;
  final String defaultExpandedButton;

  const MealActionButtons({
    super.key,
    required this.onButtonTap,
    this.defaultExpandedButton =
        'nutrients', // Change default from 'ingredients' to 'nutrients'
  });

  @override
  State<MealActionButtons> createState() => _MealActionButtonsState();
}

class _MealActionButtonsState extends State<MealActionButtons> {
  late String expandedButtonId;

  @override
  void initState() {
    super.initState();
    expandedButtonId = widget.defaultExpandedButton;
  }

  @override
  Widget build(BuildContext context) {
    // Change from 0.9 (90%) to 1.0 (100%) to use the full screen width
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ), // Add some padding on the edges
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween, // Use spaceBetween to distribute buttons evenly
          children: [
            // Ingredients button - further increased width
            _buildExpandableButton(
              id: 'ingredients',
              text: 'Ingredients',
              icon: PhosphorIcons.bowlFood(PhosphorIconsStyle.fill),
              color: Colors.blue,
              expandedWidth: 140, // Increased from 130 to 140
            ),

            const SizedBox(width: 4), // Reduced spacing even more
            // Nutrients button
            _buildExpandableButton(
              id: 'nutrients',
              text: 'Nutrients',
              icon: PhosphorIcons.carrot(PhosphorIconsStyle.bold),
              color: Colors.green,
              expandedWidth: 120, // Kept the same
            ),

            const SizedBox(width: 4), // Reduced spacing
            // Weight button
            _buildExpandableButton(
              id: 'weight',
              text: 'Weight',
              icon: PhosphorIcons.barbell(PhosphorIconsStyle.bold),
              color: Colors.purple,
              expandedWidth: 105, // Reduced width slightly
            ),

            const SizedBox(width: 4), // Reduced spacing
            // About button
            _buildExpandableButton(
              id: 'about',
              text: 'About',
              icon: PhosphorIcons.info(PhosphorIconsStyle.bold),
              color: Colors.amber,
              expandedWidth: 105, // Reduced width slightly
            ),

            const SizedBox(width: 4), // Reduced spacing
            // Map button
            _buildExpandableButton(
              id: 'map',
              text: 'Nearby',
              icon: PhosphorIcons.mapPin(PhosphorIconsStyle.bold),
              color: Colors.red,
              expandedWidth: 105, // Reduced width slightly
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableButton({
    required String id,
    required String text,
    required IconData icon,
    required Color color,
    double? expandedWidth,
  }) {
    final bool isExpanded = expandedButtonId == id;

    // Default expanded width is 150, but can be overridden
    final double buttonWidth = isExpanded ? (expandedWidth ?? 150.0) : 50.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: buttonWidth,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: color.withValues(
                alpha: 0.2,
              ), // Fixed withValues to withOpacity
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
          child: InkWell(
            onTap: () {
              setState(() {
                expandedButtonId = id;
              });
              widget.onButtonTap(id);
            },
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              height: 40.0,
              padding: EdgeInsets.symmetric(horizontal: isExpanded ? 12.0 : 0),
              child:
                  isExpanded
                      ? Row(
                        children: [
                          // Icon always on the left
                          icon is PhosphorIconData
                              ? PhosphorIcon(
                                icon,
                                size: 22,
                                color: Colors.white,
                              )
                              : Icon(icon, size: 22, color: Colors.white),
                          // Expanded space to push text to center
                          Expanded(
                            child: Center(
                              child: Text(
                                text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14, // Slightly smaller font size
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      )
                      : Center(
                        child:
                            icon is PhosphorIconData
                                ? PhosphorIcon(
                                  icon,
                                  size: 22,
                                  color: Colors.white,
                                )
                                : Icon(icon, size: 22, color: Colors.white),
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
