// NguembaDay est déclaré const pour deux raisons :
// 1. Les 8 instances vivent dans `nguemba_data.dart` comme constantes de compilation.
// 2. Dart canonicalise les objets const — deux appels à getDayFor() pour le même
//    jour retournent *le même objet en mémoire*, donc l'égalité par identité (==)
//    fonctionne sans avoir à implémenter hashCode/==.
class NguembaDay {
  final int sequence;       // Position dans le cycle : 1 (Fessâ) → 8 (Kuétsit)
  final String name;        // Nom officiel nguemba — jamais traduit
  final String slug;        // Identifiant URL-safe sans accents ni apostrophes
  final List<String> aliases;
  final bool isGrandMarche;
  final bool isPetitMarche;
  // Descriptions nullables : contenu à collecter en Phase 2.
  // Null = le widget affiche le placeholder "Contenu à venir".
  final String? descriptionFr;
  final String? descriptionEn;

  const NguembaDay({
    required this.sequence,
    required this.name,
    required this.slug,
    this.aliases = const [],
    this.isGrandMarche = false,
    this.isPetitMarche = false,
    this.descriptionFr,
    this.descriptionEn,
  });
}
