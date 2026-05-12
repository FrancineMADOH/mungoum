import 'package:flutter/material.dart';

class DayDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? extra;

  const DayDetailScreen({super.key, this.extra});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détail')),
      body: const Center(child: Text('Détail du jour — F4')),
    );
  }
}
