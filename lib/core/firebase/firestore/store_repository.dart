import 'package:benin_poulet/constants/firebase_collections/firebaseCollections.dart';
import 'package:benin_poulet/constants/firebase_collections/storesCollection.dart';
import 'package:benin_poulet/models/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'seller_repository.dart';

class FirestoreStoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _sellerRepository = SellerRepository();

  /// Crée une nouvelle boutique et met à jour la liste des boutiques du vendeur
  Future<String> createStore({
    required String sellerId,
    required Store storeData,
  }) async {
    // Création de la boutique
    final docRef =
        _firestore.collection(FirebaseCollections.storesCollection).doc();
    final storeWithId = storeData.copyWith(
      storeId: docRef.id,
      sellerId: sellerId,
    );

    // Enregistrement de la boutique
    await docRef.set(storeWithId.toMap());

    // Mise à jour de la liste des boutiques du vendeur
    await _sellerRepository.addStoreToSeller(sellerId, docRef.id);

    return docRef.id;
  }

  /// Ajoute une boutique à Firestore
  Future<String> addStore(Store storeData) async {
    final docRef =
        _firestore.collection(FirebaseCollections.storesCollection).doc();
    final storeWithId = storeData.copyWith(storeId: docRef.id);
    await docRef.set(storeWithId.toMap());

    // Si un vendeur est spécifié, on met à jour sa liste de boutiques
    if (storeData.sellerId != null) {
      await _sellerRepository.addStoreToSeller(storeData.sellerId!, docRef.id);
    }

    return docRef.id;
  }

  /// Met à jour une boutique existante
  Future<void> updateStore({
    required String storeId,
    required Map<String, dynamic> updates,
  }) async {
    await _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .update(updates);
  }

  /// Supprime une boutique et la retire de la liste du vendeur
  Future<void> deleteStore({
    required String storeId,
    required String sellerId,
  }) async {
    // Suppression de l'ID de la boutique de la liste du vendeur
    await _sellerRepository.removeStoreFromSeller(sellerId, storeId);

    // Suppression de la boutique
    await _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .delete();
  }

  /// Récupère une boutique par son ID
  Future<Store?> getStore(String storeId) async {
    final doc = await _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .get();
    if (doc.exists) {
      return Store.fromMap(doc.data()!);
    }
    return null;
  }

  /// Récupère toutes les boutiques d'un vendeur
  Stream<List<Store>> getStoresBySeller(String sellerId) {
    return _firestore
        .collection(FirebaseCollections.storesCollection)
        .where(StoresCollection.sellerId, isEqualTo: sellerId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Store.fromMap(doc.data())).toList());
  }

  /// Écoute les changements sur une boutique
  Stream<Store?> streamStore(String storeId) {
    return _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .snapshots()
        .map((doc) => doc.exists ? Store.fromMap(doc.data()!) : null);
  }
}
