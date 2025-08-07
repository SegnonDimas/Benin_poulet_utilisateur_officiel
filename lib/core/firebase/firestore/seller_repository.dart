import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:benin_poulet/models/seller.dart';

class SellerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Crée ou met à jour un vendeur dans la collection 'sellers'
  Future<void> createOrUpdateSeller(Seller seller) async {
    await _firestore
        .collection('sellers')
        .doc(seller.sellerId)
        .set(seller.toMap(), SetOptions(merge: true));
  }

  /// Récupère un vendeur par son ID
  Future<Seller?> getSeller(String sellerId) async {
    final doc = await _firestore.collection('sellers').doc(sellerId).get();
    if (doc.exists) {
      return Seller.fromMap(doc.data()!);
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
    final doc = await _firestore.collection('sellers').doc(sellerId).get();
    return doc.exists;
  }

  /// Écoute les changements sur un vendeur
  Stream<Seller?> streamSeller(String sellerId) {
    return _firestore
        .collection('sellers')
        .doc(sellerId)
        .snapshots()
        .map((doc) => doc.exists ? Seller.fromMap(doc.data()!) : null);
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
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      storeIds: existingStoreIds, // On conserve les boutiques existantes
      isActive: true,
      additionalInfo: {
        'role': role,
      },
    );
  }
}
