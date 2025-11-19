import 'package:cloud_firestore/cloud_firestore.dart';

/// Modèle pour les performances commerciales d'un vendeur
class PerformanceCommercial {
  final String id;
  final String sellerId;
  final double chiffreAffaires;
  final int volumeVentes;
  final double tauxConversion;
  final Map<String, double> evolutionTemporelle; // {date: CA}
  final Map<String, dynamic> comparatifPeriodes; // hebdo, mensuel
  final List<ProduitPhare> produitsPhares;
  final List<AlertePerformance> alertes;
  final DateTime dateCalcul;

  PerformanceCommercial({
    required this.id,
    required this.sellerId,
    required this.chiffreAffaires,
    required this.volumeVentes,
    required this.tauxConversion,
    required this.evolutionTemporelle,
    required this.comparatifPeriodes,
    required this.produitsPhares,
    required this.alertes,
    required this.dateCalcul,
  });

  factory PerformanceCommercial.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return PerformanceCommercial(
      id: doc.id,
      sellerId: data['sellerId'] ?? '',
      chiffreAffaires: (data['chiffreAffaires'] ?? 0).toDouble(),
      volumeVentes: data['volumeVentes'] ?? 0,
      tauxConversion: (data['tauxConversion'] ?? 0).toDouble(),
      evolutionTemporelle: Map<String, double>.from(
        data['evolutionTemporelle'] ?? {},
      ),
      comparatifPeriodes: data['comparatifPeriodes'] ?? {},
      produitsPhares: (data['produitsPhares'] as List<dynamic>?)
              ?.map((e) => ProduitPhare.fromMap(e))
              .toList() ??
          [],
      alertes: (data['alertes'] as List<dynamic>?)
              ?.map((e) => AlertePerformance.fromMap(e))
              .toList() ??
          [],
      dateCalcul:
          (data['dateCalcul'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'chiffreAffaires': chiffreAffaires,
      'volumeVentes': volumeVentes,
      'tauxConversion': tauxConversion,
      'evolutionTemporelle': evolutionTemporelle,
      'comparatifPeriodes': comparatifPeriodes,
      'produitsPhares': produitsPhares.map((e) => e.toMap()).toList(),
      'alertes': alertes.map((e) => e.toMap()).toList(),
      'dateCalcul': Timestamp.fromDate(dateCalcul),
    };
  }

  PerformanceCommercial copyWith({
    String? id,
    String? sellerId,
    double? chiffreAffaires,
    int? volumeVentes,
    double? tauxConversion,
    Map<String, double>? evolutionTemporelle,
    Map<String, dynamic>? comparatifPeriodes,
    List<ProduitPhare>? produitsPhares,
    List<AlertePerformance>? alertes,
    DateTime? dateCalcul,
  }) {
    return PerformanceCommercial(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      chiffreAffaires: chiffreAffaires ?? this.chiffreAffaires,
      volumeVentes: volumeVentes ?? this.volumeVentes,
      tauxConversion: tauxConversion ?? this.tauxConversion,
      evolutionTemporelle: evolutionTemporelle ?? this.evolutionTemporelle,
      comparatifPeriodes: comparatifPeriodes ?? this.comparatifPeriodes,
      produitsPhares: produitsPhares ?? this.produitsPhares,
      alertes: alertes ?? this.alertes,
      dateCalcul: dateCalcul ?? this.dateCalcul,
    );
  }
}

/// Produit phare dans les performances
class ProduitPhare {
  final String productId;
  final String nom;
  final int nombreVentes;
  final double ca;
  final double evolution; // % d'évolution

  ProduitPhare({
    required this.productId,
    required this.nom,
    required this.nombreVentes,
    required this.ca,
    required this.evolution,
  });

  factory ProduitPhare.fromMap(Map<String, dynamic> map) {
    return ProduitPhare(
      productId: map['productId'] ?? '',
      nom: map['nom'] ?? '',
      nombreVentes: map['nombreVentes'] ?? 0,
      ca: (map['ca'] ?? 0).toDouble(),
      evolution: (map['evolution'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'nom': nom,
      'nombreVentes': nombreVentes,
      'ca': ca,
      'evolution': evolution,
    };
  }
}

/// Alerte de performance
class AlertePerformance {
  final String type; // 'warning', 'success', 'info'
  final String message;
  final DateTime date;

  AlertePerformance({
    required this.type,
    required this.message,
    required this.date,
  });

  factory AlertePerformance.fromMap(Map<String, dynamic> map) {
    return AlertePerformance(
      type: map['type'] ?? 'info',
      message: map['message'] ?? '',
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'message': message,
      'date': Timestamp.fromDate(date),
    };
  }
}


