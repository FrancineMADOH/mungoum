import 'package:flutter/material.dart';
import 'package:mungoum/shared/widgets/app_scaffold.dart';

class EightDaysScreen extends StatelessWidget {
  const EightDaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      currentIndex: 2,
      child: Center(child: Text('Les 8 jours — F5')),
    );
  }
}
