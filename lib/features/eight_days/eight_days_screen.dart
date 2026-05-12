import 'package:flutter/material.dart';

class EightDaysScreen extends StatelessWidget {
  const EightDaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Les 8 jours')),
      body: const Center(child: Text('Les 8 jours — F5')),
    );
  }
}
