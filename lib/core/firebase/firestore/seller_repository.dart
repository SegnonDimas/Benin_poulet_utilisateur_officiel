import 'package:benin_poulet/constants/firebase_collections/firebaseCollections.dart';
import 'package:benin_poulet/constants/firebase_collections/sellersCollection.dart';
import 'package:benin_poulet/models/seller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SellerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Crée ou met à jour un vendeur dans la collection sellers
  Future<void> createOrUpdateSeller(Seller seller) async {
    await _firestore
        .collection(FirebaseCollections.sellersCollection)
        .doc(seller.sellerId)
        .set(seller.toMap(), SetOptions(merge: true));
  }

  /// Récupère un vendeur par son ID
  Future<Seller?> getSeller(String sellerId) async {
    final doc = await _firestore
        .collection(FirebaseCollections.sellersCollection)
        .doc(sellerId)
        .get();
    if (doc.exists) {
      return Seller.fromMap(doc.data()!);
    }
    return null;
  }

  /// Récupère un vendeur par l'ID de l'utilisateur
  Future<Seller?> getSellerByUserId(String userId) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.sellersCollection)
        .where(SellersCollection.userId, isEqualTo: userId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return Seller.fromMap(querySnapshot.docs.first.data());
    }
    return null;
  }

  /// Ajoute une boutique à la liste des boutiques d'un vendeur
  Future<void> addStoreToSeller(String sellerId, String storeId) async {
    final seller = await getSeller(sellerId);
    if (seller != null) {
      final updatedSeller = seller.addStoreId(storeId);
      await createOrUpdateSeller(updatedSeller);
    }
  }

  /// Supprime une boutique de la liste des boutiques d'un vendeur
  Future<void> removeStoreFromSeller(String sellerId, String storeId) async {
    final seller = await getSeller(sellerId);
    if (seller != null) {
      final updatedSeller = seller.removeStoreId(storeId);
      await createOrUpdateSeller(updatedSeller);
    }
  }

  /// Vérifie si un vendeur existe
  Future<bool> sellerExists(String sellerId) async {
    final doc = await _firestore
        .collection(FirebaseCollections.sellersCollection)
        .doc(sellerId)
        .get();
    return doc.exists;
  }

  /// Écoute les changements sur un vendeur
  Stream<Seller?> streamSeller(String sellerId) {
    return _firestore
        .collection(FirebaseCollections.sellersCollection)
        .doc(sellerId)
        .snapshots()
        .map((doc) => doc.exists ? Seller.fromMap(doc.data()!) : null);
  }

  /// Met à jour les informations de livraison d'un vendeur
  Future<void> updateDeliveryInfos(
      String sellerId, Map<String, dynamic> deliveryInfos) async {
    await _firestore
        .collection(FirebaseCollections.sellersCollection)
        .doc(sellerId)
        .update({
      SellersCollection.deliveryInfos: deliveryInfos,
    });
  }

  /// Met à jour le statut de vérification des documents
  Future<void> updateDocumentsVerified(String sellerId, bool verified) async {
    await _firestore
        .collection(FirebaseCollections.sellersCollection)
        .doc(sellerId)
        .update({
      SellersCollection.documentsVerified: verified,
    });
  }

  /// Met à jour les informations fiscales
  Future<void> updateFiscality(
      String sellerId, Map<String, dynamic> fiscality) async {
    await _firestore
        .collection(FirebaseCollections.sellersCollection)
        .doc(sellerId)
        .update({
      SellersCollection.fiscality: fiscality,
    });
  }

  /// Met à jour les URLs de la carte d'identité
  Future<void> updateIdentityCardUrls(
      String sellerId, Map<String, dynamic> identityCardUrl) async {
    await _firestore
        .collection(FirebaseCollections.sellersCollection)
        .doc(sellerId)
        .update({
      SellersCollection.identyCardUrl: identityCardUrl,
    });
  }

  /// Met à jour les informations de mobile money
  Future<void> updateMobileMoney(
      String sellerId, List<Map<String, dynamic>> mobileMoney) async {
    await _firestore
        .collection(FirebaseCollections.sellersCollection)
        .doc(sellerId)
        .update({
      SellersCollection.mobileMoney: mobileMoney,
    });
  }

  /// Met à jour les secteurs d'activité
  Future<void> updateSectors(String sellerId, List<String> sectors) async {
    await _firestore
        .collection(FirebaseCollections.sellersCollection)
        .doc(sellerId)
        .update({
      SellersCollection.sectors: sectors,
    });
  }

  /// Met à jour les sous-secteurs
  Future<void> updateSubSectors(
      String sellerId, List<String> subSectors) async {
    await _firestore
        .collection(FirebaseCollections.sellersCollection)
        .doc(sellerId)
        .update({
      SellersCollection.subSectors: subSectors,
    });
  }

  /// Crée un nouveau vendeur à partir d'un utilisateur
  /// Si le vendeur existe déjà, préserve sa liste de boutiques existante
  static Future<Seller> createSellerFromUser({
    required String userId,
    required String role,
    String? fullName,
    String? email,
    String? phoneNumber,
    SellerRepository? repository,
  }) async {
    List<String> existingStoreIds = [];

    // Si un repository est fourni, on essaie de récupérer le vendeur existant
    if (repository != null) {
      final existingSeller = await repository.getSeller(userId);
      if (existingSeller != null) {
        existingStoreIds = existingSeller.storeIds;
      }
    }

    return Seller(
      sellerId: userId,
      userId: userId,
      storeIds: existingStoreIds, // On conserve les boutiques existantes
    );
  }
}
