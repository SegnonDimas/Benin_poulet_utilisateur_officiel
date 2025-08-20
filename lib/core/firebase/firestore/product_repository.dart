import 'package:benin_poulet/constants/firebase_collections/firebaseCollections.dart';
import 'package:benin_poulet/models/produit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Crée un nouveau produit
  Future<String> createProduct(Produit product) async {
    final docRef = _firestore.collection(FirebaseCollections.productsCollection).doc();
    final productWithId = product.copyWith(productId: docRef.id);
    await docRef.set(productWithId.toMap());
    return docRef.id;
  }

  /// Récupère un produit par son ID
  Future<Produit?> getProduct(String productId) async {
    final doc = await _firestore
        .collection(FirebaseCollections.productsCollection)
        .doc(productId)
        .get();
    if (doc.exists) {
      return Produit.fromMap(doc.data()!);
    }
    return null;
  }

  /// Récupère tous les produits d'une boutique
  Stream<List<Produit>> getProductsByStore(String storeId) {
    return _firestore
        .collection(FirebaseCollections.productsCollection)
        .where('storeId', isEqualTo: storeId)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Produit.fromMap(doc.data())).toList());
  }

  /// Récupère tous les produits actifs (pour les clients)
  Stream<List<Produit>> getAllActiveProducts() {
    return _firestore
        .collection(FirebaseCollections.productsCollection)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Produit.fromMap(doc.data())).toList());
  }

  /// Recherche des produits par nom ou description
  Future<List<Produit>> searchProducts(String query) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.productsCollection)
        .where('status', isEqualTo: 'active')
        .get();

    final products = querySnapshot.docs
        .map((doc) => Produit.fromMap(doc.data()))
        .where((product) {
          return product.productName.toLowerCase().contains(query.toLowerCase()) ||
              product.productDescription.toLowerCase().contains(query.toLowerCase());
        })
        .toList();

    return products;
  }

  /// Récupère les produits par catégorie
  Future<List<Produit>> getProductsByCategory(String category) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.productsCollection)
        .where('status', isEqualTo: 'active')
        .where('category', isEqualTo: category)
        .get();

    return querySnapshot.docs
        .map((doc) => Produit.fromMap(doc.data()))
        .toList();
  }

  /// Récupère les produits populaires (avec les meilleures notes)
  Future<List<Produit>> getPopularProducts({int limit = 10}) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.productsCollection)
        .where('status', isEqualTo: 'active')
        .limit(limit)
        .get();

    return querySnapshot.docs
        .map((doc) => Produit.fromMap(doc.data()))
        .toList();
  }

  /// Met à jour un produit
  Future<void> updateProduct(String productId, Map<String, dynamic> updates) async {
    await _firestore
        .collection(FirebaseCollections.productsCollection)
        .doc(productId)
        .update(updates);
  }

  /// Supprime un produit
  Future<void> deleteProduct(String productId) async {
    await _firestore
        .collection(FirebaseCollections.productsCollection)
        .doc(productId)
        .delete();
  }

  /// Écoute les changements sur un produit
  Stream<Produit?> streamProduct(String productId) {
    return _firestore
        .collection(FirebaseCollections.productsCollection)
        .doc(productId)
        .snapshots()
        .map((doc) => doc.exists ? Produit.fromMap(doc.data()!) : null);
  }
}
