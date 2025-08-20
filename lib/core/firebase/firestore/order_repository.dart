import 'package:benin_poulet/constants/firebase_collections/firebaseCollections.dart';
import 'package:benin_poulet/models/order.dart' as app_models;
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Crée une nouvelle commande
  Future<String> createOrder(app_models.Order order) async {
    final docRef = _firestore.collection(FirebaseCollections.ordersCollection).doc();
    final orderWithId = order.copyWith(orderId: docRef.id);
    await docRef.set(orderWithId.toMap());
    return docRef.id;
  }

  /// Récupère une commande par son ID
  Future<app_models.Order?> getOrder(String orderId) async {
    final doc = await _firestore
        .collection(FirebaseCollections.ordersCollection)
        .doc(orderId)
        .get();
    if (doc.exists) {
      return app_models.Order.fromDocument(doc);
    }
    return null;
  }

  /// Récupère toutes les commandes d'un vendeur
  Stream<List<app_models.Order>> getOrdersBySeller(String sellerId) {
    return _firestore
        .collection(FirebaseCollections.ordersCollection)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => app_models.Order.fromDocument(doc)).toList());
  }

  /// Récupère les commandes d'un vendeur par statut
  Stream<List<app_models.Order>> getOrdersBySellerAndStatus(String sellerId, String status) {
    return _firestore
        .collection(FirebaseCollections.ordersCollection)
        .where('sellerId', isEqualTo: sellerId)
        .where('status', isEqualTo: status)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => app_models.Order.fromDocument(doc)).toList());
  }

  /// Récupère toutes les commandes d'une boutique
  Stream<List<app_models.Order>> getOrdersByStore(String storeId) {
    return _firestore
        .collection(FirebaseCollections.ordersCollection)
        .where('storeId', isEqualTo: storeId)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => app_models.Order.fromDocument(doc)).toList());
  }

  /// Met à jour le statut d'une commande
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestore
        .collection(FirebaseCollections.ordersCollection)
        .doc(orderId)
        .update({'status': status});
  }

  /// Met à jour une commande
  Future<void> updateOrder(String orderId, Map<String, dynamic> updates) async {
    await _firestore
        .collection(FirebaseCollections.ordersCollection)
        .doc(orderId)
        .update(updates);
  }

  /// Supprime une commande
  Future<void> deleteOrder(String orderId) async {
    await _firestore
        .collection(FirebaseCollections.ordersCollection)
        .doc(orderId)
        .delete();
  }

  /// Récupère les statistiques des commandes d'un vendeur
  Future<Map<String, int>> getOrderStatsBySeller(String sellerId) async {
    final pendingQuery = await _firestore
        .collection(FirebaseCollections.ordersCollection)
        .where('sellerId', isEqualTo: sellerId)
        .where('status', isEqualTo: 'pending')
        .count()
        .get();

    final activeQuery = await _firestore
        .collection(FirebaseCollections.ordersCollection)
        .where('sellerId', isEqualTo: sellerId)
        .where('status', isEqualTo: 'active')
        .count()
        .get();

    final cancelledQuery = await _firestore
        .collection(FirebaseCollections.ordersCollection)
        .where('sellerId', isEqualTo: sellerId)
        .where('status', isEqualTo: 'cancelled')
        .count()
        .get();

    final completedQuery = await _firestore
        .collection(FirebaseCollections.ordersCollection)
        .where('sellerId', isEqualTo: sellerId)
        .where('status', isEqualTo: 'completed')
        .count()
        .get();

    return {
      'pending': pendingQuery.count ?? 0,
      'active': activeQuery.count ?? 0,
      'cancelled': cancelledQuery.count ?? 0,
      'completed': completedQuery.count ?? 0,
    };
  }

  /// Récupère le revenu total d'un vendeur
  Future<double> getTotalRevenueBySeller(String sellerId) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.ordersCollection)
        .where('sellerId', isEqualTo: sellerId)
        .where('status', isEqualTo: 'completed')
        .get();

    double totalRevenue = 0;
    for (final doc in querySnapshot.docs) {
      final order = app_models.Order.fromDocument(doc);
      totalRevenue += order.totalAmount;
    }

    return totalRevenue;
  }
}
