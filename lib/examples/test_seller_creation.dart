import 'package:benin_poulet/constants/userRoles.dart';
import 'package:benin_poulet/core/firebase/firestore/firestore_service.dart';
import 'package:benin_poulet/models/user.dart';

/// Exemple de test pour vérifier la création complète d'un vendeur
class TestSellerCreation {
  final FirestoreService _firestoreService = FirestoreService();

  /// Test 1: Création d'un vendeur avec toutes les informations
  Future<void> testCompleteSellerCreation() async {
    print('=== Test de création complète d\'un vendeur ===');

    try {
      // Créer l'utilisateur de base
      await _firestoreService.createCompleteUser(
        userId: 'test_seller_123',
        authProvider: 'phone',
        authIdentifier: '+22912345678',
        fullName: 'Test Vendeur',
        role: UserRoles.SELLER,
        profileComplete: true,
      );

      // Créer le profil vendeur complet
      await _firestoreService.createCompleteSeller(
        sellerId: 'test_seller_123',
        userId: 'test_seller_123',
        createdAt: DateTime.now(),
        deliveryInfos: {
          'location': 'Cotonou, Bénin',
          'locationDescription': 'Zone commerciale du centre-ville',
          'sellerOwnDeliver': true,
        },
        documentsVerified: false,
        fiscality: {
          'taxId': 'TAX123456',
          'fiscalType': 'auto-entrepreneur',
          'taxRate': 0.18,
        },
        identityCardUrl: {
          'recto': 'https://example.com/recto.jpg',
          'verso': 'https://example.com/verso.jpg',
        },
        mobileMoney: [
          {
            'gsmService': 'MTN',
            'name': 'Test Vendeur',
            'phone': '+22912345678',
          },
          {
            'gsmService': 'Moov',
            'name': 'Test Vendeur',
            'phone': '+22987654321',
          },
        ],
        sectors: ['alimentation', 'boissons'],
        subSectors: ['fruits', 'légumes'],
        storeIds: [],
        storeInfos: {
          'name': 'Fruits & Légumes Test',
          'phone': '+22912345678',
          'email': 'test@fruitslegumes.bj',
        },
      );

      print('✅ Vendeur créé avec succès');

      // Créer une boutique pour ce vendeur
      final storeId = await _firestoreService.createCompleteStore(
        sellerId: 'test_seller_123',
        storeAddress: '123 Rue du Commerce, Cotonou',
        storeLocation: 'Cotonou, Bénin',
        storeDescription: 'Boutique de fruits et légumes frais',
        storeFiscalType: 'auto-entrepreneur',
        sellerOwnDeliver: true,
        storeSectors: ['alimentation', 'boissons'],
        storeSubsectors: ['fruits', 'légumes'],
        storeProducts: ['bananes', 'oranges', 'tomates'],
        storeRatings: [4.5, 4.8, 4.2],
        storeComments: ['Excellent service', 'Produits frais'],
        storeState: 'open',
        storeStatus: 'active',
        mobileMoney: [
          {
            'gsmService': 'MTN',
            'name': 'Test Vendeur',
            'phone': '+22912345678',
          },
        ],
        storeInfos: {
          'name': 'Fruits & Légumes Test',
          'phone': '+22912345678',
          'email': 'test@fruitslegumes.bj',
        },
      );

      print('✅ Boutique créée avec succès - ID: $storeId');

      // Récupérer et afficher les informations complètes
      final userWithSellerInfo =
          await _firestoreService.getUserWithSellerInfo('test_seller_123');
      if (userWithSellerInfo != null) {
        print('✅ Informations utilisateur récupérées:');
        print('   - Nom: ${userWithSellerInfo['user']?.fullName}');
        print('   - Rôle: ${userWithSellerInfo['user']?.role}');
        print('   - Secteurs: ${userWithSellerInfo['seller']?.sectors}');
        print(
            '   - Sous-secteurs: ${userWithSellerInfo['seller']?.subSectors}');
        print(
            '   - Mobile Money: ${userWithSellerInfo['seller']?.mobileMoney}');
      }

      final sellerWithStores =
          await _firestoreService.getSellerWithStores('test_seller_123');
      if (sellerWithStores != null) {
        print('✅ Informations vendeur avec boutiques récupérées:');
        print(
            '   - Nombre de boutiques: ${sellerWithStores['stores']?.length}');
        if (sellerWithStores['stores']?.isNotEmpty == true) {
          print(
              '   - Première boutique: ${sellerWithStores['stores']?.first.storeInfos?['name']}');
        }
      }
    } catch (e) {
      print('❌ Erreur lors du test: $e');
    }
  }

