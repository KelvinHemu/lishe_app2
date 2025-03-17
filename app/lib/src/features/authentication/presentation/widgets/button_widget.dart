import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    super.key,
    this.text = 'Select Date',
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onClicked,
        child: Text(text),
      );
}
