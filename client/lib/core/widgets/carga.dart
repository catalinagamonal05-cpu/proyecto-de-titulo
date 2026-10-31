import 'package:flutter/material.dart';

class Carga extends StatelessWidget {
  const Carga({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}
