import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:benin_poulet/core/firebase/firestore/product_repository.dart';
import 'package:benin_poulet/core/firebase/auth/auth_services.dart';
import 'package:benin_poulet/core/firebase/firestore/firestore_service.dart';
import 'package:benin_poulet/models/produit.dart';
import 'package:benin_poulet/services/cache_manager.dart';

// Événements
abstract class ProductEvent {}

class LoadVendorProducts extends ProductEvent {}

class LoadVendorProductsByStatus extends ProductEvent {
  final String status;
  LoadVendorProductsByStatus(this.status);
}

class AddProduct extends ProductEvent {
  final Produit product;
  AddProduct(this.product);
}

class UpdateProduct extends ProductEvent {
  final String productId;
  final Map<String, dynamic> updates;
  UpdateProduct(this.productId, this.updates);
}

class DeleteProduct extends ProductEvent {
  final String productId;
  DeleteProduct(this.productId);
}

class RefreshProducts extends ProductEvent {}

class RechercherProduit extends ProductEvent {
  final String query;
  RechercherProduit(this.query);
}

class ReinitialiserRecherche extends ProductEvent {}

class DebugProducts extends ProductEvent {}

// États
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Produit> products;
  final bool isFromCache;
  ProductsLoaded(this.products, {this.isFromCache = false});
}

class ProductError extends ProductState {
  final String message;
  final bool hasCachedData;
  ProductError(this.message, {this.hasCachedData = false});
}

class ProductAdded extends ProductState {
  final Produit product;
  ProductAdded(this.product);
}

class ProductUpdated extends ProductState {
  final Produit product;
  ProductUpdated(this.product);
}

class ProductDeleted extends ProductState {
  final String productId;
  ProductDeleted(this.productId);
}

class ProductsOffline extends ProductState {
  final List<Produit> cachedProducts;
  final String message;
  ProductsOffline({required this.cachedProducts, required this.message});
}

class ProduitFiltre extends ProductState {
  final List<Produit> produits;
  ProduitFiltre(this.produits);
  
  // Getter pour compatibilité avec l'ancien code
  List<Produit> get produitsFiltres => produits;
}

