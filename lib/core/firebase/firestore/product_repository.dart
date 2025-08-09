import 'package:benin_poulet/constants/firebase_collections/firebaseCollections.dart';
import 'package:benin_poulet/constants/firebase_collections/productsCollection.dart';
import 'package:benin_poulet/models/produit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProductService {
  final _productsRef = FirebaseFirestore.instance
      .collection(FirebaseCollections.productsCollection);

  // Ajouter un produit
  Future<void> addProduct(Produit produit) async {
    final docRef = _productsRef.doc();
    final productWithId = produit.copyWith(productId: docRef.id);
    await docRef.set(productWithId.toMap());
  }

  // Mettre à jour un produit
  Future<void> updateProduct(Produit produit) async {
    if (produit.productId == null) return;
    await _productsRef.doc(produit.productId).update(produit.toMap());
  }

  // Supprimer un produit
  Future<void> deleteProduct(String productId) async {
    await _productsRef.doc(productId).delete();
  }

  // Récupérer un produit
  Future<Produit?> getProduct(String productId) async {
    final doc = await _productsRef.doc(productId).get();
    if (doc.exists) {
      return Produit.fromDocument(doc);
    }
    return null;
  }

  // Récupérer tous les produits d’un store
  Stream<List<Produit>> getProductsByStore(String storeId) {
    return _productsRef
        .where(ProductsCollection.storeId, isEqualTo: storeId)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) => Produit.fromDocument(doc)).toList();
      },
    );
  }

  // Tous les produits
  Stream<List<Produit>> getAllProducts() {
    return _productsRef.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) => Produit.fromDocument(doc)).toList();
      },
    );
  }
}
