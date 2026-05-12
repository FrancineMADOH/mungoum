import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mungoum/features/home/home_screen.dart';
import 'package:mungoum/features/calendar/calendar_screen.dart';
import 'package:mungoum/features/day_detail/day_detail_screen.dart';
import 'package:mungoum/features/eight_days/eight_days_screen.dart';
import 'package:mungoum/features/about/about_screen.dart';

// All 5 routes are flat (not nested) — each screen manages its own Scaffold.
// DayDetailScreen receives the selected date via GoRouter `extra`, not query params,
// to avoid serialising DateTime objects into the URL.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page introuvable — ${state.uri}')),
  ),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/calendar',
      builder: (context, state) => const CalendarScreen(),
    ),
    GoRoute(
      // /calendar/day is intentionally a separate route, not a nested one.
      // The CalendarScreen stays in the history stack; back() returns to it.
      path: '/calendar/day',
      builder: (context, state) {
        // extra is typed as Map to carry: date, nguembaDay, sourceMonth.
        // Guarded cast: if the caller passes wrong type, fall back to null
        // rather than throwing at runtime.
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
