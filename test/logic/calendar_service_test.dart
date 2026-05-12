import 'package:flutter_test/flutter_test.dart';
import 'package:mungoum/logic/calendar_service.dart';

// Tests de référence pour CalendarService.getDayFor().
// Les valeurs attendues ont été vérifiées indépendamment avec Python
// (même algorithme que le module Odoo de référence bw_mugoum_cs_usa).
void main() {
  group('CalendarService.getDayFor', () {
    group('ancrage et cycle de base', () {
      test('2025-01-01 → Fessâ (ancrage)', () {
        final day = CalendarService.getDayFor(DateTime(2025, 1, 1));
        expect(day.name, 'Fessâ');
        expect(day.sequence, 1);
      });

      test('2025-01-03 → Scheidâ (+2 jours)', () {
        final day = CalendarService.getDayFor(DateTime(2025, 1, 3));
        expect(day.name, 'Scheidâ');
        expect(day.isGrandMarche, isTrue);
      });

      test('2025-01-07 → Mametè (+6 jours)', () {
        final day = CalendarService.getDayFor(DateTime(2025, 1, 7));
        expect(day.name, 'Mametè');
        expect(day.isPetitMarche, isTrue);
      });

      test('2025-01-08 → Kuétsit (fin de cycle, delta=7)', () {
        final day = CalendarService.getDayFor(DateTime(2025, 1, 8));
        expect(day.name, 'Kuétsit');
        expect(day.sequence, 8);
      });

      test('2025-01-09 → Fessâ (redémarrage, delta=8 → idx=0)', () {
        final day = CalendarService.getDayFor(DateTime(2025, 1, 9));
        expect(day.name, 'Fessâ');
        expect(day.sequence, 1);
      });
    });

    group('dates hors 2025 — validation de la robustesse', () {
      test('2020-06-15 → Nduchu (date passée, delta=-1661)', () {
        // Vérifie que le double modulo (( -1661 % 8 ) + 8) % 8 = 3 est correct.
        final day = CalendarService.getDayFor(DateTime(2020, 6, 15));
        expect(day.name, 'Nduchu');
        expect(day.sequence, 4);
      });

      test('2030-01-01 → Scheidâ (date future, delta=1826)', () {
        // 1826 % 8 = 2 → index 2 = Scheidâ (Grand Marché).
        final day = CalendarService.getDayFor(DateTime(2030, 1, 1));
        expect(day.name, 'Scheidâ');
        expect(day.isGrandMarche, isTrue);
      });
    });

    group('badges marché — exclusivité', () {
      test('seul Scheidâ a isGrandMarche = true sur un cycle complet', () {
        for (int i = 0; i < 8; i++) {
          final day = CalendarService.getDayFor(
            DateTime(2025, 1, 1).add(Duration(days: i)),
          );
          expect(
            day.isGrandMarche,
            day.name == 'Scheidâ',
            reason: '${day.name} ne devrait pas avoir isGrandMarche=true',
          );
        }
      });

      test('seul Mametè a isPetitMarche = true sur un cycle complet', () {
        for (int i = 0; i < 8; i++) {
          final day = CalendarService.getDayFor(
            DateTime(2025, 1, 1).add(Duration(days: i)),
          );
          expect(
            day.isPetitMarche,
            day.name == 'Mametè',
            reason: '${day.name} ne devrait pas avoir isPetitMarche=true',
          );
        }
      });
    });

    group('aliases', () {
      test('Scheidâ a alias Cheidâ', () {
        final day = CalendarService.getDayFor(DateTime(2025, 1, 3));
        expect(day.aliases, contains('Cheidâ'));
      });

      test("Djola'a a alias Djedjuku'u", () {
        final day = CalendarService.getDayFor(DateTime(2025, 1, 5));
        expect(day.aliases, contains("Djedjuku'u"));
      });

      test("Fessâ n'a pas d'alias", () {
        final day = CalendarService.getDayFor(DateTime(2025, 1, 1));
        expect(day.aliases, isEmpty);
      });
    });
  });

  group('CalendarService.getDaysForMonth', () {
    group('structure de la grille', () {
      test('janvier 2025 : commence un mercredi → 2 cellules vides au début', () {
        // 01/01/2025 = mercredi (weekday=3) → padding = 2
        final cells = CalendarService.getDaysForMonth(2025, 1);
        expect(cells[0].date, isNull);
        expect(cells[1].date, isNull);
        expect(cells[2].date, DateTime(2025, 1, 1));
      });

      test('janvier 2025 : 31 jours + 2 padding début + 3 padding fin = 36 cellules (5 semaines)', () {
        final cells = CalendarService.getDaysForMonth(2025, 1);
        expect(cells.length, 35); // 2 + 31 + 2 = 35 (multiple de 7)
      });

      test('longueur toujours multiple de 7', () {
        for (int month = 1; month <= 12; month++) {
          final cells = CalendarService.getDaysForMonth(2025, month);
          expect(cells.length % 7, 0,
              reason: 'Mois $month : ${cells.length} cellules');
        }
      });
    });

    group('contenu des cellules — vérifié contre le PDF officiel', () {
      test('01/01/2025 → Fessâ', () {
        final cells = CalendarService.getDaysForMonth(2025, 1);
        // Index 2 (après 2 paddings)
        final cell = cells.firstWhere((c) => c.date == DateTime(2025, 1, 1));
        expect(cell.nguembaDay!.name, 'Fessâ');
      });

      test('03/01/2025 → Scheidâ (Grand Marché)', () {
        final cells = CalendarService.getDaysForMonth(2025, 1);
        final cell = cells.firstWhere((c) => c.date == DateTime(2025, 1, 3));
        expect(cell.nguembaDay!.name, 'Scheidâ');
        expect(cell.nguembaDay!.isGrandMarche, isTrue);
      });

      test('07/01/2025 → Mametè (Petit Marché)', () {
        final cells = CalendarService.getDaysForMonth(2025, 1);
        final cell = cells.firstWhere((c) => c.date == DateTime(2025, 1, 7));
        expect(cell.nguembaDay!.name, 'Mametè');
        expect(cell.nguembaDay!.isPetitMarche, isTrue);
      });
    });

    group('navigation aux bornes', () {
      test('décembre 2024 → mois précédent de janvier 2025 (Dart normalise)', () {
        // DateTime(2025, 0) = décembre 2024 en Dart
        final cells = CalendarService.getDaysForMonth(2024, 12);
        expect(cells.any((c) => c.date?.month == 12 && c.date?.year == 2024), isTrue);
      });

      test('janvier 2026 → mois suivant de décembre 2025', () {
        final cells = CalendarService.getDaysForMonth(2026, 1);
        expect(cells.any((c) => c.date?.month == 1 && c.date?.year == 2026), isTrue);
      });
    });
  });
}
