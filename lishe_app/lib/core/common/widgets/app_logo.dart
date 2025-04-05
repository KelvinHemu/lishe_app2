import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final double fontSize;

  const AppLogo({
    super.key,
    this.size = 80,
    this.showText = true,
    this.fontSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: size,
          width: size,
          errorBuilder:
              (context, error, stackTrace) => Icon(
                Icons.eco,
                size: size,
                color: const Color.fromRGBO(20, 49, 26, 1),
              ),
        ),
        if (showText)
          const Text(
            "LISHE",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Color.fromRGBO(20, 49, 26, 1),
            ),
          ),
      ],
    );
  }
}
