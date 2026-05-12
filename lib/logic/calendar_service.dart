import 'package:mungoum/data/datasources/nguemba_data.dart';
import 'package:mungoum/data/models/nguemba_day.dart';

// Représente une case de la grille calendrier.
// date = null pour les cases vides de padding (début/fin de semaine).
typedef CalendarCell = ({DateTime? date, NguembaDay? nguembaDay});

abstract final class CalendarService {
  // Ancrage vérifié sur le PDF officiel : 2025-01-01 = Fessâ (index 0).
  // Changer cette valeur invaliderait tout le calendrier — ne pas modifier
  // sans re-vérifier sur le document source.
  static final _anchor = DateTime.utc(2025, 1, 1);

  /// Retourne le jour nguemba correspondant à [date].
  ///
  /// Fonctionne pour toute date, passée ou future.
  static NguembaDay getDayFor(DateTime date) {
    // Normalisation UTC : on extrait uniquement year/month/day et on force UTC.
    // Sans ça, DateTime.now() en UTC+1 à 23h30 serait déjà "demain" en UTC,
    // ce qui décalerait le calcul d'un jour selon le fuseau horaire de l'appareil.
    final utcDate = DateTime.utc(date.year, date.month, date.day);
    final delta = utcDate.difference(_anchor).inDays;

    // ((delta % 8) + 8) % 8 : double modulo pour gérer les deltas négatifs.
    // En Dart, contrairement à Python, l'opérateur % retourne un résultat négatif
    // si l'opérande gauche est négatif. Exemple : -1 % 8 = -1 en Dart, 7 en Python.
    // Le +8 garantit un index toujours dans [0, 7] pour les dates avant 2025.
    final idx = ((delta % 8) + 8) % 8;
    return nguembaDays[idx];
  }

  /// Retourne la liste des cellules pour un mois complet.
  ///
  /// La liste est toujours un multiple de 7 (semaines complètes).
  /// Les cellules vides de début/fin de mois ont date=null et nguembaDay=null.
  /// La semaine commence le lundi (weekday=1).
  static List<CalendarCell> getDaysForMonth(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    // DateTime(year, month + 1, 0) = dernier jour du mois ; Dart normalise automatiquement.
    final daysInMonth = DateTime(year, month + 1, 0).day;

    // weekday : lundi=1 … dimanche=7. Padding = nombre de cases vides avant le 1er.
    final startPadding = firstDay.weekday - 1;

    final cells = <CalendarCell>[];

    for (int i = 0; i < startPadding; i++) {
      cells.add((date: null, nguembaDay: null));
    }

    for (int d = 1; d <= daysInMonth; d++) {
      final date = DateTime(year, month, d);
      cells.add((date: date, nguembaDay: getDayFor(date)));
    }

    // Complète la dernière semaine pour avoir un multiple de 7.
    while (cells.length % 7 != 0) {
      cells.add((date: null, nguembaDay: null));
    }

    return cells;
  }
}
