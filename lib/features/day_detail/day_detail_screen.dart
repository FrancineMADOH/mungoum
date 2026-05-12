import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mungoum/core/l10n/app_localizations.dart';
import 'package:mungoum/core/theme/app_theme.dart';
import 'package:mungoum/data/models/nguemba_day.dart';
import 'package:mungoum/shared/widgets/market_badge.dart';

class DayDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? extra;

  const DayDetailScreen({super.key, this.extra});

  @override
  Widget build(BuildContext context) {
    final date = extra?['date'] as DateTime?;
    final day = extra?['day'] as NguembaDay?;

    // Cas défensif : données manquantes → retour immédiat.
    if (day == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.pop());
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    final appBarTitle = date != null
        ? _formatDate(date, locale)
        : day.name;

    return Scaffold(
      appBar: AppBar(
        // Le back button est auto-géré par GoRouter (on a utilisé push).
        title: Text(appBarTitle),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _Logo(),
                const SizedBox(height: 32),
                _DayName(name: day.name),
                if (day.aliases.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _AliasLine(aliases: day.aliases, l10n: l10n),
                ],
                const SizedBox(height: 20),
                MarketBadgeWidget(day: day),
                const SizedBox(height: 40),
                const Divider(),
                const SizedBox(height: 24),
                _CulturalSection(l10n: l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Format court : "mercredi 3 janvier 2025" / "Wednesday, January 3, 2025"
  String _formatDate(DateTime date, String locale) =>
      DateFormat.yMMMMEEEEd(locale).format(date);
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      height: 80,
      width: 80,
      fit: BoxFit.contain,
      semanticLabel: 'Logo Mungoum',
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

class _AliasLine extends StatelessWidget {
  final List<String> aliases;
  final AppLocalizations l10n;

  const _AliasLine({required this.aliases, required this.l10n});

  @override
  Widget build(BuildContext context) {
    // Plusieurs aliases séparés par " · " (prévu pour les données futures).
    final aliasText = aliases.join(' · ');

    return Text(
      '${l10n.alsoKnownAs} $aliasText',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.65),
            fontStyle: FontStyle.italic,
          ),
    );
  }
}

class _CulturalSection extends StatelessWidget {
  final AppLocalizations l10n;
  const _CulturalSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.culturalMeaning,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.amberGold,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.comingSoon,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }
}
