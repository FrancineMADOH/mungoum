import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mungoum/core/l10n/app_localizations.dart';
import 'package:mungoum/core/theme/app_theme.dart';
import 'package:mungoum/data/models/nguemba_day.dart';
import 'package:mungoum/logic/calendar_service.dart';
import 'package:mungoum/shared/widgets/ad_banner.dart';
import 'package:mungoum/shared/widgets/app_scaffold.dart';
import 'package:mungoum/shared/widgets/market_badge.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final nguembaDay = CalendarService.getDayFor(today);

    return AppScaffold(
      currentIndex: 0,
      bottomWidget: const AdBannerWidget(),
      child: _HomeBody(today: today, day: nguembaDay),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final DateTime today;
  final NguembaDay day;

  const _HomeBody({required this.today, required this.day});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    // DateFormat.yMMMMEEEEd : "mercredi 12 mai 2026" / "Wednesday, May 12, 2026"
    final formattedDate = DateFormat.yMMMMEEEEd(locale).format(today);

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Logo(),
              const SizedBox(height: 40),
              _TodayLabel(label: l10n.today),
              const SizedBox(height: 8),
              _DayName(name: day.name),
              const SizedBox(height: 16),
              MarketBadgeWidget(day: day),
              const SizedBox(height: 24),
              _GregorianDate(date: formattedDate),
              const SizedBox(height: 40),
              _CalendarButton(label: l10n.seeCalendar),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      height: 100,
      width: 100,
      fit: BoxFit.contain,
      semanticLabel: 'Logo Mungoum',
    );
  }
}

class _TodayLabel extends StatelessWidget {
  final String label;
  const _TodayLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.amberGold,
            letterSpacing: 1.2,
          ),
    );
  }
}

class _DayName extends StatelessWidget {
  final String name;
  const _DayName({required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayMedium,
    );
  }
}

class _GregorianDate extends StatelessWidget {
  final String date;
  const _GregorianDate({required this.date});

  @override
  Widget build(BuildContext context) {
    return Text(
      date,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
    );
  }
}

class _CalendarButton extends StatelessWidget {
  final String label;
  const _CalendarButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => context.go('/calendar'),
      icon: const Icon(Icons.calendar_month_outlined),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
