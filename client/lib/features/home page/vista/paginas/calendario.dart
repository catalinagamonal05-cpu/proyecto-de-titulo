import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventosPage extends ConsumerStatefulWidget {
  const EventosPage({super.key});

  @override
  ConsumerState<EventosPage> createState() => _EventosPageState();
}

class _EventosPageState extends ConsumerState<EventosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Calendario')));
  }
}
