import 'package:mungoum/data/models/nguemba_day.dart';

// Les 8 jours dans l'ordre exact du cycle nguemba.
// Index 0 = Fessâ = ancrage 2025-01-01 (vérifié sur le PDF officiel).
// L'ordre ici est la source de vérité — CalendarService.getDayFor() indexe
// directement dans cette liste via le modulo 8.
//
// Slugs : identifiants stables sans accents ni apostrophes, utilisés par
// GoRouter (/calendar/day) et comme clés d'assets futurs (images, sons).
const List<NguembaDay> nguembaDays = [
  NguembaDay(
    sequence: 1,
    name: 'Fessâ',
    slug: 'fessa',
  ),
  NguembaDay(
    sequence: 2,
    name: 'Fessap',
    slug: 'fessap',
  ),
  NguembaDay(
    sequence: 3,
    name: 'Scheidâ',
    slug: 'scheida',
    aliases: ['Cheidâ'],
    isGrandMarche: true,
  ),
  NguembaDay(
    sequence: 4,
    name: 'Nduchu',
    slug: 'nduchu',
  ),
  NguembaDay(
    sequence: 5,
    name: "Djola'a",
    slug: 'djolaa', // apostrophe supprimée — invalide dans les URLs et noms de fichiers
    aliases: ["Djedjuku'u"],
  ),
  NguembaDay(
    sequence: 6,
    name: 'Mumetè',
    slug: 'mumete',
  ),
  NguembaDay(
    sequence: 7,
    name: 'Mametè',
    slug: 'mamete',
    isPetitMarche: true,
  ),
  NguembaDay(
    sequence: 8,
    name: 'Kuétsit',
    slug: 'kuetsit',
  ),
];
