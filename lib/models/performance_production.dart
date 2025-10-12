import 'package:cloud_firestore/cloud_firestore.dart';

/// Modèle pour la performance de production (suivi personnalisé)
class PerformanceProduction {
  final String id;
  final String sellerId;
  final List<FicheTechnique> fichesTechniques;
  final List<RappelProduction> rappels;
  final DateTime dateCalcul;

  PerformanceProduction({
    required this.id,
    required this.sellerId,
    required this.fichesTechniques,
    required this.rappels,
    required this.dateCalcul,
  });

  factory PerformanceProduction.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return PerformanceProduction(
      id: doc.id,
      sellerId: data['sellerId'] ?? '',
      fichesTechniques: (data['fichesTechniques'] as List<dynamic>?)
              ?.map((e) => FicheTechnique.fromMap(e))
              .toList() ??
          [],
      rappels: (data['rappels'] as List<dynamic>?)
              ?.map((e) => RappelProduction.fromMap(e))
              .toList() ??
          [],
      dateCalcul:
          (data['dateCalcul'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'fichesTechniques': fichesTechniques.map((e) => e.toMap()).toList(),
      'rappels': rappels.map((e) => e.toMap()).toList(),
      'dateCalcul': Timestamp.fromDate(dateCalcul),
    };
  }
}

/// Fiche technique pour une espèce
class FicheTechnique {
  final String id;
  final String espece; // poulet, canard, etc.
  final int quantite;
  final List<Vaccination> vaccinations;
  final List<Accouplement> accouplements;
  final List<PeriodeRecolte> periodesRecolte;
  final Map<String, dynamic> statistiques;

  FicheTechnique({
    required this.id,
    required this.espece,
    required this.quantite,
    required this.vaccinations,
    required this.accouplements,
    required this.periodesRecolte,
    required this.statistiques,
  });

  factory FicheTechnique.fromMap(Map<String, dynamic> map) {
    return FicheTechnique(
      id: map['id'] ?? '',
      espece: map['espece'] ?? '',
      quantite: map['quantite'] ?? 0,
      vaccinations: (map['vaccinations'] as List<dynamic>?)
              ?.map((e) => Vaccination.fromMap(e))
              .toList() ??
          [],
      accouplements: (map['accouplements'] as List<dynamic>?)
              ?.map((e) => Accouplement.fromMap(e))
              .toList() ??
          [],
      periodesRecolte: (map['periodesRecolte'] as List<dynamic>?)
              ?.map((e) => PeriodeRecolte.fromMap(e))
              .toList() ??
          [],
      statistiques: map['statistiques'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'espece': espece,
      'quantite': quantite,
      'vaccinations': vaccinations.map((e) => e.toMap()).toList(),
      'accouplements': accouplements.map((e) => e.toMap()).toList(),
      'periodesRecolte': periodesRecolte.map((e) => e.toMap()).toList(),
      'statistiques': statistiques,
    };
  }
}

/// Vaccination
class Vaccination {
  final String nom;
  final DateTime datePrevue;
  final DateTime? dateRealisee;
  final bool effectuee;
  final String? notes;

  Vaccination({
    required this.nom,
    required this.datePrevue,
    this.dateRealisee,
    required this.effectuee,
    this.notes,
  });

  factory Vaccination.fromMap(Map<String, dynamic> map) {
    return Vaccination(
      nom: map['nom'] ?? '',
      datePrevue: (map['datePrevue'] as Timestamp).toDate(),
      dateRealisee: (map['dateRealisee'] as Timestamp?)?.toDate(),
      effectuee: map['effectuee'] ?? false,
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'datePrevue': Timestamp.fromDate(datePrevue),
      'dateRealisee':
          dateRealisee != null ? Timestamp.fromDate(dateRealisee!) : null,
      'effectuee': effectuee,
      'notes': notes,
    };
  }
}

/// Accouplement
class Accouplement {
  final DateTime date;
  final int nombreMales;
  final int nombreFemelles;
  final DateTime dateEclosionPrevue;
  final int? nombreOeufs;
  final String? notes;

  Accouplement({
    required this.date,
    required this.nombreMales,
    required this.nombreFemelles,
    required this.dateEclosionPrevue,
    this.nombreOeufs,
    this.notes,
  });

  factory Accouplement.fromMap(Map<String, dynamic> map) {
    return Accouplement(
      date: (map['date'] as Timestamp).toDate(),
      nombreMales: map['nombreMales'] ?? 0,
      nombreFemelles: map['nombreFemelles'] ?? 0,
      dateEclosionPrevue: (map['dateEclosionPrevue'] as Timestamp).toDate(),
      nombreOeufs: map['nombreOeufs'],
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'nombreMales': nombreMales,
      'nombreFemelles': nombreFemelles,
      'dateEclosionPrevue': Timestamp.fromDate(dateEclosionPrevue),
      'nombreOeufs': nombreOeufs,
      'notes': notes,
    };
  }
}

/// Période de récolte
class PeriodeRecolte {
  final DateTime dateDebut;
  final DateTime dateFin;
  final int quantiteRecoltee;
  final String type; // 'oeufs', 'viande', etc.
  final String? notes;

  PeriodeRecolte({
    required this.dateDebut,
    required this.dateFin,
    required this.quantiteRecoltee,
    required this.type,
    this.notes,
  });

  factory PeriodeRecolte.fromMap(Map<String, dynamic> map) {
    return PeriodeRecolte(
      dateDebut: (map['dateDebut'] as Timestamp).toDate(),
      dateFin: (map['dateFin'] as Timestamp).toDate(),
      quantiteRecoltee: map['quantiteRecoltee'] ?? 0,
      type: map['type'] ?? '',
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateDebut': Timestamp.fromDate(dateDebut),
      'dateFin': Timestamp.fromDate(dateFin),
      'quantiteRecoltee': quantiteRecoltee,
      'type': type,
      'notes': notes,
    };
  }
}

/// Rappel de production
class RappelProduction {
  final String id;
  final String titre;
  final String description;
  final DateTime datePrevue;
  final String type; // 'vaccination', 'recolte', 'accouplement', 'autre'
  final String priorite; // 'haute', 'moyenne', 'basse'
  final bool effectue;

  RappelProduction({
    required this.id,
    required this.titre,
    required this.description,
    required this.datePrevue,
    required this.type,
    required this.priorite,
    required this.effectue,
  });

  factory RappelProduction.fromMap(Map<String, dynamic> map) {
    return RappelProduction(
      id: map['id'] ?? '',
      titre: map['titre'] ?? '',
      description: map['description'] ?? '',
      datePrevue: (map['datePrevue'] as Timestamp).toDate(),
      type: map['type'] ?? '',
      priorite: map['priorite'] ?? 'moyenne',
      effectue: map['effectue'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'datePrevue': Timestamp.fromDate(datePrevue),
      'type': type,
      'priorite': priorite,
      'effectue': effectue,
    };
  }
}
