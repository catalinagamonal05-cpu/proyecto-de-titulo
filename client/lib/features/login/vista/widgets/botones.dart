import 'package:flutter/material.dart';

class Boton extends StatelessWidget {
  final String text;
  final VoidCallback apretar;
  const Boton({super.key, required this.text, required this.apretar});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: apretar,
      style: ElevatedButton.styleFrom(fixedSize: const Size(395, 55)),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}
