import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lishe_app2/src/features/authentication/presentation/pages/age.dart';
import 'package:lishe_app2/src/features/authentication/presentation/pages/login_page.dart';
import 'package:lishe_app2/src/features/authentication/presentation/pages/nutrition_info.dart';
import 'package:lishe_app2/src/features/authentication/presentation/pages/select_chip.dart';
import 'package:lishe_app2/src/features/bmi/bmi_page.dart';

import 'package:lishe_app2/src/features/navigation/presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lishe App2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color.fromARGB(255, 81, 170, 243),
      ),
      home: const MyHomePage(),
      routes: {
        '/login_page': (context) => const MyHomePage(),
        '/home': (context) => const MainScreen(),
        '/age': (context) => const AgeSelection(),
        '/bmi_page': (context) => const BmiPage(),
        '/select_chip': (context) => const HobbySelector(),
        '/nutrition_info': (context) => const NutritionInfo(),
      },
    );
  }
}
