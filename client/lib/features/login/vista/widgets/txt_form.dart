import 'package:flutter/material.dart';

class TxtForm extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  const TxtForm({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscureText,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ingresa $hintText por favor';
        }
        return null;
      },
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
