import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mungoum/core/l10n/app_localizations.dart';
import 'package:mungoum/core/theme/app_theme.dart';
import 'package:mungoum/data/datasources/nguemba_data.dart';
import 'package:mungoum/data/models/nguemba_day.dart';
import 'package:mungoum/shared/widgets/app_scaffold.dart';
import 'package:mungoum/shared/widgets/market_badge.dart';

class EightDaysScreen extends StatelessWidget {
  const EightDaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 2,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: nguembaDays.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
        itemBuilder: (context, index) => _DayListItem(
          day: nguembaDays[index],
        ),
      ),
    );
  }
}

class _DayListItem extends StatelessWidget {
  final NguembaDay day;

  const _DayListItem({required this.day});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () => context.push(
        '/calendar/day',
        // date: null → DayDetailScreen affiche le nom nguemba dans l'AppBar.
        extra: {'date': null, 'day': day},
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _SequenceBadge(sequence: day.sequence),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  if (day.aliases.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      '${l10n.alsoKnownAs} ${day.aliases.join(' · ')}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            MarketBadgeWidget(day: day),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35),
            ),
          ],
        ),
      ),
    );
  }
}

// Cercle indigo avec le numéro de séquence — identifiant visuel du jour dans le cycle.
class _SequenceBadge extends StatelessWidget {
  final int sequence;
  const _SequenceBadge({required this.sequence});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: AppColors.indigoNight,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$sequence',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.cream,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
