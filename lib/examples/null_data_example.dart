import 'package:lanhi/constants/userRoles.dart';
import 'package:lanhi/constants/user_profilStatus.dart';
import 'package:lanhi/core/firebase/firestore/firestore_service.dart';
import 'package:lanhi/models/seller.dart';
import 'package:lanhi/models/user.dart';
import 'package:lanhi/utils/app_utils.dart';

/// Exemple qui montre que toutes les données sont envoyées vers Firebase,
/// même si elles sont null
class NullDataExample {
  final FirestoreService _firestoreService = FirestoreService();

  /// Exemple 1: Création d'un utilisateur avec des données null
  Future<void> createUserWithNullData() async {
    final user = AppUser(
      userId: 'user_with_nulls',
      authProvider: 'email',
      authIdentifier: 'user@example.com',
      fullName: null,
      // Donnée null
      photoUrl: null,
      // Donnée null
      accountStatus: 'active',
      role: UserRoles.VISITOR,
      isAnonymous: false,
      profilStatus: UserProfilStatus.unverified,
      createdAt: DateTime.now(),
      lastLogin: null,
      // Donnée null
      password: null, // Donnée null
    );

    // Toutes les données seront envoyées vers Firebase, même les null
    await _firestoreService.createUser(user);
    AppUtils.debugPrint(
        'Utilisateur créé avec des données null - toutes envoyées vers Firebase');
  }

  /// Exemple 2: Création d'un vendeur avec des données null
  Future<void> createSellerWithNullData() async {
    // D'abord, créer l'utilisateur
    await _firestoreService.createCompleteUser(
      userId: 'seller_with_nulls',
      authProvider: 'phone',
      authIdentifier: '+22912345678',
      fullName: 'Vendeur Test',
      role: UserRoles.SELLER,
    );

    // Ensuite, créer le vendeur avec des données null
    await _firestoreService.createCompleteSeller(
      sellerId: 'seller_with_nulls',
      userId: 'seller_with_nulls',
      createdAt: DateTime.now(),
      deliveryInfos: null,
      // Donnée null
      documentsVerified: null,
      // Donnée null
      fiscality: null,
      // Donnée null
      identityCardUrl: null,
      // Donnée null
      mobileMoney: null,
      // Donnée null
      sectors: null,
      // Donnée null
      storeIds: [],
      storeInfos: null,
      // Donnée null
      subSectors: null, // Donnée null
    );

    AppUtils.debugPrint(
        'Vendeur créé avec des données null - toutes envoyées vers Firebase');
  }

  /// Exemple 3: Création d'une boutique avec des données null
  Future<void> createStoreWithNullData() async {
    final storeId = await _firestoreService.createCompleteStore(
      sellerId: 'seller_with_nulls',
      mobileMoney: null,
      // Donnée null
      sellerOwnDeliver: null,
      // Donnée null
      storeAddress: null,
      // Donnée null
      storeComments: null,
      // Donnée null
      storeCoverPath: null,
      // Donnée null
      storeDescription: null,
      // Donnée null
      storeFiscalType: null,
      // Donnée null
      storeInfos: null,
      // Donnée null
      storeLocation: null,
      // Donnée null
      storeLogoPath: null,
      // Donnée null
      storeProducts: null,
      // Donnée null
      storeRatings: null,
      // Donnée null
      storeSectors: null,
      // Donnée null
      storeState: null,
      // Donnée null
      storeStatus: null,
      // Donnée null
      storeSubsectors: null, // Donnée null
    );

    AppUtils.debugPrint(
        'Boutique créée avec des données null - toutes envoyées vers Firebase. Store ID: $storeId');
  }

  /// Exemple 4: Vérification des données envoyées
  Future<void> verifyDataSent() async {
    // Créer un vendeur avec des données mixtes (certaines null, d'autres non)
    await _firestoreService.createCompleteUser(
      userId: 'seller_mixed',
      authProvider: 'phone',
      authIdentifier: '+22998765432',
      fullName: 'Vendeur Mixte',
      role: UserRoles.SELLER,
    );

    await _firestoreService.createCompleteSeller(
      sellerId: 'seller_mixed',
      userId: 'seller_mixed',
      deliveryInfos: {
        'location': 'Cotonou',
        'locationDescription': null, // Null dans un objet
        'sellerOwnDeliver': true,
      },
      documentsVerified: false,
      fiscality: {
        'taxId': 'TAX123',
        'taxRate': null, // Null dans un objet
      },
      sectors: ['alimentation'],
      subSectors: null, // Liste null
    );

    // Créer une boutique avec des données mixtes
    final storeId = await _firestoreService.createCompleteStore(
      sellerId: 'seller_mixed',
      storeAddress: '123 Rue Test',
      storeDescription: null,
      // Null
      storeSectors: ['alimentation'],
      storeSubsectors: null,
      // Null
      storeInfos: {
        'name': 'Boutique Test',
        'phone': '+22998765432',
        'email': null, // Null dans un objet
      },
    );

    AppUtils.debugPrint(
        'Vendeur et boutique créés avec des données mixtes (null et non-null)');
    AppUtils.debugPrint(
        'Toutes les données ont été envoyées vers Firebase, y compris les null');
    AppUtils.debugPrint('Store ID: $storeId');
  }

  /// Exemple 5: Comparaison des données avant et après envoi
  Future<void> compareDataBeforeAfter() async {
    // Créer un objet Seller avec des données null
    final seller = Seller(
      sellerId: 'test_seller',
      userId: 'test_seller',
      deliveryInfos: null,
      documentsVerified: null,
      fiscality: null,
      identyCardUrl: null,
      mobileMoney: null,
      sectors: null,
      storeIds: [],
      storeInfos: null,
      subSectors: null,
    );

    // Convertir en Map (ce qui sera envoyé vers Firebase)
    final mapData = seller.toMap();

    AppUtils.debugPrint('=== Données envoyées vers Firebase ===');
    mapData.forEach((key, value) {
      AppUtils.debugPrint('$key: $value (type: ${value.runtimeType})');
    });

    AppUtils.debugPrint(
        '\nToutes les données sont présentes dans le Map, même si elles sont null');
    AppUtils.debugPrint(
        'Firebase recevra tous ces champs avec leurs valeurs (null ou non)');
  }

  /// Exemple 6: Workflow complet avec données null
  Future<void> completeWorkflowWithNullData() async {
    AppUtils.debugPrint('=== Début du workflow avec données null ===');

    // 1. Créer un utilisateur avec des données null
    await createUserWithNullData();

    // 2. Créer un vendeur avec des données null
    await createSellerWithNullData();

    // 3. Créer une boutique avec des données null
    await createStoreWithNullData();

    // 4. Vérifier les données envoyées
    await verifyDataSent();

    // 5. Comparer les données
    await compareDataBeforeAfter();

    AppUtils.debugPrint('=== Workflow terminé ===');
    AppUtils.debugPrint(
        'Toutes les données ont été envoyées vers Firebase, y compris les null');
  }
}

/// Utilisation des exemples
void main() async {
  final examples = NullDataExample();

  // Exécuter le workflow complet
  await examples.completeWorkflowWithNullData();

  // Ou exécuter des exemples individuels
  // await examples.createUserWithNullData();
  // await examples.createSellerWithNullData();
  // await examples.createStoreWithNullData();
  // await examples.verifyDataSent();
  // await examples.compareDataBeforeAfter();
}
