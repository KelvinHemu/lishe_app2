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
    // Set width to 80% of screen width
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Ingredients button
          _buildExpandableButton(
            id: 'ingredients',
            text: 'Ingredients',
            icon: PhosphorIcons.bowlFood(PhosphorIconsStyle.fill),
            color: Colors.blue,
            expandedWidth: 150, // Adjusted width for consistency
          ),

          const SizedBox(width: 8),

          // Nutrients button
          _buildExpandableButton(
            id: 'nutrients',
            text: 'Nutrients',
            icon: PhosphorIcons.carrot(PhosphorIconsStyle.bold),
            color: Colors.green,
          ),

          const SizedBox(width: 8),

          // Weight button (new)
          _buildExpandableButton(
            id: 'weight',
            text: 'Weight',
            icon: PhosphorIcons.barbell(PhosphorIconsStyle.bold),
            color: Colors.purple,
          ),

          const SizedBox(width: 8),

          // About button
          _buildExpandableButton(
            id: 'about',
            text: 'About',
            icon: PhosphorIcons.info(PhosphorIconsStyle.bold),
            color: Colors.amber,
          ),
        ],
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
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis,
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
