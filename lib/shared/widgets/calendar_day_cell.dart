import 'package:flutter/material.dart';
import 'package:mungoum/core/theme/app_theme.dart';
import 'package:mungoum/data/models/nguemba_day.dart';

class CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final NguembaDay nguembaDay;
  final bool isToday;
  final VoidCallback onTap;

  const CalendarDayCell({
    super.key,
    required this.date,
    required this.nguembaDay,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // Fond ambre semi-transparent sur la case d'aujourd'hui.
          color: isToday
              ? AppColors.amberGold.withValues(alpha: 0.15)
              : Colors.transparent,
          border: Border.all(
            color: isToday
                ? AppColors.amberGold
                : colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: isToday ? 1.5 : 0.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Numéro du jour grégorien
            Text(
              '${date.day}',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                color: isToday ? AppColors.amberGold : colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            // Nom nguemba complet — réduit si la case est trop étroite.
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                nguembaDay.name,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 9,
                  color: colorScheme.onSurface.withValues(alpha: 0.75),
                ),
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 2),
            // Indicateur marché : petit rond coloré
            _MarketDot(nguembaDay: nguembaDay),
          ],
        ),
      ),
    );
  }
}

// Petit point coloré sous le nom nguemba pour indiquer un jour de marché.
// Invisible (SizedBox.shrink) les autres jours pour garder la hauteur des cellules uniforme.
class _MarketDot extends StatelessWidget {
  final NguembaDay nguembaDay;
  const _MarketDot({required this.nguembaDay});

  @override
  Widget build(BuildContext context) {
    if (nguembaDay.isGrandMarche) {
      return _dot(AppColors.indigoLight);
    }
    if (nguembaDay.isPetitMarche) {
      return _dot(AppColors.amberGold);
    }
    // Espace réservé pour garder la hauteur des cellules constante.
    return const SizedBox(height: 5);
  }

  Widget _dot(Color color) => Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}
