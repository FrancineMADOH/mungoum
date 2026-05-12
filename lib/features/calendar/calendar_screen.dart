import 'package:flutter/material.dart';
import 'package:mungoum/shared/widgets/app_scaffold.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      currentIndex: 1,
      child: Center(child: Text('Calendrier mensuel — F3')),
    );
  }
}