// BLoC
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository = ProductRepository();
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription<List<Produit>>? _productsSubscription;

  ProductBloc() : super(ProductInitial()) {
    on<LoadVendorProducts>(_onLoadVendorProducts);
    on<LoadVendorProductsByStatus>(_onLoadVendorProductsByStatus);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<RefreshProducts>(_onRefreshProducts);
    on<RechercherProduit>(_onRechercherProduit);
    on<ReinitialiserRecherche>(_onReinitialiserRecherche);
    on<DebugProducts>(_onDebugProducts);
    
    // Charger automatiquement les produits du vendeur au démarrage
    add(LoadVendorProducts());
  }

  Future<void> _onLoadVendorProducts(
    LoadVendorProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    try {
      final currentUserId = AuthServices.auth.currentUser?.uid;
      if (currentUserId == null) {
        emit(ProductError('Aucun utilisateur connecté'));
        return;
      }

      // Vérifier d'abord le cache
      final cachedProducts = CacheManager.getCachedVendorProducts(currentUserId);
      if (cachedProducts.isNotEmpty) {
        emit(ProductsLoaded(cachedProducts, isFromCache: true));
      }

      // Vérifier la connectivité
      final isOnline = await CacheManager.isOnline();
      if (!isOnline) {
        if (cachedProducts.isNotEmpty) {
          emit(ProductsOffline(
            cachedProducts: cachedProducts,
            message: 'Mode hors ligne - Données en cache affichées',
          ));
        } else {
          emit(ProductError(
            'Aucune donnée disponible hors ligne. Veuillez vérifier votre connexion.',
            hasCachedData: false,
          ));
        }
        return;
      }

      // Récupérer le storeId de la boutique du vendeur
      String? storeId;
      try {
        final sellerWithStores = await _firestoreService.getSellerWithStores(currentUserId);
        if (sellerWithStores != null && sellerWithStores['stores'] != null) {
          final stores = sellerWithStores['stores'] as List;
          if (stores.isNotEmpty) {
            storeId = stores.first.storeId; // Prendre la première boutique
          }
        }
      } catch (e) {
        print('Erreur lors de la récupération du storeId: $e');
      }

      // Récupérer les données depuis Firestore avec stream en temps réel
      try {
        Stream<List<Produit>> productsStream;
        if (storeId != null) {
          // Utiliser le storeId si disponible
          productsStream = _productRepository.getProductsByStoreForVendor(storeId);
        } else {
          // Fallback sur sellerId si pas de storeId
          productsStream = _productRepository.getProductsBySeller(currentUserId);
        }
        
        // Annuler l'abonnement précédent s'il existe
        await _productsSubscription?.cancel();
        
        // Écouter le stream en temps réel
        _productsSubscription = productsStream.listen((products) async {
          await CacheManager.cacheVendorProducts(currentUserId, products);
          emit(ProductsLoaded(products, isFromCache: false));
        });
        
        // Émettre les premiers produits
        final initialProducts = await productsStream.first;
        await CacheManager.cacheVendorProducts(currentUserId, initialProducts);
        emit(ProductsLoaded(initialProducts, isFromCache: false));
      } catch (e) {
        // Si aucun produit n'est trouvé, émettre une liste vide
        if (e.toString().contains('NoSuchElementException') || 
            e.toString().contains('StateError')) {
          emit(ProductsLoaded([], isFromCache: false));
        } else {
          emit(ProductError('Erreur lors du chargement des produits: $e'));
        }
      }
    } catch (e) {
      // En cas d'erreur, essayer d'utiliser le cache
      final currentUserId = AuthServices.auth.currentUser?.uid;
      if (currentUserId != null) {
        final cachedProducts = CacheManager.getCachedVendorProducts(currentUserId);
        if (cachedProducts.isNotEmpty) {
          emit(ProductsOffline(
            cachedProducts: cachedProducts,
            message: 'Erreur de connexion. Données en cache affichées.',
          ));
          return;
        }
      }

      emit(ProductError('Erreur lors du chargement des produits: $e'));
    }
  }

  Future<void> _onLoadVendorProductsByStatus(
    LoadVendorProductsByStatus event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    try {
      final currentUserId = AuthServices.auth.currentUser?.uid;
      if (currentUserId == null) {
        emit(ProductError('Aucun utilisateur connecté'));
        return;
      }

      // Vérifier d'abord le cache
      final cachedProducts = CacheManager.getCachedVendorProducts(currentUserId);
      final filteredCachedProducts = cachedProducts.where((p) => p.productStatus == event.status).toList();
      if (filteredCachedProducts.isNotEmpty) {
        emit(ProductsLoaded(filteredCachedProducts, isFromCache: true));
      }

      // Vérifier la connectivité
      final isOnline = await CacheManager.isOnline();
      if (!isOnline) {
        if (filteredCachedProducts.isNotEmpty) {
          emit(ProductsOffline(
            cachedProducts: filteredCachedProducts,
            message: 'Mode hors ligne - Données en cache affichées',
          ));
        } else {
          emit(ProductError(
            'Aucune donnée disponible hors ligne. Veuillez vérifier votre connexion.',
            hasCachedData: false,
          ));
        }
        return;
      }

      // Récupérer les données depuis Firestore
      try {
        final productsStream = _productRepository.getProductsBySellerAndStatus(currentUserId, event.status);
        final products = await productsStream.first;
        await CacheManager.cacheVendorProducts(currentUserId, products);
        emit(ProductsLoaded(products, isFromCache: false));
      } catch (e) {
        // Si aucun produit n'est trouvé, émettre une liste vide
        if (e.toString().contains('NoSuchElementException') || 
            e.toString().contains('StateError')) {
          emit(ProductsLoaded([], isFromCache: false));
        } else {
          emit(ProductError('Erreur lors du chargement des produits: $e'));
        }
      }
    } catch (e) {
      // En cas d'erreur, essayer d'utiliser le cache
      final currentUserId = AuthServices.auth.currentUser?.uid;
      if (currentUserId != null) {
        final cachedProducts = CacheManager.getCachedVendorProducts(currentUserId);
        final filteredCachedProducts = cachedProducts.where((p) => p.productStatus == event.status).toList();
        if (filteredCachedProducts.isNotEmpty) {
          emit(ProductsOffline(
            cachedProducts: filteredCachedProducts,
            message: 'Erreur de connexion. Données en cache affichées.',
          ));
          return;
        }
      }

      emit(ProductError('Erreur lors du chargement des produits: $e'));
    }
  }

  Future<void> _onDebugProducts(
    DebugProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      print('=== DÉBOGAGE DES PRODUITS ===');
      final allProducts = await _productRepository.getAllProductsForDebug();
      print('Nombre total de produits dans Firestore: ${allProducts.length}');
      
      for (final product in allProducts) {
        print('Produit: ${product['name']} - storeId: ${product['storeId']} - sellerId: ${product['sellerId']} - status: ${product['status']}');
      }
      
      final currentUserId = AuthServices.auth.currentUser?.uid;
      print('Utilisateur connecté: $currentUserId');
      
      if (currentUserId != null) {
        final sellerWithStores = await _firestoreService.getSellerWithStores(currentUserId);
        print('Boutiques du vendeur: $sellerWithStores');
      }
    } catch (e) {
      print('Erreur lors du débogage: $e');
    }
  }

  Future<void> _onAddProduct(
    AddProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final currentUserId = AuthServices.auth.currentUser?.uid;
      if (currentUserId == null) {
        emit(ProductError('Aucun utilisateur connecté'));
        return;
      }

      // Récupérer le storeId de la boutique du vendeur
      String? storeId;
      try {
        final sellerWithStores = await _firestoreService.getSellerWithStores(currentUserId);
        if (sellerWithStores != null && sellerWithStores['stores'] != null) {
          final stores = sellerWithStores['stores'] as List;
          if (stores.isNotEmpty) {
            storeId = stores.first.storeId; // Prendre la première boutique
          }
        }
      } catch (e) {
        print('Erreur lors de la récupération du storeId: $e');
      }

      // S'assurer que le produit a le bon sellerId et storeId
      final productWithIds = event.product.copyWith(
        sellerId: currentUserId,
        storeId: storeId ?? 'unknown',
        createdAt: DateTime.now(),
      );

      final isOnline = await CacheManager.isOnline();
      if (isOnline) {
        final productId = await _productRepository.createProduct(productWithIds);
        final createdProduct = productWithIds.copyWith(productId: productId);
        
        // Mettre en cache le nouveau produit
        final cachedProducts = CacheManager.getCachedVendorProducts(currentUserId);
        cachedProducts.add(createdProduct);
        await CacheManager.cacheVendorProducts(currentUserId, cachedProducts);
        
        emit(ProductAdded(createdProduct));
      } else {
        // Mode hors ligne - ajouter à la file d'attente
        await CacheManager.addOfflineAction({
          'type': 'create_product',
          'data': productWithIds.toMap(),
        });

        emit(ProductError(
          'Produit ajouté à la file d\'attente. Il sera synchronisé quand vous serez en ligne.',
          hasCachedData: false,
        ));
      }
    } catch (e) {
      emit(ProductError('Erreur lors de l\'ajout du produit: $e'));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final isOnline = await CacheManager.isOnline();
      if (isOnline) {
        await _productRepository.updateProduct(event.productId, event.updates);
        
        // Recharger les produits pour avoir les données mises à jour
        add(LoadVendorProducts());
      } else {
        // Mode hors ligne - ajouter à la file d'attente
        await CacheManager.addOfflineAction({
          'type': 'update_product',
          'productId': event.productId,
          'updates': event.updates,
        });

        emit(ProductError(
          'Mise à jour ajoutée à la file d\'attente. Elle sera synchronisée quand vous serez en ligne.',
          hasCachedData: false,
        ));
      }
    } catch (e) {
      emit(ProductError('Erreur lors de la mise à jour du produit: $e'));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final isOnline = await CacheManager.isOnline();
      if (isOnline) {
        await _productRepository.deleteProduct(event.productId);
        
        // Retirer du cache
        final currentUserId = AuthServices.auth.currentUser?.uid;
        if (currentUserId != null) {
          final cachedProducts = CacheManager.getCachedVendorProducts(currentUserId);
          cachedProducts.removeWhere((product) => product.productId == event.productId);
          await CacheManager.cacheVendorProducts(currentUserId, cachedProducts);
        }
        
        emit(ProductDeleted(event.productId));
        
        // Recharger les produits pour mettre à jour l'affichage
        add(LoadVendorProducts());
      } else {
        // Mode hors ligne - ajouter à la file d'attente
        await CacheManager.addOfflineAction({
          'type': 'delete_product',
          'productId': event.productId,
        });

        emit(ProductError(
          'Suppression ajoutée à la file d\'attente. Elle sera synchronisée quand vous serez en ligne.',
          hasCachedData: false,
        ));
      }
    } catch (e) {
      emit(ProductError('Erreur lors de la suppression du produit: $e'));
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading());
      
      final currentUserId = AuthServices.auth.currentUser?.uid;
      if (currentUserId == null) {
        emit(ProductError('Aucun utilisateur connecté'));
        return;
      }

      // Vider le cache pour forcer le rechargement
      await CacheManager.cacheVendorProducts(currentUserId, []);

      // Recharger depuis Firestore
      add(LoadVendorProducts());
    } catch (e) {
      emit(ProductError('Erreur lors du rafraîchissement: $e'));
    }
  }

  void _onRechercherProduit(
    RechercherProduit event,
    Emitter<ProductState> emit,
  ) {
    // Si la requête est vide, revenir à l'état précédent
    if (event.query.trim().isEmpty) {
      _onReinitialiserRecherche(ReinitialiserRecherche(), emit);
      return;
    }

    // Récupérer les produits actuels depuis le cache ou l'état
    final currentState = state;
    List<Produit> produits = [];
    
    if (currentState is ProductsLoaded) {
      produits = currentState.products;
    } else if (currentState is ProductsOffline) {
      produits = currentState.cachedProducts;
    } else if (currentState is ProduitFiltre) {
      // Si on est déjà dans un état filtré, utiliser les produits originaux
      // On doit récupérer les produits originaux depuis le cache
      final currentUserId = AuthServices.auth.currentUser?.uid;
      if (currentUserId != null) {
        produits = CacheManager.getCachedVendorProducts(currentUserId);
      }
    }

    // Filtrer les produits selon la recherche
    final resultats = produits.where((produit) {
      final query = event.query.toLowerCase();
      final nomCorrespond = produit.productName.toLowerCase().contains(query);
      final variationCorrespond = produit.varieties.any(
        (variation) => variation.toLowerCase().contains(query),
      );
      return nomCorrespond || variationCorrespond;
    }).toList();

    emit(ProduitFiltre(resultats));
  }

  void _onReinitialiserRecherche(
    ReinitialiserRecherche event,
    Emitter<ProductState> emit,
  ) {
    // Récupérer les produits originaux depuis le cache
    final currentUserId = AuthServices.auth.currentUser?.uid;
    if (currentUserId != null) {
      final cachedProducts = CacheManager.getCachedVendorProducts(currentUserId);
      if (cachedProducts.isNotEmpty) {
        emit(ProductsLoaded(cachedProducts, isFromCache: true));
      } else {
        // Si pas de cache, recharger depuis Firestore
        add(LoadVendorProducts());
      }
    } else {
      // Si pas d'utilisateur connecté, recharger depuis Firestore
      add(LoadVendorProducts());
    }
  }

  @override
  Future<void> close() {
    _productsSubscription?.cancel();
    return super.close();
  }
}
