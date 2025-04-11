import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CameraActionButtons extends StatefulWidget {
  final void Function(String) onButtonTap;
  final String defaultExpandedButton;

  const CameraActionButtons({
    super.key,
    required this.onButtonTap,
    this.defaultExpandedButton = 'nutrients',
  });

  @override
  State<CameraActionButtons> createState() => _CameraActionButtonsState();
}

class _CameraActionButtonsState extends State<CameraActionButtons> {
  late String expandedButtonId;

  @override
  void initState() {
    super.initState();
    expandedButtonId = widget.defaultExpandedButton;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Swaps button
            _buildExpandableButton(
              id: 'ingredients',
              text: 'Swaps',
              icon: PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.bold),
              color: Colors.blue,
              expandedWidth: 120,
            ),

            const SizedBox(width: 4),
            // Nutrients button
            _buildExpandableButton(
              id: 'nutrients',
              text: 'Nutrients',
              icon: PhosphorIcons.carrot(PhosphorIconsStyle.bold),
              color: Colors.green,
              expandedWidth: 120,
            ),

            const SizedBox(width: 4),
            // Weight button
            _buildExpandableButton(
              id: 'weight',
              text: 'Weight',
              icon: PhosphorIcons.barbell(PhosphorIconsStyle.bold),
              color: Colors.purple,
              expandedWidth: 105,
            ),

            const SizedBox(width: 4),
            // About button
            _buildExpandableButton(
              id: 'about',
              text: 'About',
              icon: PhosphorIcons.info(PhosphorIconsStyle.bold),
              color: Colors.amber,
              expandedWidth: 105,
            ),

            const SizedBox(width: 4),
            // Map button
            _buildExpandableButton(
              id: 'map',
              text: 'Nearby',
              icon: PhosphorIcons.mapPin(PhosphorIconsStyle.bold),
              color: Colors.red,
              expandedWidth: 105,
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

    final double buttonWidth = isExpanded ? (expandedWidth ?? 150.0) : 50.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: buttonWidth,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
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
              child: isExpanded
                  ? Row(
                      children: [
                        icon is PhosphorIconData
                            ? PhosphorIcon(
                                icon,
                                size: 22,
                                color: Colors.white,
                              )
                            : Icon(icon, size: 22, color: Colors.white),
                        Expanded(
                          child: Center(
                            child: Text(
                              text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: icon is PhosphorIconData
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