  /// Test 2: Vérifier que toutes les informations sont bien transmises
  Future<void> testInformationTransmission() async {
    print('\n=== Test de transmission des informations ===');

    try {
      // Créer un vendeur avec des informations spécifiques
      await _firestoreService.createCompleteSeller(
        sellerId: 'test_transmission_123',
        userId: 'test_transmission_123',
        sectors: ['textile', 'mode'],
        subSectors: ['vêtements', 'chaussures'],
        mobileMoney: [
          {
            'gsmService': 'MTN',
            'name': 'Transmission Test',
            'phone': '+22911111111',
          }
        ],
        deliveryInfos: {
          'location': 'Porto-Novo, Bénin',
          'locationDescription': 'Marché central',
          'sellerOwnDeliver': false,
        },
        fiscality: {
          'fiscalType': 'entreprise',
          'taxId': 'TAX789012',
        },
        storeInfos: {
          'name': 'Mode Transmission',
          'phone': '+22911111111',
          'email': 'transmission@mode.bj',
        },
      );

      // Récupérer et vérifier les informations
      final seller = await _firestoreService
          .getUserWithSellerInfo('test_transmission_123');
      if (seller != null && seller['seller'] != null) {
        final sellerData = seller['seller']!;

        print('✅ Vérification des informations transmises:');
        print('   - Secteurs: ${sellerData.sectors}');
        print('   - Sous-secteurs: ${sellerData.subSectors}');
        print('   - Mobile Money: ${sellerData.mobileMoney}');
        print('   - Infos livraison: ${sellerData.deliveryInfos}');
        print('   - Fiscalité: ${sellerData.fiscality}');
        print('   - Infos boutique: ${sellerData.storeInfos}');

        // Vérifier que les informations sont correctes
        if (sellerData.sectors?.contains('textile') == true &&
            sellerData.subSectors?.contains('vêtements') == true &&
            sellerData.mobileMoney?.isNotEmpty == true) {
          print('✅ Toutes les informations ont été correctement transmises');
        } else {
          print(
              '❌ Certaines informations n\'ont pas été transmises correctement');
        }
      }
    } catch (e) {
      print('❌ Erreur lors du test de transmission: $e');
    }
  }

  /// Test 3: Vérifier que l'ID de la boutique est bien ajouté à la liste storeIds du vendeur
  Future<void> testStoreIdAddition() async {
    print('\n=== Test d\'ajout de l\'ID de boutique à la liste du vendeur ===');

    try {
      // Créer un vendeur de test
      await _firestoreService.createCompleteSeller(
        sellerId: 'test_store_ids_123',
        userId: 'test_store_ids_123',
        sectors: ['test'],
        storeIds: [], // Liste vide au début
      );

      // Vérifier que la liste est vide au début
      final sellerBefore =
          await _firestoreService.getUserWithSellerInfo('test_store_ids_123');
      if (sellerBefore != null && sellerBefore['seller'] != null) {
        final storeIdsBefore = sellerBefore['seller']!.storeIds;
        print('✅ Liste des boutiques avant création: $storeIdsBefore');

        if (storeIdsBefore.isEmpty) {
          print('✅ La liste est bien vide au début');
        } else {
          print('❌ La liste n\'est pas vide au début');
          return;
        }
      }

      // Créer une boutique
      final storeId = await _firestoreService.createCompleteStore(
        sellerId: 'test_store_ids_123',
        storeAddress: 'Test Address',
        storeLocation: 'Test Location',
        storeDescription: 'Test Store',
        storeFiscalType: 'test',
        sellerOwnDeliver: true,
        storeSectors: ['test'],
        storeSubsectors: ['test'],
        storeProducts: [],
        storeRatings: [0.0],
        storeComments: [],
        storeState: 'open',
        storeStatus: 'active',
        storeInfos: {
          'name': 'Test Store',
          'phone': '+22900000000',
          'email': 'test@store.bj',
        },
      );

      print('✅ Boutique créée avec l\'ID: $storeId');

      // Vérifier que l'ID a été ajouté à la liste du vendeur
      final sellerAfter =
          await _firestoreService.getUserWithSellerInfo('test_store_ids_123');
      if (sellerAfter != null && sellerAfter['seller'] != null) {
        final storeIdsAfter = sellerAfter['seller']!.storeIds;
        print('✅ Liste des boutiques après création: $storeIdsAfter');

        if (storeIdsAfter.contains(storeId)) {
          print(
              '✅ L\'ID de la boutique a été correctement ajouté à la liste du vendeur');
        } else {
          print(
              '❌ L\'ID de la boutique n\'a pas été ajouté à la liste du vendeur');
          print('   - ID attendu: $storeId');
          print('   - Liste actuelle: $storeIdsAfter');
        }
      }

      // Vérifier avec getSellerWithStores
      final sellerWithStores =
          await _firestoreService.getSellerWithStores('test_store_ids_123');
      if (sellerWithStores != null) {
        final stores = sellerWithStores['stores'] as List;
        print('✅ Nombre de boutiques récupérées: ${stores.length}');

        if (stores.length == 1) {
          print('✅ La boutique a été correctement liée au vendeur');
        } else {
          print('❌ Problème avec la liaison boutique-vendeur');
        }
      }
    } catch (e) {
      print('❌ Erreur lors du test d\'ajout d\'ID: $e');
    }
  }
}
