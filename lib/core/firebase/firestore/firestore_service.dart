import 'package:benin_poulet/constants/firebase_collections/firebaseCollections.dart';
import 'package:benin_poulet/constants/firebase_collections/sellersCollection.dart';
import 'package:benin_poulet/constants/firebase_collections/storesCollection.dart';
import 'package:benin_poulet/constants/firebase_collections/usersCollection.dart';
import 'package:benin_poulet/constants/userRoles.dart';
import 'package:benin_poulet/models/seller.dart';
import 'package:benin_poulet/models/store.dart';
import 'package:benin_poulet/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'seller_repository.dart';
import 'store_repository.dart';
import 'user_repository.dart';

/// Service centralisé pour gérer toutes les interactions avec Firestore
class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreUserServices _userService = FirestoreUserServices();
  final SellerRepository _sellerRepository = SellerRepository();
  final FirestoreStoreService _storeService = FirestoreStoreService();

  /// Crée un nouvel utilisateur avec gestion automatique des rôles
  Future<void> createUser(AppUser user) async {
    await _userService.createOrUpdateUser(user);
  }

  /// Crée un vendeur à partir d'un utilisateur existant avec toutes les informations
  Future<void> createSellerFromUser({
    required String userId,
    required String fullName,
    String? email,
    String? phoneNumber,
    Map<String, dynamic>? deliveryInfos,
    Map<String, dynamic>? fiscality,
    List<String>? sectors,
    List<String>? subSectors,
    Map<String, dynamic>? identityCardUrl,
    bool? documentsVerified,
    List<Map<String, dynamic>>? mobileMoney,
    Map<String, dynamic>? storeInfos,
  }) async {
    // Créer le vendeur avec tous les champs de SellersCollection
    final seller = Seller(
      sellerId: userId,
      userId: userId,
      createdAt: DateTime.now(),
      deliveryInfos: deliveryInfos,
      documentsVerified: documentsVerified,
      fiscality: fiscality,
      identyCardUrl: identityCardUrl,
      mobileMoney: mobileMoney,
      sectors: sectors,
      storeIds: [], // Liste vide au début
      storeInfos: storeInfos,
      subSectors: subSectors,
    );

    await _sellerRepository.createOrUpdateSeller(seller);

    // Mettre à jour le rôle de l'utilisateur
    final updatedUser = AppUser(
      userId: userId,
      role: UserRoles.SELLER,
      fullName: fullName,
      authIdentifier: email ?? phoneNumber,
      profileComplete: true,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );

    await _userService.createOrUpdateUser(updatedUser);
  }

  /// Crée une boutique pour un vendeur avec toutes les informations
  Future<String> createStoreForSeller({
    required String sellerId,
    required String storeName,
    String? storeDescription,
    String? storeAddress,
    String? storeLocation,
    String? storePhone,
    String? storeEmail,
    String? storeLogoPath,
    String? storeCoverPath,
    List<String>? storeSectors,
    List<String>? storeSubsectors,
    bool? sellerOwnDeliver,
    List<Map<String, dynamic>>? mobileMoney,
    String? storeFiscalType,
    String? storeState,
    String? storeStatus,
    List<String>? storeProducts,
    List<double>? storeRatings,
    List<String>? storeComments,
  }) async {
    // Créer les informations de la boutique selon StoresCollection
    final storeInfos = {
      'name': storeName,
      'phone': storePhone,
      'email': storeEmail,
    };

    // Créer la boutique avec tous les champs de StoresCollection
    final store = Store(
      storeId: '', // Sera généré automatiquement
      sellerId: sellerId,
      mobileMoney: mobileMoney,
      sellerOwnDeliver: sellerOwnDeliver,
      storeAddress: storeAddress,
      storeComments: storeComments,
      storeCoverPath: storeCoverPath,
      storeDescription: storeDescription,
      storeFiscalType: storeFiscalType,
      storeInfos: storeInfos,
      storeLocation: storeLocation,
      storeLogoPath: storeLogoPath,
      storeProducts: storeProducts,
      storeRatings: storeRatings,
      storeSectors: storeSectors,
      storeState: storeState,
      storeStatus: storeStatus,
      storeSubsectors: storeSubsectors,
    );

    // Créer la boutique et récupérer l'ID
    final storeId = await _storeService.createStore(
      sellerId: sellerId,
      storeData: store,
    );

    return storeId;
  }

  /// Crée un utilisateur complet avec toutes les informations selon UsersCollection
  Future<void> createCompleteUser({
    required String userId,
    required String authProvider,
    String? authIdentifier,
    String? fullName,
    String? photoUrl,
    String? accountStatus,
    String? role,
    bool? isAnonymous,
    bool? profileComplete,
    DateTime? createdAt,
    DateTime? lastLogin,
    String? password,
  }) async {
    final user = AppUser(
      userId: userId,
      authProvider: authProvider,
      authIdentifier: authIdentifier,
      fullName: fullName,
      photoUrl: photoUrl,
      accountStatus: accountStatus ?? 'active',
      role: role ?? UserRoles.VISITOR,
      isAnonymous: isAnonymous ?? false,
      profileComplete: profileComplete ?? false,
      createdAt: createdAt ?? DateTime.now(),
      lastLogin: lastLogin ?? DateTime.now(),
      password: password,
    );

    await _userService.createOrUpdateUser(user);
  }

  /// Crée un vendeur complet avec toutes les informations selon SellersCollection
  Future<void> createCompleteSeller({
    required String sellerId,
    required String userId,
    DateTime? createdAt,
    Map<String, dynamic>? deliveryInfos,
    bool? documentsVerified,
    Map<String, dynamic>? fiscality,
    Map<String, dynamic>? identityCardUrl,
    List<Map<String, dynamic>>? mobileMoney,
    List<String>? sectors,
    List<String>? storeIds,
    Map<String, dynamic>? storeInfos,
    List<String>? subSectors,
  }) async {
    final seller = Seller(
      sellerId: sellerId,
      userId: userId,
      createdAt: createdAt ?? DateTime.now(),
      deliveryInfos: deliveryInfos,
      documentsVerified: documentsVerified,
      fiscality: fiscality,
      identyCardUrl: identityCardUrl,
      mobileMoney: mobileMoney,
      sectors: sectors,
      storeIds: storeIds ?? [],
      storeInfos: storeInfos,
      subSectors: subSectors,
    );

    await _sellerRepository.createOrUpdateSeller(seller);
  }

  /// Met à jour un vendeur existant en préservant sa liste de boutiques
  Future<void> updateSellerPreservingStores({
    required String sellerId,
    required String userId,
    Map<String, dynamic>? deliveryInfos,
    bool? documentsVerified,
    Map<String, dynamic>? fiscality,
    Map<String, dynamic>? identityCardUrl,
    List<Map<String, dynamic>>? mobileMoney,
    List<String>? sectors,
    Map<String, dynamic>? storeInfos,
    List<String>? subSectors,
  }) async {
    // Récupérer le vendeur existant pour préserver sa liste de boutiques
    final existingSeller = await _sellerRepository.getSeller(sellerId);
    final currentStoreIds = existingSeller?.storeIds ?? [];

    final seller = Seller(
      sellerId: sellerId,
      userId: userId,
      createdAt: existingSeller?.createdAt ?? DateTime.now(),
      deliveryInfos: deliveryInfos ?? existingSeller?.deliveryInfos,
      documentsVerified: documentsVerified ?? existingSeller?.documentsVerified,
      fiscality: fiscality ?? existingSeller?.fiscality,
      identyCardUrl: identityCardUrl ?? existingSeller?.identyCardUrl,
      mobileMoney: mobileMoney ?? existingSeller?.mobileMoney,
      sectors: sectors ?? existingSeller?.sectors,
      storeIds: currentStoreIds, // Préserver la liste existante
      storeInfos: storeInfos ?? existingSeller?.storeInfos,
      subSectors: subSectors ?? existingSeller?.subSectors,
    );

    await _sellerRepository.createOrUpdateSeller(seller);
  }

  /// Crée une boutique complète avec toutes les informations selon StoresCollection
  Future<String> createCompleteStore({
    required String sellerId,
    List<Map<String, dynamic>>? mobileMoney,
    bool? sellerOwnDeliver,
    String? storeAddress,
    List<String>? storeComments,
    String? storeCoverPath,
    String? storeDescription,
    String? storeFiscalType,
    Map<String, dynamic>? storeInfos,
    String? storeLocation,
    String? storeLogoPath,
    List<String>? storeProducts,
    List<double>? storeRatings,
    List<String>? storeSectors,
    String? storeState,
    String? storeStatus,
    List<String>? storeSubsectors,
  }) async {
    final store = Store(
      storeId: '', // Sera généré automatiquement
      sellerId: sellerId,
      mobileMoney: mobileMoney,
      sellerOwnDeliver: sellerOwnDeliver,
      storeAddress: storeAddress,
      storeComments: storeComments,
      storeCoverPath: storeCoverPath,
      storeDescription: storeDescription,
      storeFiscalType: storeFiscalType,
      storeInfos: storeInfos,
      storeLocation: storeLocation,
      storeLogoPath: storeLogoPath,
      storeProducts: storeProducts,
      storeRatings: storeRatings,
      storeSectors: storeSectors,
      storeState: storeState,
      storeStatus: storeStatus,
      storeSubsectors: storeSubsectors,
    );

    final storeId = await _storeService.createStore(
      sellerId: sellerId,
      storeData: store,
    );

    return storeId;
  }

  /// Récupère un utilisateur avec ses informations de vendeur si applicable
  Future<Map<String, dynamic>?> getUserWithSellerInfo(String userId) async {
    final user = await _userService.getUserById(userId);
    if (user == null) return null;

    final result = <String, dynamic>{
      'user': user,
      'seller': null,
    };

    // Si l'utilisateur est un vendeur, récupérer ses informations de vendeur
    if (user.role == UserRoles.SELLER) {
      final seller = await _sellerRepository.getSellerByUserId(userId);
      result['seller'] = seller;
    }

    return result;
  }

  /// Récupère un vendeur avec toutes ses boutiques
  Future<Map<String, dynamic>?> getSellerWithStores(String sellerId) async {
    final seller = await _sellerRepository.getSeller(sellerId);
    if (seller == null) return null;

    // Récupérer toutes les boutiques du vendeur
    final storesStream = _storeService.getStoresBySeller(sellerId);
    final stores = await storesStream.first;

    return {
      'seller': seller,
      'stores': stores,
    };
  }

  /// Met à jour les informations de livraison d'un vendeur
  Future<void> updateSellerDeliveryInfos({
    required String sellerId,
    required String location,
    String? locationDescription,
    bool? sellerOwnDeliver,
  }) async {
    final deliveryInfos = {
      'location': location,
      'locationDescription': locationDescription,
      'sellerOwnDeliver': sellerOwnDeliver,
    };

    await _sellerRepository.updateDeliveryInfos(sellerId, deliveryInfos);
  }

  /// Met à jour les informations de mobile money d'une boutique
  Future<void> updateStoreMobileMoney({
    required String storeId,
    required String gsmService,
    required String name,
    required String phone,
  }) async {
    final mobileMoney = [
      {
        'gsmService': gsmService,
        'name': name,
        'phone': phone,
      }
    ];

    await _storeService.updateMobileMoney(storeId, mobileMoney);
  }

  /// Supprime un vendeur et toutes ses boutiques
  Future<void> deleteSellerAndStores(String sellerId) async {
    // Récupérer toutes les boutiques du vendeur
    final storesStream = _storeService.getStoresBySeller(sellerId);
    final stores = await storesStream.first;

    // Supprimer toutes les boutiques
    for (final store in stores) {
      await _storeService.deleteStore(
        storeId: store.storeId,
        sellerId: sellerId,
      );
    }

    // Supprimer le vendeur
    await _firestore
        .collection(FirebaseCollections.sellersCollection)
        .doc(sellerId)
        .delete();

    // Mettre à jour le rôle de l'utilisateur
    await _userService.updateAccountStatus(sellerId, 'inactive');
  }

  /// Recherche des boutiques par secteur
  Future<List<Store>> searchStoresBySector(String sector) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.storesCollection)
        .where(StoresCollection.storeSectors, arrayContains: sector)
        .get();

    return querySnapshot.docs.map((doc) => Store.fromMap(doc.data())).toList();
  }

  /// Recherche des vendeurs par secteur
  Future<List<Seller>> searchSellersBySector(String sector) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.sellersCollection)
        .where(SellersCollection.sectors, arrayContains: sector)
        .get();

    return querySnapshot.docs.map((doc) => Seller.fromMap(doc.data())).toList();
  }

  /// Récupère les statistiques globales
  Future<Map<String, int>> getGlobalStats() async {
    final usersSnapshot = await _firestore
        .collection(FirebaseCollections.usersCollection)
        .count()
        .get();

    final sellersSnapshot = await _firestore
        .collection(FirebaseCollections.sellersCollection)
        .count()
        .get();

    final storesSnapshot = await _firestore
        .collection(FirebaseCollections.storesCollection)
        .count()
        .get();

    return {
      'totalUsers': usersSnapshot.count ?? 0,
      'totalSellers': sellersSnapshot.count ?? 0,
      'totalStores': storesSnapshot.count ?? 0,
    };
  }
}
