import 'package:benin_poulet/core/firebase/firestore/firestore_service.dart';
import 'package:benin_poulet/core/firebase/firestore/order_repository.dart';
import 'package:benin_poulet/core/firebase/firestore/product_repository.dart';
import 'package:benin_poulet/services/cache_manager.dart';
import 'package:benin_poulet/models/order.dart';
import 'package:benin_poulet/models/store_review.dart';
import 'package:benin_poulet/models/product_review.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final FirestoreService _firestoreService = FirestoreService();
  final OrderRepository _orderRepository = OrderRepository();
  final ProductRepository _productRepository = ProductRepository();

  /// Synchronise toutes les actions en attente
  static Future<void> syncOfflineActions() async {
    final isOnline = await CacheManager.isOnline();
    if (!isOnline) return;

    final actions = CacheManager.getOfflineActions();
    if (actions.isEmpty) return;

    final syncService = SyncService();
    
    for (int i = 0; i < actions.length; i++) {
      final action = actions[i];
      try {
        await syncService._processOfflineAction(action);
        await CacheManager.removeOfflineAction(i);
        // Ajuster l'index car on a supprimé un élément
        i--;
      } catch (e) {
        print('Erreur lors de la synchronisation de l\'action: $e');
        // Continuer avec les autres actions
      }
    }
  }

  /// Traite une action hors ligne spécifique
  Future<void> _processOfflineAction(Map<String, dynamic> action) async {
    final actionType = action['type'] as String;
    
    switch (actionType) {
      case 'create_order':
        await _syncCreateOrder(action);
        break;
      case 'update_order_status':
        await _syncUpdateOrderStatus(action);
        break;
      case 'create_store_review':
        await _syncCreateStoreReview(action);
        break;
      case 'create_product_review':
        await _syncCreateProductReview(action);
        break;
      default:
        print('Type d\'action non reconnu: $actionType');
    }
  }

  /// Synchronise la création d'une commande
  Future<void> _syncCreateOrder(Map<String, dynamic> action) async {
    final orderData = action['data'] as Map<String, dynamic>;
    final order = Order.fromMap(orderData);
    
    await _orderRepository.createOrder(order);
  }

  /// Synchronise la mise à jour du statut d'une commande
  Future<void> _syncUpdateOrderStatus(Map<String, dynamic> action) async {
    final orderId = action['orderId'] as String;
    final status = action['status'] as String;
    
    await _orderRepository.updateOrderStatus(orderId, status);
  }

  /// Synchronise la création d'un avis de boutique
  Future<void> _syncCreateStoreReview(Map<String, dynamic> action) async {
    final reviewData = action['data'] as Map<String, dynamic>;
    final review = StoreReview.fromMap(reviewData);
    
    await _firestoreService.createStoreReview(
      userId: review.userId,
      storeId: review.storeId,
      stars: review.stars,
      message: review.message,
      autresInfos: review.autresInfos,
    );
  }

  /// Synchronise la création d'un avis de produit
  Future<void> _syncCreateProductReview(Map<String, dynamic> action) async {
    final reviewData = action['data'] as Map<String, dynamic>;
    final review = ProductReview.fromMap(reviewData);
    
    await _firestoreService.createProductReview(
      userId: review.userId,
      productId: review.productId,
      storeId: review.storeId,
      stars: review.stars,
      message: review.message,
      autresInfos: review.autresInfos,
    );
  }

  /// Synchronise les données avec Firestore
  static Future<void> syncData() async {
    final isOnline = await CacheManager.isOnline();
    if (!isOnline) return;

    final syncService = SyncService();
    
    try {
      // Synchroniser les actions hors ligne
      await syncOfflineActions();
      
      // Synchroniser les données principales
      await syncService._syncStores();
      await syncService._syncProducts();
      
      // Marquer la synchronisation comme réussie
      CacheManager.updateLastSync();
    } catch (e) {
      print('Erreur lors de la synchronisation: $e');
    }
  }

  /// Synchronise les boutiques
  Future<void> _syncStores() async {
    try {
      final storesStream = _firestoreService.getAllStores();
      final stores = await storesStream.first;
      await CacheManager.cacheStores(stores);
    } catch (e) {
      print('Erreur lors de la synchronisation des boutiques: $e');
    }
  }

  /// Synchronise les produits
  Future<void> _syncProducts() async {
    try {
      final productsStream = _productRepository.getAllActiveProducts();
      final products = await productsStream.first;
      await CacheManager.cacheProducts(products);
    } catch (e) {
      print('Erreur lors de la synchronisation des produits: $e');
    }
  }

  /// Synchronise les commandes d'un vendeur
  static Future<void> syncVendorOrders(String sellerId) async {
    final isOnline = await CacheManager.isOnline();
    if (!isOnline) return;

    try {
      final syncService = SyncService();
      final ordersStream = syncService._orderRepository.getOrdersBySeller(sellerId);
      final orders = await ordersStream.first;
      await CacheManager.cacheVendorOrders(sellerId, orders as List<Order>);
    } catch (e) {
      print('Erreur lors de la synchronisation des commandes: $e');
    }
  }

  /// Synchronise les avis d'une boutique
  static Future<void> syncStoreReviews(String storeId) async {
    final isOnline = await CacheManager.isOnline();
    if (!isOnline) return;

    try {
      final syncService = SyncService();
      final reviewsStream = syncService._firestoreService.getStoreReviews(storeId);
      final reviews = await reviewsStream.first;
      await CacheManager.cacheStoreReviews(storeId, reviews);
    } catch (e) {
      print('Erreur lors de la synchronisation des avis de boutique: $e');
    }
  }

  /// Synchronise les avis d'un produit
  static Future<void> syncProductReviews(String productId) async {
    final isOnline = await CacheManager.isOnline();
    if (!isOnline) return;

    try {
      final syncService = SyncService();
      final reviewsStream = syncService._firestoreService.getProductReviews(productId);
      final reviews = await reviewsStream.first;
      await CacheManager.cacheProductReviews(productId, reviews);
    } catch (e) {
      print('Erreur lors de la synchronisation des avis de produit: $e');
    }
  }
}
