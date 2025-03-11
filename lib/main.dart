import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lishe_app2/src/features/authentication/presentation/pages/age.dart';
import 'package:lishe_app2/src/features/authentication/presentation/pages/login_page.dart';
import 'package:lishe_app2/src/features/authentication/presentation/pages/nutrition_info.dart';
import 'package:lishe_app2/src/features/authentication/presentation/pages/select_chip.dart';
import 'package:lishe_app2/src/features/bmi/bmi_page.dart';
import 'package:lishe_app2/src/features/food_tracking/presentation/pages/food_tracking_page.dart';
import 'package:lishe_app2/src/features/food_tracking/presentation/pages/setup_page.dart';
import 'package:lishe_app2/src/features/home/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
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
      home: MyHomePage(),
      routes: {
        '/login_page': (context) => MyHomePage(),
        '/home': (context) => HomePage(),
        '/age': (context) => AgeSelection(),
        '/bmi_page': (context) => BmiPage(),
        '/select_chip': (context) => HobbySelector(),
        '/nutrition_info': (context) => NutritionInfo(),
        '/food_tracking': (context) => FoodTrackingPage(),
        '/food_tracking_setup': (context) => FoodTrackingSetupPage(),
      },
    );
  }
}
