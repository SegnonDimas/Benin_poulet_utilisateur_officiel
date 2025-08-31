import 'package:benin_poulet/constants/firebase_collections/firebaseCollections.dart';
import 'package:benin_poulet/models/product_review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProductReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Crée un nouvel avis pour un produit
  Future<String> createProductReview(ProductReview review) async {
    final docRef = _firestore
        .collection(FirebaseCollections.productReviewsCollection)
        .doc();
    final reviewWithId = review.copyWith(reviewId: docRef.id);
    await docRef.set(reviewWithId.toMap());
    return docRef.id;
  }

  /// Met à jour un avis existant
  Future<void> updateProductReview(ProductReview review) async {
    await _firestore
        .collection(FirebaseCollections.productReviewsCollection)
        .doc(review.reviewId)
        .update(review.toMap());
  }

  /// Supprime un avis
  Future<void> deleteProductReview(String reviewId) async {
    await _firestore
        .collection(FirebaseCollections.productReviewsCollection)
        .doc(reviewId)
        .delete();
  }

  /// Récupère un avis par son ID
  Future<ProductReview?> getProductReview(String reviewId) async {
    final doc = await _firestore
        .collection(FirebaseCollections.productReviewsCollection)
        .doc(reviewId)
        .get();
    if (doc.exists) {
      return ProductReview.fromDocument(doc);
    }
    return null;
  }

  /// Récupère tous les avis d'un produit
  Stream<List<ProductReview>> getProductReviewsByProduct(String productId) {
    return _firestore
        .collection(FirebaseCollections.productReviewsCollection)
        .where('productId', isEqualTo: productId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ProductReview.fromDocument(doc)).toList())
        .map((reviews) {
          // Trier localement pour éviter les problèmes d'index
          reviews.sort((a, b) => b.date.compareTo(a.date));
          return reviews;
        });
  }

  /// Récupère tous les avis d'un utilisateur
  Stream<List<ProductReview>> getProductReviewsByUser(String userId) {
    return _firestore
        .collection(FirebaseCollections.productReviewsCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ProductReview.fromDocument(doc)).toList())
        .map((reviews) {
          // Trier localement pour éviter les problèmes d'index
          reviews.sort((a, b) => b.date.compareTo(a.date));
          return reviews;
        });
  }

  /// Récupère tous les avis d'une boutique
  Stream<List<ProductReview>> getProductReviewsByStore(String storeId) {
    return _firestore
        .collection(FirebaseCollections.productReviewsCollection)
        .where('storeId', isEqualTo: storeId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ProductReview.fromDocument(doc)).toList())
        .map((reviews) {
          // Trier localement pour éviter les problèmes d'index
          reviews.sort((a, b) => b.date.compareTo(a.date));
          return reviews;
        });
  }

  /// Récupère tous les avis
  Stream<List<ProductReview>> getAllProductReviews() {
    return _firestore
        .collection(FirebaseCollections.productReviewsCollection)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ProductReview.fromDocument(doc)).toList())
        .map((reviews) {
          // Trier localement pour éviter les problèmes d'index
          reviews.sort((a, b) => b.date.compareTo(a.date));
          return reviews;
        });
  }

  /// Vérifie si un utilisateur a déjà laissé un avis pour un produit
  Future<bool> hasUserReviewedProduct(String userId, String productId) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.productReviewsCollection)
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: productId)
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  /// Calcule la note moyenne d'un produit
  Future<double> getAverageProductRating(String productId) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.productReviewsCollection)
        .where('productId', isEqualTo: productId)
        .get();
    
    if (querySnapshot.docs.isEmpty) return 0.0;
    
    final totalStars = querySnapshot.docs
        .map((doc) => ProductReview.fromDocument(doc).stars)
        .reduce((a, b) => a + b);
    
    return totalStars / querySnapshot.docs.length;
  }

  /// Récupère le nombre total d'avis pour un produit
  Future<int> getProductReviewCount(String productId) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.productReviewsCollection)
        .where('productId', isEqualTo: productId)
        .get();
    return querySnapshot.docs.length;
  }
}
