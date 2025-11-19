import 'package:cloud_firestore/cloud_firestore.dart';

/// Modèle pour les performances produit d'un vendeur
class PerformanceProduit {
  final String id;
  final String sellerId;
  final List<TopProduit> topVentes;
  final List<ProduitEnBaisse> produitsEnBaisse;
  final List<ProduitAbandonne> produitsAbandonnes;
  final List<SuggestionOptimisation> suggestions;
  final Map<String, int> ventesParCategorie;
  final DateTime dateCalcul;

  PerformanceProduit({
    required this.id,
    required this.sellerId,
    required this.topVentes,
    required this.produitsEnBaisse,
    required this.produitsAbandonnes,
    required this.suggestions,
    required this.ventesParCategorie,
    required this.dateCalcul,
  });

  factory PerformanceProduit.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return PerformanceProduit(
      id: doc.id,
      sellerId: data['sellerId'] ?? '',
      topVentes: (data['topVentes'] as List<dynamic>?)
              ?.map((e) => TopProduit.fromMap(e))
              .toList() ??
          [],
      produitsEnBaisse: (data['produitsEnBaisse'] as List<dynamic>?)
              ?.map((e) => ProduitEnBaisse.fromMap(e))
              .toList() ??
          [],
      produitsAbandonnes: (data['produitsAbandonnes'] as List<dynamic>?)
              ?.map((e) => ProduitAbandonne.fromMap(e))
              .toList() ??
          [],
      suggestions: (data['suggestions'] as List<dynamic>?)
              ?.map((e) => SuggestionOptimisation.fromMap(e))
              .toList() ??
          [],
      ventesParCategorie: Map<String, int>.from(
        data['ventesParCategorie'] ?? {},
      ),
      dateCalcul:
          (data['dateCalcul'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'topVentes': topVentes.map((e) => e.toMap()).toList(),
      'produitsEnBaisse': produitsEnBaisse.map((e) => e.toMap()).toList(),
      'produitsAbandonnes': produitsAbandonnes.map((e) => e.toMap()).toList(),
      'suggestions': suggestions.map((e) => e.toMap()).toList(),
      'ventesParCategorie': ventesParCategorie,
      'dateCalcul': Timestamp.fromDate(dateCalcul),
    };
  }
}

/// Top produit
class TopProduit {
  final String productId;
  final String nom;
  final int nombreVentes;
  final double ca;
  final double evolution;
  final String? imageUrl;

  TopProduit({
    required this.productId,
    required this.nom,
    required this.nombreVentes,
    required this.ca,
    required this.evolution,
    this.imageUrl,
  });

  factory TopProduit.fromMap(Map<String, dynamic> map) {
    return TopProduit(
      productId: map['productId'] ?? '',
      nom: map['nom'] ?? '',
      nombreVentes: map['nombreVentes'] ?? 0,
      ca: (map['ca'] ?? 0).toDouble(),
      evolution: (map['evolution'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'nom': nom,
      'nombreVentes': nombreVentes,
      'ca': ca,
      'evolution': evolution,
      'imageUrl': imageUrl,
    };
  }
}

/// Produit en baisse
class ProduitEnBaisse {
  final String productId;
  final String nom;
  final double baisseCA; // en %
  final int nombreVentesActuel;
  final int nombreVentesPrecedent;

  ProduitEnBaisse({
    required this.productId,
    required this.nom,
    required this.baisseCA,
    required this.nombreVentesActuel,
    required this.nombreVentesPrecedent,
  });

  factory ProduitEnBaisse.fromMap(Map<String, dynamic> map) {
    return ProduitEnBaisse(
      productId: map['productId'] ?? '',
      nom: map['nom'] ?? '',
      baisseCA: (map['baisseCA'] ?? 0).toDouble(),
      nombreVentesActuel: map['nombreVentesActuel'] ?? 0,
      nombreVentesPrecedent: map['nombreVentesPrecedent'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'nom': nom,
      'baisseCA': baisseCA,
      'nombreVentesActuel': nombreVentesActuel,
      'nombreVentesPrecedent': nombreVentesPrecedent,
    };
  }
}

/// Produit abandonné (consulté mais peu acheté)
class ProduitAbandonne {
  final String productId;
  final String nom;
  final int nombreConsultations;
  final int nombreAchats;
  final double tauxAbandon; // en %

  ProduitAbandonne({
    required this.productId,
    required this.nom,
    required this.nombreConsultations,
    required this.nombreAchats,
    required this.tauxAbandon,
  });

  factory ProduitAbandonne.fromMap(Map<String, dynamic> map) {
    return ProduitAbandonne(
      productId: map['productId'] ?? '',
      nom: map['nom'] ?? '',
      nombreConsultations: map['nombreConsultations'] ?? 0,
      nombreAchats: map['nombreAchats'] ?? 0,
      tauxAbandon: (map['tauxAbandon'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'nom': nom,
      'nombreConsultations': nombreConsultations,
      'nombreAchats': nombreAchats,
      'tauxAbandon': tauxAbandon,
    };
  }
}

/// Suggestion d'optimisation
class SuggestionOptimisation {
  final String productId;
  final String type; // 'prix', 'description', 'images'
  final String suggestion;
  final String priorite; // 'haute', 'moyenne', 'basse'

  SuggestionOptimisation({
    required this.productId,
    required this.type,
    required this.suggestion,
    required this.priorite,
  });

  factory SuggestionOptimisation.fromMap(Map<String, dynamic> map) {
    return SuggestionOptimisation(
      productId: map['productId'] ?? '',
      type: map['type'] ?? '',
      suggestion: map['suggestion'] ?? '',
      priorite: map['priorite'] ?? 'basse',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'type': type,
      'suggestion': suggestion,
      'priorite': priorite,
    };
  }
}


