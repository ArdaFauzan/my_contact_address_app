import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isNumber;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.isNumber = false, // Default is text (not a number)
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) {
        // Validation 1: If the field is empty
        if (value == null || value.isEmpty) {
          return 'Please fill this field';
        }

        // Validation 2: Check if input contains only numbers (only if isNumber is true)
        if (isNumber && !RegExp(r'^[0-9]+$').hasMatch(value)) {
          return 'Please enter numbers only';
        }

        return null;
      },
    );
  }
}
