import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mungoum/core/l10n/app_localizations.dart';
import 'package:mungoum/core/theme/app_theme.dart';
import 'package:mungoum/data/datasources/nguemba_data.dart';
import 'package:mungoum/logic/calendar_service.dart';
import 'package:mungoum/shared/widgets/market_badge.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: buildLightTheme(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  group('MarketBadgeWidget', () {
    testWidgets('affiche un badge pour Scheidâ (Grand Marché)', (tester) async {
      final scheida = CalendarService.getDayFor(DateTime(2025, 1, 3));
      await tester.pumpWidget(_wrap(MarketBadgeWidget(day: scheida)));
      await tester.pumpAndSettle();
      // Un Container visible avec du texte (pas SizedBox.shrink)
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('affiche un badge pour Mametè (Petit Marché)', (tester) async {
      final mamete = CalendarService.getDayFor(DateTime(2025, 1, 7));
      await tester.pumpWidget(_wrap(MarketBadgeWidget(day: mamete)));
      await tester.pumpAndSettle();
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('SizedBox.shrink pour un jour sans marché', (tester) async {
      final fessa = CalendarService.getDayFor(DateTime(2025, 1, 1));
      await tester.pumpWidget(_wrap(MarketBadgeWidget(day: fessa)));
      await tester.pumpAndSettle();
      expect(find.byType(Text), findsNothing);
    });

    test('exactement 2 jours de marché sur les 8', () {
      int marcheCount = 0;
      for (final day in nguembaDays) {
        if (day.isGrandMarche || day.isPetitMarche) marcheCount++;
      }
      expect(marcheCount, 2);
    });

    test('seul Scheidâ a isGrandMarche', () {
      final grandMarche = nguembaDays.where((d) => d.isGrandMarche).toList();
      expect(grandMarche.length, 1);
      expect(grandMarche.first.name, 'Scheidâ');
    });

    test('seul Mametè a isPetitMarche', () {
      final petitMarche = nguembaDays.where((d) => d.isPetitMarche).toList();
      expect(petitMarche.length, 1);
      expect(petitMarche.first.name, 'Mametè');
    });
  });
}
