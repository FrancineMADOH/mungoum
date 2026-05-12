import 'package:flutter/material.dart';
import 'package:mungoum/shared/widgets/app_scaffold.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      currentIndex: 3,
      child: Center(child: Text('À propos — F6')),
    );
  }
}
