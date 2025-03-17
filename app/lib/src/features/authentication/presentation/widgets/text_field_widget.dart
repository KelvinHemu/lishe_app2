import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? label; // Making the label nullable
  final String hintText;
  final Widget leadingicon;
  final TextEditingController fieldController;

  const CustomTextField(
      {super.key,
      this.label,
      required this.hintText,
      required this.leadingicon,
      required this.fieldController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) // Check if label is not null
          Text(
            label!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(47, 48, 54, 1),
            ),
          ),
        if (label != null)
          SizedBox(height: 8), // Add spacing only if label exists
        TextField(
          controller: fieldController,
          decoration: InputDecoration(
            prefixIcon: leadingicon,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
