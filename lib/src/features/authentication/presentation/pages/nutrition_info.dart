import 'package:flutter/material.dart';

class NutritionInfo extends StatelessWidget {
  const NutritionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Lishe',
            style: TextStyle(
              fontSize: 40,
              color: Color.fromARGB(255, 13, 95, 133),
              fontFamily: 'Inter',
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ));
  }
}
