import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lishe_app/core/common/services/service_locator.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  serviceLocator.setup();

  runApp(
    // Add ProviderScope for Riverpod
    const ProviderScope(child: LisheApp()),
  );
}
