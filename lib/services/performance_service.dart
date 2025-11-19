import 'package:lanhi/models/indice_performance.dart';
import 'package:lanhi/models/performance_client.dart';
import 'package:lanhi/models/performance_commercial.dart';
import 'package:lanhi/models/performance_marketing.dart';
import 'package:lanhi/models/performance_production.dart';
import 'package:lanhi/models/performance_produit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Service pour gérer les performances du vendeur avec Firestore
class PerformanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections Firestore
  static const String _performanceCommercialCollection =
      'performance_commercial';
  static const String _performanceClientCollection = 'performance_client';
  static const String _performanceProduitCollection = 'performance_produit';
  static const String _performanceProductionCollection =
      'performance_production';
  static const String _indicePerformanceCollection = 'indice_performance';
  static const String _performanceMarketingCollection = 'performance_marketing';

  /// Récupérer les performances commerciales
  Future<PerformanceCommercial?> getPerformanceCommercial(
    String sellerId, {
    String periode = 'mois',
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(_performanceCommercialCollection)
          .where('sellerId', isEqualTo: sellerId)
          .orderBy('dateCalcul', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Générer des données de démonstration si aucune donnée n'existe
        return _generateDemoPerformanceCommercial(sellerId);
      }

      return PerformanceCommercial.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      print('Erreur lors de la récupération des performances commerciales: $e');
      // Retourner des données de démo en cas d'erreur
      return _generateDemoPerformanceCommercial(sellerId);
    }
  }

  /// Stream des performances commerciales en temps réel
  Stream<PerformanceCommercial?> streamPerformanceCommercial(
    String sellerId,
  ) {
    return _firestore
        .collection(_performanceCommercialCollection)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('dateCalcul', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return _generateDemoPerformanceCommercial(sellerId);
      }
      return PerformanceCommercial.fromFirestore(snapshot.docs.first);
    });
  }

  /// Récupérer les performances client
  Future<PerformanceClient?> getPerformanceClient(
    String sellerId, {
    String periode = 'mois',
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(_performanceClientCollection)
          .where('sellerId', isEqualTo: sellerId)
          .orderBy('dateCalcul', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return _generateDemoPerformanceClient(sellerId);
      }

      return PerformanceClient.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      print('Erreur lors de la récupération des performances client: $e');
      return _generateDemoPerformanceClient(sellerId);
    }
  }

  /// Stream des performances client en temps réel
  Stream<PerformanceClient?> streamPerformanceClient(String sellerId) {
    return _firestore
        .collection(_performanceClientCollection)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('dateCalcul', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return _generateDemoPerformanceClient(sellerId);
      }
      return PerformanceClient.fromFirestore(snapshot.docs.first);
    });
  }

  /// Récupérer les performances produit
  Future<PerformanceProduit?> getPerformanceProduit(
    String sellerId, {
    String periode = 'mois',
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(_performanceProduitCollection)
          .where('sellerId', isEqualTo: sellerId)
          .orderBy('dateCalcul', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return _generateDemoPerformanceProduit(sellerId);
      }

      return PerformanceProduit.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      print('Erreur lors de la récupération des performances produit: $e');
      return _generateDemoPerformanceProduit(sellerId);
    }
  }

  /// Stream des performances produit en temps réel
  Stream<PerformanceProduit?> streamPerformanceProduit(String sellerId) {
    return _firestore
        .collection(_performanceProduitCollection)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('dateCalcul', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return _generateDemoPerformanceProduit(sellerId);
      }
      return PerformanceProduit.fromFirestore(snapshot.docs.first);
    });
  }

  /// Récupérer les performances de production
  Future<PerformanceProduction?> getPerformanceProduction(
    String sellerId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(_performanceProductionCollection)
          .where('sellerId', isEqualTo: sellerId)
          .orderBy('dateCalcul', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return _generateDemoPerformanceProduction(sellerId);
      }

      return PerformanceProduction.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      print('Erreur lors de la récupération des performances production: $e');
      return _generateDemoPerformanceProduction(sellerId);
    }
  }

  /// Stream des performances production en temps réel
  Stream<PerformanceProduction?> streamPerformanceProduction(String sellerId) {
    return _firestore
        .collection(_performanceProductionCollection)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('dateCalcul', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return _generateDemoPerformanceProduction(sellerId);
      }
      return PerformanceProduction.fromFirestore(snapshot.docs.first);
    });
  }

  /// Récupérer l'indice de performance
  Future<IndicePerformance?> getIndicePerformance(String sellerId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_indicePerformanceCollection)
          .where('sellerId', isEqualTo: sellerId)
          .orderBy('dateCalcul', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return _generateDemoIndicePerformance(sellerId);
      }

      return IndicePerformance.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      print('Erreur lors de la récupération de l\'indice de performance: $e');
      return _generateDemoIndicePerformance(sellerId);
    }
  }

  /// Stream de l'indice de performance en temps réel
  Stream<IndicePerformance?> streamIndicePerformance(String sellerId) {
    return _firestore
        .collection(_indicePerformanceCollection)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('dateCalcul', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return _generateDemoIndicePerformance(sellerId);
      }
      return IndicePerformance.fromFirestore(snapshot.docs.first);
    });
  }

  /// Récupérer les performances marketing
  Future<PerformanceMarketing?> getPerformanceMarketing(
    String sellerId, {
    String periode = 'mois',
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(_performanceMarketingCollection)
          .where('sellerId', isEqualTo: sellerId)
          .orderBy('dateCalcul', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return _generateDemoPerformanceMarketing(sellerId);
      }

      return PerformanceMarketing.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      print('Erreur lors de la récupération des performances marketing: $e');
      return _generateDemoPerformanceMarketing(sellerId);
    }
  }

  /// Stream des performances marketing en temps réel
  Stream<PerformanceMarketing?> streamPerformanceMarketing(String sellerId) {
    return _firestore
        .collection(_performanceMarketingCollection)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('dateCalcul', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return _generateDemoPerformanceMarketing(sellerId);
      }
      return PerformanceMarketing.fromFirestore(snapshot.docs.first);
    });
  }

  /// Marquer un rappel de production comme effectué
  Future<void> marquerRappelEffectue(
    String rappelId,
    String sellerId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(_performanceProductionCollection)
          .where('sellerId', isEqualTo: sellerId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final performance = PerformanceProduction.fromFirestore(doc);

        // Mettre à jour le rappel
        final updatedRappels = performance.rappels.map((rappel) {
          if (rappel.id == rappelId) {
            return RappelProduction(
              id: rappel.id,
              titre: rappel.titre,
              description: rappel.description,
              datePrevue: rappel.datePrevue,
              type: rappel.type,
              priorite: rappel.priorite,
              effectue: true,
            );
          }
          return rappel;
        }).toList();

        await doc.reference.update({
          'rappels': updatedRappels.map((r) => r.toMap()).toList(),
        });
      }
    } catch (e) {
      print('Erreur lors de la mise à jour du rappel: $e');
      throw e;
    }
  }

  // ==================== MÉTHODES DE GÉNÉRATION DE DONNÉES DE DÉMONSTRATION ====================

  PerformanceCommercial _generateDemoPerformanceCommercial(String sellerId) {
    return PerformanceCommercial(
      id: 'demo_${sellerId}_commercial',
      sellerId: sellerId,
      chiffreAffaires: 2450000,
      volumeVentes: 156,
      tauxConversion: 12.5,
      evolutionTemporelle: {
        '2024-01': 180000.0,
        '2024-02': 220000.0,
        '2024-03': 250000.0,
        '2024-04': 280000.0,
        '2024-05': 320000.0,
        '2024-06': 350000.0,
      },
      comparatifPeriodes: {
        'hebdomadaire': {
          'actuel': 85000.0,
          'precedent': 72000.0,
          'evolution': 18.0
        },
        'mensuel': {
          'actuel': 350000.0,
          'precedent': 320000.0,
          'evolution': 9.4
        },
      },
      produitsPhares: [
        ProduitPhare(
          productId: 'prod1',
          nom: 'Poulet fermier entier',
          nombreVentes: 45,
          ca: 337500.0,
          evolution: 15.3,
        ),
        ProduitPhare(
          productId: 'prod2',
          nom: 'Œufs bio (x12)',
          nombreVentes: 68,
          ca: 204000.0,
          evolution: 22.7,
        ),
        ProduitPhare(
          productId: 'prod3',
          nom: 'Poulet découpé',
          nombreVentes: 32,
          ca: 192000.0,
          evolution: -5.2,
        ),
      ],
      alertes: [
        AlertePerformance(
          type: 'success',
          message: 'Vos ventes ont augmenté de 18% cette semaine !',
          date: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        AlertePerformance(
          type: 'warning',
          message: 'Le produit "Poulet découpé" est en baisse de 5%',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      dateCalcul: DateTime.now(),
    );
  }

  PerformanceClient _generateDemoPerformanceClient(String sellerId) {
    return PerformanceClient(
      id: 'demo_${sellerId}_client',
      sellerId: sellerId,
      nouveauxClients: 23,
      clientsRecurrents: 87,
      tauxSatisfaction: 4.6,
      repartitionNotes: {
        '5': 65,
        '4': 28,
        '3': 12,
        '2': 4,
        '1': 1,
      },
      tempsReponse: 15.5,
      tauxFidelisation: 79.1,
      derniersAvis: [
        AvisClient(
          clientId: 'client1',
          nomClient: 'Marie D.',
          note: 5,
          commentaire: 'Excellente qualité ! Je recommande.',
          date: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        AvisClient(
          clientId: 'client2',
          nomClient: 'Jean K.',
          note: 4,
          commentaire: 'Très satisfait, livraison rapide.',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        AvisClient(
          clientId: 'client3',
          nomClient: 'Sophie M.',
          note: 5,
          commentaire: 'Poulets toujours frais et de qualité.',
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
      evolutionClients: {
        '2024-01': 85,
        '2024-02': 92,
        '2024-03': 98,
        '2024-04': 105,
        '2024-05': 108,
        '2024-06': 110,
      },
      dateCalcul: DateTime.now(),
    );
  }

  PerformanceProduit _generateDemoPerformanceProduit(String sellerId) {
    return PerformanceProduit(
      id: 'demo_${sellerId}_produit',
      sellerId: sellerId,
      topVentes: [
        TopProduit(
          productId: 'prod1',
          nom: 'Poulet fermier entier',
          nombreVentes: 45,
          ca: 337500.0,
          evolution: 15.3,
        ),
        TopProduit(
          productId: 'prod2',
          nom: 'Œufs bio (x12)',
          nombreVentes: 68,
          ca: 204000.0,
          evolution: 22.7,
        ),
        TopProduit(
          productId: 'prod3',
          nom: 'Cuisses de poulet',
          nombreVentes: 38,
          ca: 152000.0,
          evolution: 8.4,
        ),
      ],
      produitsEnBaisse: [
        ProduitEnBaisse(
          productId: 'prod4',
          nom: 'Poulet découpé',
          baisseCA: 5.2,
          nombreVentesActuel: 28,
          nombreVentesPrecedent: 32,
        ),
      ],
      produitsAbandonnes: [
        ProduitAbandonne(
          productId: 'prod5',
          nom: 'Ailes de poulet marinées',
          nombreConsultations: 145,
          nombreAchats: 8,
          tauxAbandon: 94.5,
        ),
      ],
      suggestions: [
        SuggestionOptimisation(
          productId: 'prod5',
          type: 'prix',
          suggestion: 'Réduire le prix de 10% pour les ailes marinées',
          priorite: 'haute',
        ),
        SuggestionOptimisation(
          productId: 'prod4',
          type: 'images',
          suggestion: 'Ajouter des photos plus attrayantes',
          priorite: 'moyenne',
        ),
      ],
      ventesParCategorie: {
        'Poulet entier': 45,
        'Découpes': 82,
        'Œufs': 68,
        'Produits transformés': 15,
      },
      dateCalcul: DateTime.now(),
    );
  }

  PerformanceProduction _generateDemoPerformanceProduction(String sellerId) {
    return PerformanceProduction(
      id: 'demo_${sellerId}_production',
      sellerId: sellerId,
      fichesTechniques: [
        FicheTechnique(
          id: 'fiche1',
          espece: 'Poulet de chair',
          quantite: 250,
          vaccinations: [
            Vaccination(
              nom: 'Newcastle',
              datePrevue: DateTime.now().add(const Duration(days: 5)),
              effectuee: false,
            ),
            Vaccination(
              nom: 'Gumboro',
              datePrevue: DateTime.now().subtract(const Duration(days: 10)),
              dateRealisee: DateTime.now().subtract(const Duration(days: 10)),
              effectuee: true,
            ),
          ],
          accouplements: [
            Accouplement(
              date: DateTime.now().subtract(const Duration(days: 60)),
              nombreMales: 12,
              nombreFemelles: 48,
              dateEclosionPrevue:
                  DateTime.now().subtract(const Duration(days: 39)),
              nombreOeufs: 180,
            ),
          ],
          periodesRecolte: [
            PeriodeRecolte(
              dateDebut: DateTime.now().subtract(const Duration(days: 30)),
              dateFin: DateTime.now().subtract(const Duration(days: 23)),
              quantiteRecoltee: 85,
              type: 'viande',
              notes: 'Bonne qualité',
            ),
          ],
          statistiques: {
            'tauxCroissance': 95.5,
            'mortalite': 2.3,
            'indiceConversion': 1.85,
          },
        ),
        FicheTechnique(
          id: 'fiche2',
          espece: 'Poules pondeuses',
          quantite: 120,
          vaccinations: [
            Vaccination(
              nom: 'Bronchite',
              datePrevue: DateTime.now().add(const Duration(days: 15)),
              effectuee: false,
            ),
          ],
          accouplements: [],
          periodesRecolte: [
            PeriodeRecolte(
              dateDebut: DateTime.now().subtract(const Duration(days: 7)),
              dateFin: DateTime.now(),
              quantiteRecoltee: 756,
              type: 'oeufs',
              notes: 'Production stable',
            ),
          ],
          statistiques: {
            'tauxPonte': 89.2,
            'poidsOeufMoyen': 62.5,
          },
        ),
      ],
      rappels: [
        RappelProduction(
          id: 'rappel1',
          titre: 'Vaccination Newcastle',
          description: 'Vacciner le lot de poulets de chair contre Newcastle',
          datePrevue: DateTime.now().add(const Duration(days: 5)),
          type: 'vaccination',
          priorite: 'haute',
          effectue: false,
        ),
        RappelProduction(
          id: 'rappel2',
          titre: 'Récolte d\'œufs',
          description: 'Collecte quotidienne des œufs',
          datePrevue: DateTime.now(),
          type: 'recolte',
          priorite: 'moyenne',
          effectue: false,
        ),
      ],
      dateCalcul: DateTime.now(),
    );
  }

  IndicePerformance _generateDemoIndicePerformance(String sellerId) {
    return IndicePerformance(
      id: 'demo_${sellerId}_indice',
      sellerId: sellerId,
      scoreGlobal: 82.5,
      scoresDetailles: {
        'commercial': 85.0,
        'client': 90.0,
        'produit': 78.0,
        'production': 80.0,
        'marketing': 75.0,
      },
      classement: 15,
      badges: [
        Badge(
          id: 'badge1',
          nom: 'Top Vendeur',
          description: 'Plus de 100 ventes ce mois',
          icone: '🏆',
          niveau: 'or',
          dateObtention: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Badge(
          id: 'badge2',
          nom: 'Client Satisfait',
          description: 'Note moyenne supérieure à 4.5',
          icone: '⭐',
          niveau: 'platine',
          dateObtention: DateTime.now().subtract(const Duration(days: 15)),
        ),
        Badge(
          id: 'badge3',
          nom: 'Producteur Assidu',
          description: 'Toutes les vaccinations à jour',
          icone: '🎯',
          niveau: 'argent',
          dateObtention: DateTime.now().subtract(const Duration(days: 30)),
        ),
      ],
      tendances: {
        'evolutionMensuelle': 5.2,
        'meilleureCategorie': 'client',
        'categorieAmeliorer': 'marketing',
      },
      objectifs: [
        ObjectifPerformance(
          id: 'obj1',
          titre: 'Atteindre 200 ventes',
          description: 'Objectif mensuel de ventes',
          cible: 200,
          actuel: 156,
          dateEcheance: DateTime.now().add(const Duration(days: 15)),
          atteint: false,
        ),
        ObjectifPerformance(
          id: 'obj2',
          titre: 'Score de satisfaction 4.8',
          description: 'Améliorer la note moyenne',
          cible: 4.8,
          actuel: 4.6,
          dateEcheance: DateTime.now().add(const Duration(days: 30)),
          atteint: false,
        ),
      ],
      dateCalcul: DateTime.now(),
    );
  }

  PerformanceMarketing _generateDemoPerformanceMarketing(String sellerId) {
    return PerformanceMarketing(
      id: 'demo_${sellerId}_marketing',
      sellerId: sellerId,
      impactPromotions: [
        ImpactPromotion(
          promotionId: 'promo1',
          nomPromotion: 'Promotion Poulet fermier -15%',
          dateDebut: DateTime.now().subtract(const Duration(days: 14)),
          dateFin: DateTime.now().subtract(const Duration(days: 7)),
          caAvecPromo: 125000,
          caSansPromo: 85000,
          ventesAvecPromo: 45,
          ventesSansPromo: 28,
          augmentationCA: 47.1,
        ),
        ImpactPromotion(
          promotionId: 'promo2',
          nomPromotion: 'Offre spéciale œufs bio',
          dateDebut: DateTime.now().subtract(const Duration(days: 7)),
          dateFin: DateTime.now(),
          caAvecPromo: 95000,
          caSansPromo: 72000,
          ventesAvecPromo: 68,
          ventesSansPromo: 52,
          augmentationCA: 31.9,
        ),
      ],
      analyseTrafic: AnalyseTrafic(
        vuesBoutique: 1250,
        visiteursUniques: 428,
        tauxRebond: 32.5,
        vuesParJour: {
          '2024-06-01': 180,
          '2024-06-02': 195,
          '2024-06-03': 165,
          '2024-06-04': 220,
          '2024-06-05': 240,
          '2024-06-06': 250,
        },
        dureeMoyenneVisite: 4.8,
      ),
      tauxClicPromotions: {
        'promo1': 18.5,
        'promo2': 22.3,
      },
      suggestions: [
        SuggestionMarketing(
          titre: 'Créer une promotion ciblée',
          description:
              'Les ailes marinées sont consultées mais peu achetées. Une réduction de 20% pourrait booster les ventes.',
          type: 'promotion',
          priorite: 'haute',
          productId: 'prod5',
        ),
        SuggestionMarketing(
          titre: 'Améliorer la visibilité',
          description:
              'Augmenter la présence sur les réseaux sociaux pour attirer plus de visiteurs.',
          type: 'visibilite',
          priorite: 'moyenne',
        ),
      ],
      dateCalcul: DateTime.now(),
    );
  }
}
