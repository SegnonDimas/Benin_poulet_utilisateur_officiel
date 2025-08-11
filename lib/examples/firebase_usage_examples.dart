import 'package:benin_poulet/constants/userRoles.dart';
import 'package:benin_poulet/core/firebase/firestore/firestore_service.dart';
import 'package:benin_poulet/models/user.dart';

/// Exemples d'utilisation de la nouvelle architecture Firebase
class FirebaseUsageExamples {
  final FirestoreService _firestoreService = FirestoreService();

  /// Exemple 1: Création d'un utilisateur simple
  Future<void> createSimpleUser() async {
    final user = AppUser(
      userId: 'user123',
      authProvider: 'email',
      authIdentifier: 'user@example.com',
      fullName: 'John Doe',
      role: UserRoles.VISITOR,
      profileComplete: true,
      createdAt: DateTime.now(),
    );

    await _firestoreService.createUser(user);
    print('Utilisateur créé avec succès');
  }

  /// Exemple 2: Création d'un vendeur
  Future<void> createSeller() async {
    // D'abord, créer l'utilisateur de base
    final user = AppUser(
      userId: 'seller123',
      authProvider: 'phone',
      authIdentifier: '+22912345678',
      fullName: 'Marie Dupont',
      role: UserRoles.SELLER,
      profileComplete: true,
      createdAt: DateTime.now(),
    );

    await _firestoreService.createUser(user);

    // Ensuite, créer le profil vendeur
    await _firestoreService.createSellerFromUser(
      userId: 'seller123',
      fullName: 'Marie Dupont',
      phoneNumber: '+22912345678',
      deliveryInfos: {
        'location': 'Cotonou, Bénin',
        'locationDescription': 'Zone commerciale du centre-ville',
        'sellerOwnDeliver': true,
      },
      fiscality: {
        'taxId': 'TAX123456',
        'fiscalType': 'auto-entrepreneur',
      },
      sectors: ['alimentation', 'boissons'],
      subSectors: ['fruits', 'légumes'],
    );

    print('Vendeur créé avec succès');
  }

  /// Exemple 3: Création d'une boutique
  Future<void> createStore() async {
    final storeId = await _firestoreService.createStoreForSeller(
      sellerId: 'seller123',
      storeName: 'Fruits & Légumes Marie',
      storeDescription: 'Boutique de fruits et légumes frais du marché local',
      storeAddress: '123 Rue du Marché, Cotonou',
      storeLocation: 'Cotonou, Bénin',
      storePhone: '+22912345678',
      storeEmail: 'marie@fruitslegumes.bj',
      storeSectors: ['alimentation'],
      storeSubsectors: ['fruits', 'légumes'],
      sellerOwnDeliver: true,
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
    );

    print('Boutique créée avec l\'ID: $storeId');
  }

  /// Exemple 4: Récupération des données d'un utilisateur
  Future<void> getUserData() async {
    final userData = await _firestoreService.getUserWithSellerInfo('seller123');

    if (userData != null) {
      final user = userData['user'] as AppUser;
      final seller = userData['seller'];

      print('Utilisateur: ${user.fullName}');
      print('Rôle: ${user.role}');

      if (seller != null) {
        print('Vendeur avec ${seller.storeIds.length} boutiques');
      }
    }
  }

  /// Exemple 5: Récupération des données d'un vendeur avec ses boutiques
  Future<void> getSellerWithStores() async {
    final sellerData = await _firestoreService.getSellerWithStores('seller123');

    if (sellerData != null) {
      final seller = sellerData['seller'];
      final stores = sellerData['stores'] as List;

      print('Vendeur: ${seller.userId}');
      print('Nombre de boutiques: ${stores.length}');

      for (final store in stores) {
        print('- Boutique: ${store.storeInfos?['name']}');
      }
    }
  }

  /// Exemple 6: Mise à jour des informations de livraison
  Future<void> updateDeliveryInfo() async {
    await _firestoreService.updateSellerDeliveryInfos(
      sellerId: 'seller123',
      location: 'Nouvelle zone de livraison',
      locationDescription: 'Zone étendue incluant les quartiers périphériques',
      sellerOwnDeliver: false, // Maintenant utilise un service de livraison
    );

    print('Informations de livraison mises à jour');
  }

  /// Exemple 7: Mise à jour des informations de mobile money d'une boutique
  Future<void> updateStoreMobileMoney() async {
    await _firestoreService.updateStoreMobileMoney(
      storeId: 'store123',
      gsmService: 'MTN',
      name: 'Marie Dupont',
      phone: '+22912345678',
    );

    print('Informations de mobile money mises à jour');
  }

  /// Exemple 8: Recherche de boutiques par secteur
  Future<void> searchStoresBySector() async {
    final stores = await _firestoreService.searchStoresBySector('alimentation');

    print('Boutiques trouvées dans le secteur alimentation: ${stores.length}');

    for (final store in stores) {
      print('- ${store.storeInfos?['name']}');
    }
  }

  /// Exemple 9: Recherche de vendeurs par secteur
  Future<void> searchSellersBySector() async {
    final sellers =
        await _firestoreService.searchSellersBySector('alimentation');

    print('Vendeurs trouvés dans le secteur alimentation: ${sellers.length}');

    for (final seller in sellers) {
      print('- Vendeur ID: ${seller.sellerId}');
      print('  Secteurs: ${seller.sectors?.join(', ')}');
    }
  }

  /// Exemple 10: Récupération des statistiques globales
  Future<void> getGlobalStats() async {
    final stats = await _firestoreService.getGlobalStats();

    print('Statistiques globales:');
    print('- Total utilisateurs: ${stats['totalUsers']}');
    print('- Total vendeurs: ${stats['totalSellers']}');
    print('- Total boutiques: ${stats['totalStores']}');
  }

  /// Exemple 11: Suppression d'un vendeur et de ses boutiques
  Future<void> deleteSellerAndStores() async {
    await _firestoreService.deleteSellerAndStores('seller123');
    print('Vendeur et toutes ses boutiques supprimés');
  }

  /// Exemple 12: Workflow complet - Création d'un vendeur avec boutique
  Future<void> completeWorkflow() async {
    print('=== Début du workflow complet ===');

    // 1. Créer l'utilisateur
    await createSimpleUser();

    // 2. Créer le vendeur
    await createSeller();

    // 3. Créer une boutique
    await createStore();

    // 4. Récupérer et afficher les données
    await getUserData();
    await getSellerWithStores();

    // 5. Mettre à jour quelques informations
    await updateDeliveryInfo();

    // 6. Afficher les statistiques
    await getGlobalStats();

    print('=== Workflow complet terminé ===');
  }
}

/// Utilisation des exemples
void main() async {
  final examples = FirebaseUsageExamples();

  // Exécuter un exemple spécifique
  await examples.completeWorkflow();

  // Ou exécuter des exemples individuels
  // await examples.createSimpleUser();
  // await examples.createSeller();
  // await examples.createStore();
}

