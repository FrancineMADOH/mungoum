import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mungoum/core/l10n/app_localizations.dart';
import 'package:mungoum/features/splash/splash_screen.dart';
import 'package:mungoum/features/home/home_screen.dart';
import 'package:mungoum/features/calendar/calendar_screen.dart';
import 'package:mungoum/features/day_detail/day_detail_screen.dart';
import 'package:mungoum/features/eight_days/eight_days_screen.dart';
import 'package:mungoum/features/about/about_screen.dart';

// All routes are flat — each screen manages its own Scaffold.
// DayDetailScreen receives data via GoRouter `extra` (not query params)
// to avoid serialising DateTime/NguembaDay into the URL.
final GoRouter appRouter = GoRouter(
  // Le splash est l'écran de démarrage — il navigue vers '/' après l'animation.
  initialLocation: '/splash',
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text(AppLocalizations.of(context)?.pageNotFound ?? 'Page not found'),
    ),
  ),
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/calendar',
      builder: (context, state) => const CalendarScreen(),
    ),
    GoRoute(
      // /calendar/day is intentionally a separate route, not nested.
      // The CalendarScreen stays in the history stack; back() returns to it.
      path: '/calendar/day',
      builder: (context, state) {
        final extra = state.extra is Map<String, dynamic>
            ? state.extra as Map<String, dynamic>
            : null;
        return DayDetailScreen(extra: extra);
      },
    ),
    GoRoute(
      path: '/eight-days',
      builder: (context, state) => const EightDaysScreen(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutScreen(),
    ),
  ],
);
