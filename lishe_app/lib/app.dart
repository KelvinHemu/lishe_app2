import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lishe_app/core/common/providers/navigation_provider.dart';
import 'package:lishe_app/core/common/routes/app_router.dart';

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
