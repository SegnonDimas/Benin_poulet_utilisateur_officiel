import 'package:benin_poulet/constants/firebase_collections/firebaseCollections.dart';
import 'package:benin_poulet/models/store_review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreStoreReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Crée un nouvel avis pour une boutique
  Future<String> createStoreReview(StoreReview review) async {
    final docRef = _firestore
        .collection(FirebaseCollections.storeReviewsCollection)
        .doc();
    final reviewWithId = review.copyWith(reviewId: docRef.id);
    await docRef.set(reviewWithId.toMap());
    return docRef.id;
  }

  /// Met à jour un avis existant
  Future<void> updateStoreReview(StoreReview review) async {
    await _firestore
        .collection(FirebaseCollections.storeReviewsCollection)
        .doc(review.reviewId)
        .update(review.toMap());
  }

  /// Supprime un avis
  Future<void> deleteStoreReview(String reviewId) async {
    await _firestore
        .collection(FirebaseCollections.storeReviewsCollection)
        .doc(reviewId)
        .delete();
  }

  /// Récupère un avis par son ID
  Future<StoreReview?> getStoreReview(String reviewId) async {
    final doc = await _firestore
        .collection(FirebaseCollections.storeReviewsCollection)
        .doc(reviewId)
        .get();
    if (doc.exists) {
      return StoreReview.fromDocument(doc);
    }
    return null;
  }

  /// Récupère tous les avis d'une boutique
  Stream<List<StoreReview>> getStoreReviewsByStore(String storeId) {
    return _firestore
        .collection(FirebaseCollections.storeReviewsCollection)
        .where('storeId', isEqualTo: storeId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => StoreReview.fromDocument(doc)).toList());
  }

  /// Récupère tous les avis d'un utilisateur
  Stream<List<StoreReview>> getStoreReviewsByUser(String userId) {
    return _firestore
        .collection(FirebaseCollections.storeReviewsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => StoreReview.fromDocument(doc)).toList());
  }

  /// Récupère tous les avis
  Stream<List<StoreReview>> getAllStoreReviews() {
    return _firestore
        .collection(FirebaseCollections.storeReviewsCollection)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => StoreReview.fromDocument(doc)).toList());
  }

  /// Vérifie si un utilisateur a déjà laissé un avis pour une boutique
  Future<bool> hasUserReviewedStore(String userId, String storeId) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.storeReviewsCollection)
        .where('userId', isEqualTo: userId)
        .where('storeId', isEqualTo: storeId)
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  /// Calcule la note moyenne d'une boutique
  Future<double> getAverageStoreRating(String storeId) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.storeReviewsCollection)
        .where('storeId', isEqualTo: storeId)
        .get();
    
    if (querySnapshot.docs.isEmpty) return 0.0;
    
    final totalStars = querySnapshot.docs
        .map((doc) => StoreReview.fromDocument(doc).stars)
        .reduce((a, b) => a + b);
    
    return totalStars / querySnapshot.docs.length;
  }

  /// Récupère le nombre total d'avis pour une boutique
  Future<int> getStoreReviewCount(String storeId) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.storeReviewsCollection)
        .where('storeId', isEqualTo: storeId)
        .get();
    return querySnapshot.docs.length;
  }
}
