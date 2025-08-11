import 'package:benin_poulet/constants/userRoles.dart';
import 'package:benin_poulet/core/firebase/firestore/firestore_service.dart';
import 'package:benin_poulet/models/user.dart';

/// Exemples complets d'utilisation de la nouvelle architecture Firebase
/// avec toutes les informations selon les collections définies
class CompleteFirebaseUsageExamples {
  final FirestoreService _firestoreService = FirestoreService();

  /// Exemple 1: Création d'un utilisateur complet avec toutes les informations
  Future<void> createCompleteUserExample() async {
    await _firestoreService.createCompleteUser(
      userId: 'user123',
      authProvider: 'email',
      authIdentifier: 'user@example.com',
      fullName: 'John Doe',
      photoUrl: 'https://example.com/photo.jpg',
      accountStatus: 'active',
      role: UserRoles.VISITOR,
      isAnonymous: false,
      profileComplete: true,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
      password: 'hashedPassword123',
    );

    print('Utilisateur complet créé avec succès');
  }

  /// Exemple 2: Création d'un vendeur complet avec toutes les informations
  Future<void> createCompleteSellerExample() async {
    // D'abord, créer l'utilisateur de base
    await _firestoreService.createCompleteUser(
      userId: 'seller123',
      authProvider: 'phone',
      authIdentifier: '+22912345678',
      fullName: 'Marie Dupont',
      role: UserRoles.SELLER,
      profileComplete: true,
    );

    // Ensuite, créer le profil vendeur complet
    await _firestoreService.createCompleteSeller(
      sellerId: 'seller123',
      userId: 'seller123',
      createdAt: DateTime.now(),
      deliveryInfos: {
        'location': 'Cotonou, Bénin',
        'locationDescription': 'Zone commerciale du centre-ville',
        'sellerOwnDeliver': true,
      },
      documentsVerified: false, // À vérifier par l'admin
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
          'name': 'Marie Dupont',
          'phone': '+22912345678',
        },
        {
          'gsmService': 'Moov',
          'name': 'Marie Dupont',
          'phone': '+22987654321',
        },
      ],
      sectors: ['alimentation', 'boissons'],
      storeIds: [], // Liste vide au début
      storeInfos: {
        'name': 'Fruits & Légumes Marie',
        'phone': '+22912345678',
        'email': 'marie@fruitslegumes.bj',
      },
      subSectors: ['fruits', 'légumes'],
    );

    print('Vendeur complet créé avec succès');
  }

  /// Exemple 3: Création d'une boutique complète avec toutes les informations
  Future<void> createCompleteStoreExample() async {
    final storeId = await _firestoreService.createCompleteStore(
      sellerId: 'seller123',
      mobileMoney: [
        {
          'gsmService': 'MTN',
          'name': 'Marie Dupont',
          'phone': '+22912345678',
        },
        {
          'gsmService': 'Moov',
          'name': 'Marie Dupont',
          'phone': '+22987654321',
        },
      ],
      sellerOwnDeliver: true,
      storeAddress: '123 Rue du Marché, Cotonou',
      storeComments: [
        'Boutique très propre',
        'Produits frais',
        'Service client excellent',
      ],
      storeCoverPath: 'stores/covers/store123_cover.jpg',
      storeDescription: 'Boutique de fruits et légumes frais du marché local',
      storeFiscalType: 'auto-entrepreneur',
      storeInfos: {
        'name': 'Fruits & Légumes Marie',
        'phone': '+22912345678',
        'email': 'marie@fruitslegumes.bj',
      },
      storeLocation: 'Cotonou, Bénin',
      storeLogoPath: 'stores/logos/store123_logo.jpg',
      storeProducts: [
        'product1',
        'product2',
        'product3',
      ],
      storeRatings: [4.5, 4.8, 4.2, 4.7],
      storeSectors: ['alimentation'],
      storeState: 'open',
      storeStatus: 'active',
      storeSubsectors: ['fruits', 'légumes'],
    );

    print('Boutique complète créée avec l\'ID: $storeId');
  }

  /// Exemple 4: Création d'un vendeur avec boutique en une seule opération
  Future<void> createSellerWithStoreExample() async {
    // 1. Créer l'utilisateur
    await _firestoreService.createCompleteUser(
      userId: 'seller456',
      authProvider: 'phone',
      authIdentifier: '+22998765432',
      fullName: 'Pierre Martin',
      role: UserRoles.SELLER,
      profileComplete: true,
    );

    // 2. Créer le vendeur
    await _firestoreService.createCompleteSeller(
      sellerId: 'seller456',
      userId: 'seller456',
      deliveryInfos: {
        'location': 'Porto-Novo, Bénin',
        'locationDescription': 'Zone résidentielle',
        'sellerOwnDeliver': false,
      },
      fiscality: {
        'taxId': 'TAX789012',
        'fiscalType': 'SARL',
        'taxRate': 0.20,
      },
      sectors: ['textile', 'mode'],
      subSectors: ['vêtements', 'accessoires'],
    );

    // 3. Créer la boutique
    final storeId = await _firestoreService.createCompleteStore(
      sellerId: 'seller456',
      storeAddress: '456 Avenue de la Mode, Porto-Novo',
      storeDescription: 'Boutique de vêtements et accessoires de mode',
      storeFiscalType: 'SARL',
      sellerOwnDeliver: false,
      storeSectors: ['textile'],
      storeSubsectors: ['vêtements', 'accessoires'],
      storeState: 'open',
      storeStatus: 'active',
      storeInfos: {
        'name': 'Mode & Style Pierre',
        'phone': '+22998765432',
        'email': 'pierre@modestyle.bj',
      },
    );

    print('Vendeur avec boutique créé avec succès. Store ID: $storeId');
  }

  /// Exemple 5: Mise à jour des informations de livraison
  Future<void> updateDeliveryInfoExample() async {
    await _firestoreService.updateSellerDeliveryInfos(
      sellerId: 'seller123',
      location: 'Nouvelle zone de livraison étendue',
      locationDescription:
          'Zone étendue incluant les quartiers périphériques et les villes voisines',
      sellerOwnDeliver: false, // Maintenant utilise un service de livraison
    );

    print('Informations de livraison mises à jour');
  }

  /// Exemple 6: Mise à jour des informations de mobile money
  Future<void> updateMobileMoneyExample() async {
    await _firestoreService.updateStoreMobileMoney(
      storeId: 'store123',
      gsmService: 'MTN',
      name: 'Marie Dupont',
      phone: '+22912345678',
    );

    print('Informations de mobile money mises à jour');
  }

  /// Exemple 7: Workflow complet - Création d'un écosystème complet
  Future<void> completeEcosystemExample() async {
    print('=== Début du workflow complet ===');

    // 1. Créer un utilisateur administrateur
    await _firestoreService.createCompleteUser(
      userId: 'admin001',
      authProvider: 'email',
      authIdentifier: 'admin@beninpoulet.bj',
      fullName: 'Admin Principal',
      role: UserRoles.ADMIN,
      profileComplete: true,
    );

    // 2. Créer un vendeur avec toutes ses informations
    await _firestoreService.createCompleteUser(
      userId: 'seller001',
      authProvider: 'phone',
      authIdentifier: '+22912345678',
      fullName: 'Vendeur Premium',
      role: UserRoles.SELLER,
      profileComplete: true,
    );

    await _firestoreService.createCompleteSeller(
      sellerId: 'seller001',
      userId: 'seller001',
      deliveryInfos: {
        'location': 'Cotonou, Bénin',
        'locationDescription': 'Zone commerciale premium',
        'sellerOwnDeliver': true,
      },
      documentsVerified: true,
      fiscality: {
        'taxId': 'TAX001',
        'fiscalType': 'SARL',
        'taxRate': 0.18,
      },
      identityCardUrl: {
        'recto': 'https://storage.googleapis.com/identity/recto001.jpg',
        'verso': 'https://storage.googleapis.com/identity/verso001.jpg',
      },
      sectors: ['alimentation', 'boissons', 'cosmétiques'],
      subSectors: ['fruits', 'légumes', 'jus', 'soins'],
    );

    // 3. Créer plusieurs boutiques pour ce vendeur
    final store1Id = await _firestoreService.createCompleteStore(
      sellerId: 'seller001',
      storeAddress: '123 Rue du Marché, Cotonou',
      storeDescription: 'Boutique principale - Fruits et Légumes',
      storeFiscalType: 'SARL',
      sellerOwnDeliver: true,
      storeSectors: ['alimentation'],
      storeSubsectors: ['fruits', 'légumes'],
      storeState: 'open',
      storeStatus: 'active',
      storeInfos: {
        'name': 'Fruits & Légumes Premium',
        'phone': '+22912345678',
        'email': 'contact@fruitslegumes.bj',
      },
    );

    final store2Id = await _firestoreService.createCompleteStore(
      sellerId: 'seller001',
      storeAddress: '456 Avenue des Boissons, Cotonou',
      storeDescription: 'Boutique secondaire - Boissons et Cosmétiques',
      storeFiscalType: 'SARL',
      sellerOwnDeliver: false,
      storeSectors: ['boissons', 'cosmétiques'],
      storeSubsectors: ['jus', 'soins'],
      storeState: 'open',
      storeStatus: 'active',
      storeInfos: {
        'name': 'Boissons & Cosmétiques Premium',
        'phone': '+22912345678',
        'email': 'contact@boissonscosmetiques.bj',
      },
    );

    // 4. Récupérer et afficher les données
    final userData = await _firestoreService.getUserWithSellerInfo('seller001');
    final sellerData = await _firestoreService.getSellerWithStores('seller001');

    print('Données utilisateur: ${userData != null ? 'OK' : 'Erreur'}');
    print('Données vendeur: ${sellerData != null ? 'OK' : 'Erreur'}');
    print('Boutiques créées: $store1Id, $store2Id');

    // 5. Afficher les statistiques
    final stats = await _firestoreService.getGlobalStats();
    print('Statistiques: ${stats.toString()}');

    print('=== Workflow complet terminé ===');
  }

  /// Exemple 8: Recherche et filtrage
  Future<void> searchAndFilterExample() async {
    // Rechercher des boutiques par secteur
    final alimentationStores =
        await _firestoreService.searchStoresBySector('alimentation');
    print('Boutiques alimentation trouvées: ${alimentationStores.length}');

    // Rechercher des vendeurs par secteur
    final alimentationSellers =
        await _firestoreService.searchSellersBySector('alimentation');
    print('Vendeurs alimentation trouvés: ${alimentationSellers.length}');

    // Afficher les détails
    for (final store in alimentationStores) {
      print('- Boutique: ${store.storeInfos?['name']}');
    }

    for (final seller in alimentationSellers) {
      print('- Vendeur: ${seller.sellerId} (${seller.sectors?.join(', ')})');
    }
  }

  /// Exemple 9: Suppression d'un écosystème complet
  Future<void> deleteEcosystemExample() async {
    await _firestoreService.deleteSellerAndStores('seller001');
    print('Écosystème vendeur supprimé avec succès');
  }
}

/// Utilisation des exemples complets
void main() async {
  final examples = CompleteFirebaseUsageExamples();

  // Exécuter le workflow complet
  await examples.completeEcosystemExample();

  // Ou exécuter des exemples individuels
  // await examples.createCompleteUserExample();
  // await examples.createCompleteSellerExample();
  // await examples.createCompleteStoreExample();
  // await examples.createSellerWithStoreExample();
  // await examples.searchAndFilterExample();
}
