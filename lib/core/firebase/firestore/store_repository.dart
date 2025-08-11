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
    if (storeData.sellerId.isNotEmpty) {
      await _sellerRepository.addStoreToSeller(storeData.sellerId, docRef.id);
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

  /// Met à jour les informations de mobile money d'une boutique
  Future<void> updateMobileMoney(
      String storeId, List<Map<String, dynamic>> mobileMoney) async {
    await _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .update({
      StoresCollection.mobileMoney: mobileMoney,
    });
  }

  /// Met à jour les informations de livraison
  Future<void> updateSellerOwnDeliver(
      String storeId, bool sellerOwnDeliver) async {
    await _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .update({
      StoresCollection.sellerOwnDeliver: sellerOwnDeliver,
    });
  }

  /// Met à jour l'adresse de la boutique
  Future<void> updateStoreAddress(String storeId, String address) async {
    await _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .update({
      StoresCollection.storeAddress: address,
    });
  }

  /// Met à jour les commentaires de la boutique
  Future<void> updateStoreComments(
      String storeId, List<String> comments) async {
    await _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .update({
      StoresCollection.storeComments: comments,
    });
  }

  /// Met à jour le chemin de la couverture de la boutique
  Future<void> updateStoreCoverPath(String storeId, String coverPath) async {
    await _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .update({
      StoresCollection.storeCoverPath: coverPath,
    });
  }

  /// Met à jour la description de la boutique
  Future<void> updateStoreDescription(
      String storeId, String description) async {
    await _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .update({
      StoresCollection.storeDescription: description,
    });
  }

  /// Met à jour le type fiscal de la boutique
  Future<void> updateStoreFiscalType(String storeId, String fiscalType) async {
    await _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .update({
      StoresCollection.storeFiscalType: fiscalType,
    });
  }

  /// Met à jour les informations de la boutique
  Future<void> updateStoreInfos(
      String storeId, Map<String, dynamic> storeInfos) async {
    await _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .update({
      StoresCollection.storeInfos: storeInfos,
    });
  }

  /// Met à jour la localisation de la boutique
  Future<void> updateStoreLocation(String storeId, String location) async {
    await _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .update({
      StoresCollection.storeLocation: location,
    });
  }

  /// Met à jour le chemin du logo de la boutique
  Future<void> updateStoreLogoPath(String storeId, String logoPath) async {
    await _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .update({
      StoresCollection.storeLogoPath: logoPath,
    });
  }

  /// Met à jour les produits de la boutique
  Future<void> updateStoreProducts(
      String storeId, List<String> products) async {
    await _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .update({
      StoresCollection.storeProducts: products,
    });
  }

  /// Met à jour les évaluations de la boutique
  Future<void> updateStoreRatings(String storeId, List<double> ratings) async {
    await _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .update({
      StoresCollection.storeRatings: ratings,
    });
  }

  /// Met à jour les secteurs de la boutique
  Future<void> updateStoreSectors(String storeId, List<String> sectors) async {
    await _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .update({
      StoresCollection.storeSectors: sectors,
    });
  }

  /// Met à jour l'état de la boutique
  Future<void> updateStoreState(String storeId, String state) async {
    await _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .update({
      StoresCollection.storeState: state,
    });
  }

  /// Met à jour le statut de la boutique
  Future<void> updateStoreStatus(String storeId, String status) async {
    await _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .update({
      StoresCollection.storeStatus: status,
    });
  }

  /// Met à jour les sous-secteurs de la boutique
  Future<void> updateStoreSubsectors(
      String storeId, List<String> subsectors) async {
    await _firestore
        .collection(FirebaseCollections.storesCollection)
        .doc(storeId)
        .update({
      StoresCollection.storeSubsectors: subsectors,
    });
  }
}
