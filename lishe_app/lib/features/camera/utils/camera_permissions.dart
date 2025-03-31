import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPermissions {
  static Future<bool> checkAndRequestPermission(BuildContext context) async {
    var status = await Permission.camera.status;

    // First time requesting (status is denied but not permanently)
    if (status.isDenied) {
      // Show explanation dialog before requesting permission
      bool shouldRequest =
          await showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Camera Permission'),
                  content: const Text(
                    'This app uses your camera to identify food items and provide '
                    'nutritional information. We need your permission to access the camera.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Deny'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Allow'),
                    ),
                  ],
                ),
          ) ??
          false;

      if (shouldRequest) {
        status = await Permission.camera.request();
        return status.isGranted;
      }
      return false;
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Camera permission is permanently denied. Please enable it in app settings.',
          ),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () => openAppSettings(),
          ),
        ),
      );
      return false;
    }

    return status.isGranted;
  }
}
