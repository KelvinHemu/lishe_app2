import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final BorderSide? borderSide;

  const AppCard({
    super.key,
    required this.child,
    this.width = 170,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 170,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10),
        border: Border.fromBorderSide(borderSide ?? BorderSide.none),
      ),
      child: child,
    );
  }
}
