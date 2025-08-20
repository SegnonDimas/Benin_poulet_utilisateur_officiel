import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:benin_poulet/models/store.dart';
import 'package:benin_poulet/models/produit.dart';
import 'package:benin_poulet/models/order.dart';
import 'package:benin_poulet/models/store_review.dart';
import 'package:benin_poulet/models/product_review.dart';

class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  // Initialisation des boîtes de stockage
  static final GetStorage _storesBox = GetStorage('stores');
  static final GetStorage _productsBox = GetStorage('products');
  static final GetStorage _ordersBox = GetStorage('orders');
  static final GetStorage _storeReviewsBox = GetStorage('store_reviews');
  static final GetStorage _productReviewsBox = GetStorage('product_reviews');
  static final GetStorage _appSettingsBox = GetStorage('app_settings');

  // Clés de cache
  static const String _lastSyncKey = 'last_sync';
  static const String _cacheExpiryKey = 'cache_expiry';
  static const String _offlineActionsKey = 'offline_actions';
  static const String _userPreferencesKey = 'user_preferences';

  // Durée de validité du cache (24 heures)
  static const Duration _cacheExpiryDuration = Duration(hours: 24);

  /// Initialise le cache manager
  static Future<void> init() async {
    await GetStorage.init('stores');
    await GetStorage.init('products');
    await GetStorage.init('orders');
    await GetStorage.init('store_reviews');
    await GetStorage.init('product_reviews');
    await GetStorage.init('app_settings');
  }

  /// Vérifie si la connexion internet est disponible
  static Future<bool> isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.isNotEmpty && connectivityResult.first != ConnectivityResult.none;
  }

  /// Vérifie si le cache est valide
  static bool isCacheValid() {
    final lastSync = _appSettingsBox.read(_lastSyncKey) as DateTime?;
    if (lastSync == null) return false;
    
    final now = DateTime.now();
    return now.difference(lastSync) < _cacheExpiryDuration;
  }

  /// Met à jour le timestamp de dernière synchronisation
  static void updateLastSync() {
    _appSettingsBox.write(_lastSyncKey, DateTime.now());
  }

  // ===== GESTION DES BOUTIQUES =====

  /// Sauvegarde une liste de boutiques en cache
  static Future<void> cacheStores(List<Store> stores) async {
    final storesData = stores.map((store) => store.toMap()).toList();
    await _storesBox.write('all_stores', storesData);
    updateLastSync();
  }

  /// Récupère les boutiques depuis le cache
  static List<Store> getCachedStores() {
    final storesData = _storesBox.read('all_stores') as List<dynamic>?;
    if (storesData == null) return [];
    
    return storesData
        .map((data) => Store.fromMap(Map<String, dynamic>.from(data)))
        .toList();
  }

  /// Sauvegarde une boutique spécifique
  static Future<void> cacheStore(Store store) async {
    await _storesBox.write('store_${store.storeId}', store.toMap());
  }

  /// Récupère une boutique spécifique depuis le cache
  static Store? getCachedStore(String storeId) {
    final storeData = _storesBox.read('store_$storeId') as Map<String, dynamic>?;
    if (storeData == null) return null;
    
    return Store.fromMap(storeData);
  }

  // ===== GESTION DES PRODUITS =====

  /// Sauvegarde une liste de produits en cache
  static Future<void> cacheProducts(List<Produit> products) async {
    final productsData = products.map((product) => product.toMap()).toList();
    await _productsBox.write('all_products', productsData);
    updateLastSync();
  }

  /// Récupère les produits depuis le cache
  static List<Produit> getCachedProducts() {
    final productsData = _productsBox.read('all_products') as List<dynamic>?;
    if (productsData == null) return [];
    
    return productsData
        .map((data) => Produit.fromMap(Map<String, dynamic>.from(data)))
        .toList();
  }

  /// Sauvegarde les produits d'une boutique
  static Future<void> cacheStoreProducts(String storeId, List<Produit> products) async {
    final productsData = products.map((product) => product.toMap()).toList();
    await _productsBox.write('store_products_$storeId', productsData);
  }

                /// Récupère les produits d'une boutique depuis le cache
              static List<Produit> getCachedStoreProducts(String storeId) {
                final productsData = _productsBox.read('store_products_$storeId') as List<dynamic>?;
                if (productsData == null) return [];

                return productsData
                    .map((data) => Produit.fromMap(Map<String, dynamic>.from(data)))
                    .toList();
              }

              /// Sauvegarde les produits d'un vendeur en cache
              static Future<void> cacheVendorProducts(String sellerId, List<Produit> products) async {
                final productsData = products.map((product) => product.toMap()).toList();
                await _productsBox.write('vendor_products_$sellerId', productsData);
                updateLastSync();
              }

              /// Récupère les produits d'un vendeur depuis le cache
              static List<Produit> getCachedVendorProducts(String sellerId) {
                final productsData = _productsBox.read('vendor_products_$sellerId') as List<dynamic>?;
                if (productsData == null) return [];

                return productsData
                    .map((data) => Produit.fromMap(Map<String, dynamic>.from(data)))
                    .toList();
              }

  // ===== GESTION DES COMMANDES =====

  /// Sauvegarde les commandes d'un vendeur en cache
  static Future<void> cacheVendorOrders(String sellerId, List<Order> orders) async {
    final ordersData = orders.map((order) => order.toMap()).toList();
    await _ordersBox.write('vendor_orders_$sellerId', ordersData);
    updateLastSync();
  }

  /// Récupère les commandes d'un vendeur depuis le cache
  static List<Order> getCachedVendorOrders(String sellerId) {
    final ordersData = _ordersBox.read('vendor_orders_$sellerId') as List<dynamic>?;
    if (ordersData == null) return [];
    
    return ordersData
        .map((data) => Order.fromMap(Map<String, dynamic>.from(data)))
        .toList();
  }

  /// Sauvegarde une commande spécifique
  static Future<void> cacheOrder(Order order) async {
    await _ordersBox.write('order_${order.orderId}', order.toMap());
  }

  /// Récupère une commande spécifique depuis le cache
  static Order? getCachedOrder(String orderId) {
    final orderData = _ordersBox.read('order_$orderId') as Map<String, dynamic>?;
    if (orderData == null) return null;
    
    return Order.fromMap(orderData);
  }

  // ===== GESTION DES AVIS =====

  /// Sauvegarde les avis d'une boutique en cache
  static Future<void> cacheStoreReviews(String storeId, List<StoreReview> reviews) async {
    final reviewsData = reviews.map((review) => review.toMap()).toList();
    await _storeReviewsBox.write('store_reviews_$storeId', reviewsData);
  }

  /// Récupère les avis d'une boutique depuis le cache
  static List<StoreReview> getCachedStoreReviews(String storeId) {
    final reviewsData = _storeReviewsBox.read('store_reviews_$storeId') as List<dynamic>?;
    if (reviewsData == null) return [];
    
    return reviewsData
        .map((data) => StoreReview.fromMap(Map<String, dynamic>.from(data)))
        .toList();
  }

  /// Sauvegarde les avis d'un produit en cache
  static Future<void> cacheProductReviews(String productId, List<ProductReview> reviews) async {
    final reviewsData = reviews.map((review) => review.toMap()).toList();
    await _productReviewsBox.write('product_reviews_$productId', reviewsData);
  }

  /// Récupère les avis d'un produit depuis le cache
  static List<ProductReview> getCachedProductReviews(String productId) {
    final reviewsData = _productReviewsBox.read('product_reviews_$productId') as List<dynamic>?;
    if (reviewsData == null) return [];
    
    return reviewsData
        .map((data) => ProductReview.fromMap(Map<String, dynamic>.from(data)))
        .toList();
  }

  // ===== GESTION DES ACTIONS HORS LIGNE =====

  /// Ajoute une action à la file d'attente hors ligne
  static Future<void> addOfflineAction(Map<String, dynamic> action) async {
    final actions = getOfflineActions();
    actions.add({
      ...action,
      'timestamp': DateTime.now().toIso8601String(),
    });
    await _appSettingsBox.write(_offlineActionsKey, actions);
  }

  /// Récupère toutes les actions en attente
  static List<Map<String, dynamic>> getOfflineActions() {
    final actions = _appSettingsBox.read(_offlineActionsKey) as List<dynamic>?;
    return actions?.cast<Map<String, dynamic>>() ?? [];
  }

  /// Supprime une action de la file d'attente
  static Future<void> removeOfflineAction(int index) async {
    final actions = getOfflineActions();
    if (index < actions.length) {
      actions.removeAt(index);
      await _appSettingsBox.write(_offlineActionsKey, actions);
    }
  }

  /// Vide la file d'attente des actions hors ligne
  static Future<void> clearOfflineActions() async {
    await _appSettingsBox.remove(_offlineActionsKey);
  }

  // ===== GESTION DES PRÉFÉRENCES UTILISATEUR =====

  /// Sauvegarde les préférences utilisateur
  static Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    await _appSettingsBox.write(_userPreferencesKey, preferences);
  }

  /// Récupère les préférences utilisateur
  static Map<String, dynamic> getUserPreferences() {
    final preferences = _appSettingsBox.read(_userPreferencesKey) as Map<String, dynamic>?;
    return preferences ?? {};
  }

  // ===== NETTOYAGE DU CACHE =====

  /// Nettoie le cache expiré
  static Future<void> clearExpiredCache() async {
    if (!isCacheValid()) {
      await _storesBox.erase();
      await _productsBox.erase();
      await _ordersBox.erase();
      await _storeReviewsBox.erase();
      await _productReviewsBox.erase();
    }
  }

  /// Nettoie tout le cache
  static Future<void> clearAllCache() async {
    await _storesBox.erase();
    await _productsBox.erase();
    await _ordersBox.erase();
    await _storeReviewsBox.erase();
    await _productReviewsBox.erase();
    await _appSettingsBox.erase();
  }

  /// Obtient la taille du cache
  static Future<int> getCacheSize() async {
    // Note: GetStorage ne fournit pas directement la taille du cache
    // Cette méthode est un placeholder pour une future implémentation
    return 0;
  }
}
