import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  serviceLocator.setup();

  runApp(
    // Add ProviderScope for Riverpod
    const ProviderScope(child: LisheApp()),
  );
}
