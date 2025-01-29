import 'package:flutter/material.dart';
import 'package:lishe_app2/src/features/authentication/presentation/pages/age.dart';
import 'package:lishe_app2/src/features/authentication/presentation/pages/login_page.dart';
import 'package:lishe_app2/src/features/authentication/presentation/pages/nutrition_info.dart';
import 'package:lishe_app2/src/features/authentication/presentation/pages/select_chip.dart';
import 'package:lishe_app2/src/features/bmi/bmi_page.dart';

void main() {
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
        '/age': (context) => AgeSelection(),
        '/bmi_page': (context) => BmiPage(),
        '/select_chip': (context) => HobbySelector(),
        '/nutrition_info': (context) => NutritionInfo(),
      },
    );
  }
}
