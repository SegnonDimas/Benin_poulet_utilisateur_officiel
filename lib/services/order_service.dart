import 'package:lanhi/models/order_model.dart';
import 'package:lanhi/models/order_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Service de gestion des commandes avec Firestore
class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _ordersCollection = 'orders';

  /// Créer une nouvelle commande
  Future<String> createOrder(OrderModel order) async {
    try {
      final docRef =
          await _firestore.collection(_ordersCollection).add(order.toMap());
      print('✅ Commande créée avec succès: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Erreur lors de la création de la commande: $e');
      rethrow;
    }
  }

  /// Récupérer une commande par son ID
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final doc =
          await _firestore.collection(_ordersCollection).doc(orderId).get();

      if (doc.exists) {
        return OrderModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('❌ Erreur lors de la récupération de la commande: $e');
      return null;
    }
  }

  /// Stream d'une commande (temps réel)
  Stream<OrderModel?> streamOrder(String orderId) {
    return _firestore
        .collection(_ordersCollection)
        .doc(orderId)
        .snapshots()
        .map((doc) => doc.exists ? OrderModel.fromFirestore(doc) : null);
  }

  /// Récupérer les commandes d'un client
  Future<List<OrderModel>> getOrdersByClientId(String clientId) async {
    try {
      print('🔍 Récupération des commandes pour clientId: $clientId');

      // Essayer d'abord sans orderBy pour éviter les problèmes d'index
      final querySnapshot = await _firestore
          .collection(_ordersCollection)
          .where('clientId', isEqualTo: clientId)
          .get();

      print('✅ ${querySnapshot.docs.length} commandes trouvées');

      final orders = querySnapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();

      // Trier localement par date
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return orders;
    } catch (e) {
      print('❌ Erreur lors de la récupération des commandes client: $e');
      return [];
    }
  }

  /// Stream des commandes d'un client (temps réel)
  Stream<List<OrderModel>> streamOrdersByClientId(String clientId) {
    print('🔄 OrderService: Création stream pour clientId: $clientId');
    print('📂 Collection: $_ordersCollection');

    return _firestore
        .collection(_ordersCollection)
        .where('clientId', isEqualTo: clientId)
        .snapshots()
        .map((snapshot) {
      print('📦 OrderService: Snapshot reçu');
      print('📊 OrderService: ${snapshot.docs.length} documents trouvés');

      if (snapshot.docs.isEmpty) {
        print(
            '⚠️ OrderService: Aucun document dans Firestore pour clientId: $clientId');
      } else {
        print('✅ OrderService: Documents trouvés:');
        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          print(
              '  - ${doc.id}: clientId=${data['clientId']}, status=${data['currentStatus']}');
        }
      }

      final orders = snapshot.docs
          .map((doc) {
            try {
              final order = OrderModel.fromFirestore(doc);
              print('  ✅ Commande ${doc.id} parsée avec succès');
              return order;
            } catch (e) {
              print('❌ Erreur parsing document ${doc.id}: $e');
              return null;
            }
          })
          .whereType<OrderModel>()
          .toList();

      print('✅ OrderService: ${orders.length} commandes parsées avec succès');

      // Trier localement
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      print('🎯 OrderService: Retour de ${orders.length} commandes triées');
      return orders;
    }).handleError((error) {
      print('❌ OrderService: Erreur dans le stream: $error');
      return <OrderModel>[];
    });
  }

  /// Récupérer les commandes d'un vendeur
  Future<List<OrderModel>> getOrdersBySellerId(String sellerId) async {
    try {
      print('🔍 Récupération des commandes pour sellerId: $sellerId');

      // Essayer d'abord sans orderBy pour éviter les problèmes d'index
      final querySnapshot = await _firestore
          .collection(_ordersCollection)
          .where('sellerId', isEqualTo: sellerId)
          .get();

      print('✅ ${querySnapshot.docs.length} commandes trouvées');

      final orders = querySnapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();

      // Trier localement par date
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return orders;
    } catch (e) {
      print('❌ Erreur lors de la récupération des commandes vendeur: $e');
      return [];
    }
  }

  /// Stream des commandes d'un vendeur (temps réel)
  Stream<List<OrderModel>> streamOrdersBySellerId(String sellerId) {
    print('🔄 OrderService Vendeur: Création stream pour sellerId: $sellerId');
    print('📂 Collection: $_ordersCollection');

    return _firestore
        .collection(_ordersCollection)
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map((snapshot) {
      print('📦 OrderService Vendeur: Snapshot reçu');
      print(
          '📊 OrderService Vendeur: ${snapshot.docs.length} documents trouvés');

      if (snapshot.docs.isEmpty) {
        print(
            '⚠️ OrderService Vendeur: Aucun document pour sellerId: $sellerId');
      } else {
        print('✅ OrderService Vendeur: Documents trouvés:');
        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          print(
              '  - ${doc.id}: sellerId=${data['sellerId']}, status=${data['currentStatus']}');
        }
      }

      final orders = snapshot.docs
          .map((doc) {
            try {
              final order = OrderModel.fromFirestore(doc);
              print('  ✅ Commande ${doc.id} parsée avec succès');
              return order;
            } catch (e) {
              print('❌ Erreur parsing document ${doc.id}: $e');
              return null;
            }
          })
          .whereType<OrderModel>()
          .toList();

      print('✅ OrderService Vendeur: ${orders.length} commandes parsées');

      // Trier localement
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      print(
          '🎯 OrderService Vendeur: Retour de ${orders.length} commandes triées');
      return orders;
    }).handleError((error) {
      print('❌ OrderService Vendeur: Erreur stream: $error');
      return <OrderModel>[];
    });
  }

  /// Récupérer les commandes d'un vendeur par statut
  Future<List<OrderModel>> getOrdersBySellerIdAndStatus(
    String sellerId,
    OrderStatus status,
  ) async {
    try {
      print(
          '🔍 Récupération des commandes pour sellerId: $sellerId, statut: ${status.value}');

      // Essayer sans orderBy pour éviter les problèmes d'index
      final querySnapshot = await _firestore
          .collection(_ordersCollection)
          .where('sellerId', isEqualTo: sellerId)
          .where('currentStatus', isEqualTo: status.value)
          .get();

      print(
          '✅ ${querySnapshot.docs.length} commandes trouvées pour statut ${status.label}');

      final orders = querySnapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();

      // Trier localement
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return orders;
    } catch (e) {
      print('❌ Erreur lors de la récupération des commandes par statut: $e');
      return [];
    }
  }

  /// Stream des commandes d'un vendeur par statut (temps réel)
  Stream<List<OrderModel>> streamOrdersBySellerIdAndStatus(
    String sellerId,
    OrderStatus status,
  ) {
    print(
        '🔄 Stream des commandes pour sellerId: $sellerId, statut: ${status.value}');

    return _firestore
        .collection(_ordersCollection)
        .where('sellerId', isEqualTo: sellerId)
        .where('currentStatus', isEqualTo: status.value)
        .snapshots()
        .map((snapshot) {
      print(
          '📦 Stream reçu: ${snapshot.docs.length} commandes pour ${status.label}');
      final orders =
          snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    }).handleError((error) {
      print('❌ Erreur dans le stream par statut: $error');
      return <OrderModel>[];
    });
  }

  /// Mettre à jour le statut d'une commande
  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
    String? comment,
    String? updatedBy,
  }) async {
    try {
      final orderDoc =
          await _firestore.collection(_ordersCollection).doc(orderId).get();

      if (!orderDoc.exists) {
        throw Exception('Commande introuvable');
      }

      final order = OrderModel.fromFirestore(orderDoc);

      // Créer une nouvelle entrée dans l'historique
      final newHistoryEntry = StatusHistory(
        status: newStatus,
        timestamp: DateTime.now(),
        comment: comment,
        updatedBy: updatedBy,
      );

      // Mettre à jour l'historique
      final updatedHistory = [...order.statusHistory, newHistoryEntry];

      // Mettre à jour la commande
      await _firestore.collection(_ordersCollection).doc(orderId).update({
        'currentStatus': newStatus.value,
        'statusHistory': updatedHistory.map((h) => h.toMap()).toList(),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      print('✅ Statut de la commande mis à jour: ${newStatus.label}');
    } catch (e) {
      print('❌ Erreur lors de la mise à jour du statut: $e');
      rethrow;
    }
  }

  /// Valider une commande (vendeur)
  Future<void> validateOrder({
    required String orderId,
    String? comment,
    String? validatedBy,
  }) async {
    await updateOrderStatus(
      orderId: orderId,
      newStatus: OrderStatus.validated,
      comment: comment ?? 'Commande validée par le vendeur',
      updatedBy: validatedBy,
    );
  }

  /// Refuser une commande (vendeur)
  Future<void> rejectOrder({
    required String orderId,
    required String reason,
    String? rejectedBy,
  }) async {
    try {
      await _firestore.collection(_ordersCollection).doc(orderId).update({
        'currentStatus': OrderStatus.rejected.value,
        'rejectionReason': reason,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      // Ajouter à l'historique
      await updateOrderStatus(
        orderId: orderId,
        newStatus: OrderStatus.rejected,
        comment: 'Commande refusée: $reason',
        updatedBy: rejectedBy,
      );

      print('✅ Commande refusée');
    } catch (e) {
      print('❌ Erreur lors du refus de la commande: $e');
      rethrow;
    }
  }

  /// Marquer une commande comme en préparation
  Future<void> startPreparation({
    required String orderId,
    String? startedBy,
  }) async {
    await updateOrderStatus(
      orderId: orderId,
      newStatus: OrderStatus.inPreparation,
      comment: 'Préparation de la commande commencée',
      updatedBy: startedBy,
    );
  }

  /// Marquer une commande comme prête pour livraison
  Future<void> markReadyForDelivery({
    required String orderId,
    String? markedBy,
  }) async {
    await updateOrderStatus(
      orderId: orderId,
      newStatus: OrderStatus.readyForDelivery,
      comment: 'Commande prête pour livraison',
      updatedBy: markedBy,
    );
  }

  /// Marquer une commande comme en cours de livraison
  Future<void> startDelivery({
    required String orderId,
    String? startedBy,
  }) async {
    await updateOrderStatus(
      orderId: orderId,
      newStatus: OrderStatus.inDelivery,
      comment: 'Livraison en cours',
      updatedBy: startedBy,
    );
  }

  /// Marquer une commande comme livrée
  Future<void> markAsDelivered({
    required String orderId,
    String? deliveredBy,
  }) async {
    await updateOrderStatus(
      orderId: orderId,
      newStatus: OrderStatus.delivered,
      comment: 'Commande livrée',
      updatedBy: deliveredBy,
    );
  }

  /// Confirmer la réception (client)
  Future<void> confirmDelivery({
    required String orderId,
    String? confirmedBy,
  }) async {
    await updateOrderStatus(
      orderId: orderId,
      newStatus: OrderStatus.completed,
      comment: 'Réception confirmée par le client',
      updatedBy: confirmedBy,
    );
  }

  /// Annuler une commande
  Future<void> cancelOrder({
    required String orderId,
    required String reason,
    String? cancelledBy,
  }) async {
    try {
      await _firestore.collection(_ordersCollection).doc(orderId).update({
        'currentStatus': OrderStatus.cancelled.value,
        'notes': reason,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      await updateOrderStatus(
        orderId: orderId,
        newStatus: OrderStatus.cancelled,
        comment: 'Commande annulée: $reason',
        updatedBy: cancelledBy,
      );

      print('✅ Commande annulée');
    } catch (e) {
      print('❌ Erreur lors de l\'annulation de la commande: $e');
      rethrow;
    }
  }

  /// Compter les commandes par statut pour un vendeur
  Future<Map<OrderStatus, int>> getOrderCountsByStatus(String sellerId) async {
    try {
      final orders = await getOrdersBySellerId(sellerId);
      final counts = <OrderStatus, int>{};

      for (final status in OrderStatus.values) {
        counts[status] = orders.where((o) => o.currentStatus == status).length;
      }

      return counts;
    } catch (e) {
      print('❌ Erreur lors du comptage des commandes: $e');
      return {};
    }
  }

  /// Supprimer une commande (admin seulement)
  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection(_ordersCollection).doc(orderId).delete();
      print('✅ Commande supprimée');
    } catch (e) {
      print('❌ Erreur lors de la suppression de la commande: $e');
      rethrow;
    }
  }
}
