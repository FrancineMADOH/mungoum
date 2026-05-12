import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mungoum/core/l10n/app_localizations.dart';
import 'package:mungoum/logic/calendar_service.dart';
import 'package:mungoum/shared/widgets/ad_banner.dart';
import 'package:mungoum/shared/widgets/app_scaffold.dart';
import 'package:mungoum/shared/widgets/calendar_day_cell.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // Mois affiché — initialisé au mois courant.
  late DateTime _displayedMonth;
  final DateTime _today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(_today.year, _today.month);
  }

  void _goToPreviousMonth() {
    setState(() {
      // Dart normalise : DateTime(2025, 0) = décembre 2024.
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cells = CalendarService.getDaysForMonth(
      _displayedMonth.year,
      _displayedMonth.month,
    );

    return AppScaffold(
      currentIndex: 1,
      bottomWidget: const AdBannerWidget(),
      child: Column(
        children: [
          _MonthHeader(
            displayedMonth: _displayedMonth,
            onPrevious: _goToPreviousMonth,
            onNext: _goToNextMonth,
          ),
          _WeekDayHeaders(),
          Expanded(
            child: _CalendarGrid(
              cells: cells,
              today: _today,
            ),
          ),
        ],
      ),
    );
  }
}

// En-tête avec mois/année et flèches de navigation.
class _MonthHeader extends StatelessWidget {
  final DateTime displayedMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _MonthHeader({
    required this.displayedMonth,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    // "Mai 2026" / "May 2026" — première lettre en majuscule.
    final label = DateFormat.yMMMM(locale).format(displayedMonth);
    final capitalized = label[0].toUpperCase() + label.substring(1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrevious,
            tooltip: AppLocalizations.of(context)!.previousMonth,
          ),
          Text(
            capitalized,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNext,
            tooltip: AppLocalizations.of(context)!.nextMonth,
          ),
        ],
      ),
    );
  }
}

// Ligne des en-têtes de jours de la semaine (Lun → Dim).
// StatefulWidget so that the 7 DateFormat calls are cached and only
// recomputed when the locale actually changes (not on every rebuild).
class _WeekDayHeaders extends StatefulWidget {
  @override
  State<_WeekDayHeaders> createState() => _WeekDayHeadersState();
}

class _WeekDayHeadersState extends State<_WeekDayHeaders> {
  // Cached locale string — compared in didChangeDependencies to detect changes.
  String? _cachedLocale;
  // Cached localised day abbreviations (Monday → Sunday).
  late List<String> _labels;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context).toString();
    if (locale != _cachedLocale) {
      _cachedLocale = locale;
      // DateFormat.E gives localised abbreviations (Lun / Mon …) via intl.
      // 2024-01-01 is a Monday — verified by the assert below.
      assert(
        DateTime(2024, 1, 1).weekday == DateTime.monday,
        '2024-01-01 must be a Monday',
      );
      _labels = List.generate(7, (i) {
        final day = DateTime(2024, 1, 1).add(Duration(days: i));
        return DateFormat.E(locale).format(day);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
      child: Row(
        children: _labels
            .map(
              (d) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    d,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// Grille des jours — Table à 7 colonnes de largeur égale.
class _CalendarGrid extends StatelessWidget {
  final List<CalendarCell> cells;
  final DateTime today;

  const _CalendarGrid({required this.cells, required this.today});

  bool _isToday(DateTime? date) =>
      date != null &&
      date.year == today.year &&
      date.month == today.month &&
      date.day == today.day;

  @override
  Widget build(BuildContext context) {
    // Découpe la liste plate en rangées de 7.
    final rows = <TableRow>[];
    for (int i = 0; i < cells.length; i += 7) {
      final rowCells = cells.sublist(i, i + 7);
      rows.add(TableRow(
        children: rowCells.map((cell) {
          if (cell.date == null) {
            // Case vide de padding — fond discret.
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withValues(alpha: 0.15),
                  width: 0.5,
                ),
              ),
            );
          }
          return CalendarDayCell(
            date: cell.date!,
            nguembaDay: cell.nguembaDay!,
            isToday: _isToday(cell.date),
            onTap: () => context.push(
              '/calendar/day',
              extra: {
                'date': cell.date,
                'day': cell.nguembaDay,
              },
            ),
          );
        }).toList(),
      ));
    }

    return SingleChildScrollView(
      child: Table(
        // columnWidths vide = toutes les colonnes en largeur égale (FlexColumnWidth par défaut).
        border: TableBorder.all(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant
              .withValues(alpha: 0.2),
          width: 0.5,
        ),
        children: rows,
      ),
    );
  }
}
