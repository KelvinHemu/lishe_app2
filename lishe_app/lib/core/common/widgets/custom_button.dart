import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double? height; // Nullable double
  final double? width; // Nullable double
  final double? borderRadius; // Nullable double
  final IconData? icon;
  final double iconSize;
  final bool iconCentered; // Add this parameter to control icon alignment

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.height,
    this.width,
    this.borderRadius,
    this.icon,
    this.iconSize = 20,
    this.iconCentered = false, // Default to false for standard button behavior
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: textColor,
                padding: text.isEmpty
                    ? const EdgeInsets.all(
                        0,
                      ) // No padding for icon-only buttons
                    : const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 12),
                ),
              ),
              child: text.isEmpty
                  ? _buildIconOnly() // Icon-only view when text is empty
                  : _buildWithText(), // Text with icon view
            ),
    );
  }

  Widget _buildIconOnly() {
    // Icon-only layout (centered icon)
    return Center(
      child: icon != null
          ? icon is PhosphorIconData
              ? PhosphorIcon(
                  icon as PhosphorIconData,
                  size: iconSize,
                  color: textColor,
                )
              : Icon(icon, size: iconSize, color: textColor)
          : const SizedBox(),
    );
  }

  Widget _buildWithText() {
    // Text with optional icon
    return Row(
      mainAxisAlignment:
          iconCentered ? MainAxisAlignment.center : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          icon is PhosphorIconData
              ? PhosphorIcon(
                  icon as PhosphorIconData,
                  size: iconSize,
                  color: textColor,
                )
              : Icon(icon, size: iconSize, color: textColor),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color textColor;
  final double height;
  final double? width;
  final double borderRadius;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderColor = Colors.green,
    this.textColor = Colors.green,
    this.height = 56,
    this.width,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          side: BorderSide(color: borderColor, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
