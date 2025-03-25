import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/navigation_provider.dart';
import 'routes/app_router.dart';

final navigationProvider = ChangeNotifierProvider(
  (ref) => NavigationProvider(),
);

class LisheApp extends ConsumerWidget {
  const LisheApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // You can listen to auth state here later
    // final authState = ref.watch(authProvider);

    return MaterialApp.router(
      title: 'Lishe App',
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                Brightness.dark, // Adjust based on light/dark theme
            statusBarBrightness:
                Brightness.light, // Adjust based on light/dark theme
          ),
          child: child!,
        );
      },
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppTheme {
  // ignore: prefer_typing_uninitialized_variables
  static var lightTheme;

  // ignore: prefer_typing_uninitialized_variables
  static var darkTheme;
}
