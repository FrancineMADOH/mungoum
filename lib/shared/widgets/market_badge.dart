import 'package:flutter/material.dart';
import 'package:mungoum/core/l10n/app_localizations.dart';
import 'package:mungoum/core/theme/app_theme.dart';
import 'package:mungoum/data/models/nguemba_day.dart';

// Badge affiché uniquement les jours de marché.
// Retourne SizedBox.shrink() si le jour n'est pas un jour de marché,
// pour ne laisser aucun espace vide dans le layout.
class MarketBadgeWidget extends StatelessWidget {
  final NguembaDay day;

  const MarketBadgeWidget({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (day.isGrandMarche) {
      return _Badge(
        label: l10n.grandMarket,
        background: AppColors.indigoLight,
        foreground: AppColors.cream,
      );
    }

    if (day.isPetitMarche) {
      return _Badge(
        label: l10n.petitMarket,
        background: AppColors.amberGold,
        foreground: AppColors.anthracite,
      );
    }

    return const SizedBox.shrink();
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;

  const _Badge({
    required this.label,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: foreground,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}
