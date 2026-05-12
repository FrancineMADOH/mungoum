import 'package:mungoum/data/datasources/nguemba_data.dart';
import 'package:mungoum/data/models/nguemba_day.dart';

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
}
