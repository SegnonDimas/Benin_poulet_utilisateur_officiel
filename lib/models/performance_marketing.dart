import 'package:cloud_firestore/cloud_firestore.dart';

/// Modèle pour les performances marketing (campagnes)
class PerformanceMarketing {
  final String id;
  final String sellerId;
  final List<ImpactPromotion> impactPromotions;
  final AnalyseTrafic analyseTrafic;
  final Map<String, double> tauxClicPromotions; // {promotionId: taux}
  final List<SuggestionMarketing> suggestions;
  final DateTime dateCalcul;

  PerformanceMarketing({
    required this.id,
    required this.sellerId,
    required this.impactPromotions,
    required this.analyseTrafic,
    required this.tauxClicPromotions,
    required this.suggestions,
    required this.dateCalcul,
  });

  factory PerformanceMarketing.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return PerformanceMarketing(
      id: doc.id,
      sellerId: data['sellerId'] ?? '',
      impactPromotions: (data['impactPromotions'] as List<dynamic>?)
              ?.map((e) => ImpactPromotion.fromMap(e))
              .toList() ??
          [],
      analyseTrafic: AnalyseTrafic.fromMap(data['analyseTrafic'] ?? {}),
      tauxClicPromotions: Map<String, double>.from(
        data['tauxClicPromotions'] ?? {},
      ),
      suggestions: (data['suggestions'] as List<dynamic>?)
              ?.map((e) => SuggestionMarketing.fromMap(e))
              .toList() ??
          [],
      dateCalcul:
          (data['dateCalcul'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'impactPromotions': impactPromotions.map((e) => e.toMap()).toList(),
      'analyseTrafic': analyseTrafic.toMap(),
      'tauxClicPromotions': tauxClicPromotions,
      'suggestions': suggestions.map((e) => e.toMap()).toList(),
      'dateCalcul': Timestamp.fromDate(dateCalcul),
    };
  }
}

/// Impact d'une promotion
class ImpactPromotion {
  final String promotionId;
  final String nomPromotion;
  final DateTime dateDebut;
  final DateTime dateFin;
  final double caAvecPromo;
  final double caSansPromo;
  final int ventesAvecPromo;
  final int ventesSansPromo;
  final double augmentationCA; // en %

  ImpactPromotion({
    required this.promotionId,
    required this.nomPromotion,
    required this.dateDebut,
    required this.dateFin,
    required this.caAvecPromo,
    required this.caSansPromo,
    required this.ventesAvecPromo,
    required this.ventesSansPromo,
    required this.augmentationCA,
  });

  factory ImpactPromotion.fromMap(Map<String, dynamic> map) {
    return ImpactPromotion(
      promotionId: map['promotionId'] ?? '',
      nomPromotion: map['nomPromotion'] ?? '',
      dateDebut: (map['dateDebut'] as Timestamp).toDate(),
      dateFin: (map['dateFin'] as Timestamp).toDate(),
      caAvecPromo: (map['caAvecPromo'] ?? 0).toDouble(),
      caSansPromo: (map['caSansPromo'] ?? 0).toDouble(),
      ventesAvecPromo: map['ventesAvecPromo'] ?? 0,
      ventesSansPromo: map['ventesSansPromo'] ?? 0,
      augmentationCA: (map['augmentationCA'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'promotionId': promotionId,
      'nomPromotion': nomPromotion,
      'dateDebut': Timestamp.fromDate(dateDebut),
      'dateFin': Timestamp.fromDate(dateFin),
      'caAvecPromo': caAvecPromo,
      'caSansPromo': caSansPromo,
      'ventesAvecPromo': ventesAvecPromo,
      'ventesSansPromo': ventesSansPromo,
      'augmentationCA': augmentationCA,
    };
  }
}

/// Analyse de trafic
class AnalyseTrafic {
  final int vuesBoutique;
  final int visiteursUniques;
  final double tauxRebond; // en %
  final Map<String, int> vuesParJour; // {date: vues}
  final double dureeMoyenneVisite; // en minutes

  AnalyseTrafic({
    required this.vuesBoutique,
    required this.visiteursUniques,
    required this.tauxRebond,
    required this.vuesParJour,
    required this.dureeMoyenneVisite,
  });

  factory AnalyseTrafic.fromMap(Map<String, dynamic> map) {
    return AnalyseTrafic(
      vuesBoutique: map['vuesBoutique'] ?? 0,
      visiteursUniques: map['visiteursUniques'] ?? 0,
      tauxRebond: (map['tauxRebond'] ?? 0).toDouble(),
      vuesParJour: Map<String, int>.from(map['vuesParJour'] ?? {}),
      dureeMoyenneVisite: (map['dureeMoyenneVisite'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vuesBoutique': vuesBoutique,
      'visiteursUniques': visiteursUniques,
      'tauxRebond': tauxRebond,
      'vuesParJour': vuesParJour,
      'dureeMoyenneVisite': dureeMoyenneVisite,
    };
  }
}

/// Suggestion marketing
class SuggestionMarketing {
  final String titre;
  final String description;
  final String type; // 'promotion', 'visibilite', 'prix'
  final String priorite; // 'haute', 'moyenne', 'basse'
  final String? productId; // si c'est pour un produit spécifique

  SuggestionMarketing({
    required this.titre,
    required this.description,
    required this.type,
    required this.priorite,
    this.productId,
  });

  factory SuggestionMarketing.fromMap(Map<String, dynamic> map) {
    return SuggestionMarketing(
      titre: map['titre'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? '',
      priorite: map['priorite'] ?? 'moyenne',
      productId: map['productId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'description': description,
      'type': type,
      'priorite': priorite,
      'productId': productId,
    };
  }
}
