import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mungoum/core/l10n/app_localizations.dart';

// Scaffold partagé par les 4 écrans principaux (Home, Calendar, 8 days, About).
// L'écran Détail n'utilise pas AppScaffold — il a sa propre AppBar avec bouton retour.
class AppScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;  // 0=Home 1=Calendar 2=EightDays 3=About
  final Widget? bottomWidget; // slot pour la bannière AdMob (optionnel)

  const AppScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
    this.bottomWidget,
  });

  static const _routes = {
    0: '/',
    1: '/calendar',
    2: '/eight-days',
    3: '/about',
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mungoum'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(child: child),
          if (bottomWidget != null) bottomWidget!,
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          final route = _routes[index];
          if (route != null && index != currentIndex) {
            context.go(route);
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            label: l10n.calendar,
          ),
          NavigationDestination(
            icon: const Icon(Icons.format_list_numbered_outlined),
            selectedIcon: const Icon(Icons.format_list_numbered),
            label: l10n.eightDays,
          ),
          NavigationDestination(
            icon: const Icon(Icons.info_outline),
            selectedIcon: const Icon(Icons.info),
            label: l10n.about,
          ),
        ],
      ),
    );
  }
}
