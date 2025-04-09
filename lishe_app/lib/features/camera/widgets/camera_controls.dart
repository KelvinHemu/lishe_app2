import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lishe_app/features/camera/providers/camera_provider.dart';

class CameraControls extends ConsumerWidget {
  final VoidCallback onClose;

  const CameraControls({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraNotifier = ref.read(cameraProvider.notifier);
    final flashMode = cameraNotifier.flashMode;
    final currentZoom = cameraNotifier.currentZoom;

    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Close button
          CircleButton(
            icon: Icons.close,
            onTap: onClose,
          ),

          // Controls row
          Row(
            children: [
              // Flash control
              CircleButton(
                icon: _getFlashIcon(flashMode),
                onTap: () {
                  cameraNotifier.toggleFlash();
                  // Force rebuild to update UI
                  ref.read(cameraProvider.notifier);
                },
              ),

              const SizedBox(width: 16),

              // Zoom control
              CircleButton(
                label: '${currentZoom.toStringAsFixed(1)}x',
                onTap: () {
                  cameraNotifier.adjustZoom();
                  // Force rebuild to update UI
                  ref.read(cameraProvider.notifier);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to get the appropriate flash icon
  IconData _getFlashIcon(FlashMode mode) {
    switch (mode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.torch:
        return Icons.highlight;
      default:
        return Icons.flash_off;
    }
  }
}

// A circular button with optional icon or text label
class CircleButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final VoidCallback onTap;

  const CircleButton({
    Key? key,
    this.icon,
    this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, color: Colors.white, size: 24)
              : Text(
                  label ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
        ),
      ),
    );
  }
}
