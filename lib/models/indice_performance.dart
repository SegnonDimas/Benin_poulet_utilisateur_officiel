import 'package:cloud_firestore/cloud_firestore.dart';

/// Modèle pour l'indice global de performance
class IndicePerformance {
  final String id;
  final String sellerId;
  final double scoreGlobal; // sur 100
  final Map<String, double>
      scoresDetailles; // {commercial: 85, client: 90, ...}
  final int classement; // position dans le classement général
  final List<Badge> badges;
  final Map<String, dynamic> tendances; // évolution dans le temps
  final List<ObjectifPerformance> objectifs;
  final DateTime dateCalcul;

  IndicePerformance({
    required this.id,
    required this.sellerId,
    required this.scoreGlobal,
    required this.scoresDetailles,
    required this.classement,
    required this.badges,
    required this.tendances,
    required this.objectifs,
    required this.dateCalcul,
  });

  factory IndicePerformance.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return IndicePerformance(
      id: doc.id,
      sellerId: data['sellerId'] ?? '',
      scoreGlobal: (data['scoreGlobal'] ?? 0).toDouble(),
      scoresDetailles: Map<String, double>.from(
        data['scoresDetailles'] ?? {},
      ),
      classement: data['classement'] ?? 0,
      badges: (data['badges'] as List<dynamic>?)
              ?.map((e) => Badge.fromMap(e))
              .toList() ??
          [],
      tendances: data['tendances'] ?? {},
      objectifs: (data['objectifs'] as List<dynamic>?)
              ?.map((e) => ObjectifPerformance.fromMap(e))
              .toList() ??
          [],
      dateCalcul:
          (data['dateCalcul'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'scoreGlobal': scoreGlobal,
      'scoresDetailles': scoresDetailles,
      'classement': classement,
      'badges': badges.map((e) => e.toMap()).toList(),
      'tendances': tendances,
      'objectifs': objectifs.map((e) => e.toMap()).toList(),
      'dateCalcul': Timestamp.fromDate(dateCalcul),
    };
  }

  String get niveauPerformance {
    if (scoreGlobal >= 90) return 'Excellent';
    if (scoreGlobal >= 75) return 'Très bien';
    if (scoreGlobal >= 60) return 'Bien';
    if (scoreGlobal >= 40) return 'Moyen';
    return 'À améliorer';
  }
}

/// Badge de performance
class Badge {
  final String id;
  final String nom;
  final String description;
  final String icone;
  final String niveau; // 'bronze', 'argent', 'or', 'platine'
  final DateTime dateObtention;

  Badge({
    required this.id,
    required this.nom,
    required this.description,
    required this.icone,
    required this.niveau,
    required this.dateObtention,
  });

  factory Badge.fromMap(Map<String, dynamic> map) {
    return Badge(
      id: map['id'] ?? '',
      nom: map['nom'] ?? '',
      description: map['description'] ?? '',
      icone: map['icone'] ?? '🏆',
      niveau: map['niveau'] ?? 'bronze',
      dateObtention: (map['dateObtention'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'icone': icone,
      'niveau': niveau,
      'dateObtention': Timestamp.fromDate(dateObtention),
    };
  }
}

/// Objectif de performance
class ObjectifPerformance {
  final String id;
  final String titre;
  final String description;
  final double cible; // valeur à atteindre
  final double actuel; // valeur actuelle
  final DateTime dateEcheance;
  final bool atteint;

  ObjectifPerformance({
    required this.id,
    required this.titre,
    required this.description,
    required this.cible,
    required this.actuel,
    required this.dateEcheance,
    required this.atteint,
  });

  factory ObjectifPerformance.fromMap(Map<String, dynamic> map) {
    return ObjectifPerformance(
      id: map['id'] ?? '',
      titre: map['titre'] ?? '',
      description: map['description'] ?? '',
      cible: (map['cible'] ?? 0).toDouble(),
      actuel: (map['actuel'] ?? 0).toDouble(),
      dateEcheance: (map['dateEcheance'] as Timestamp).toDate(),
      atteint: map['atteint'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'cible': cible,
      'actuel': actuel,
      'dateEcheance': Timestamp.fromDate(dateEcheance),
      'atteint': atteint,
    };
  }

  double get progression =>
      cible > 0 ? (actuel / cible * 100).clamp(0, 100) : 0;
}
