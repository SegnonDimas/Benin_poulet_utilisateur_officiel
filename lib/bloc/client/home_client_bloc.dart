import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:benin_poulet/core/firebase/firestore/firestore_service.dart';
import 'package:benin_poulet/core/firebase/firestore/product_repository.dart';
import 'package:benin_poulet/models/produit.dart';
import 'package:benin_poulet/models/store.dart';
import 'package:benin_poulet/services/cache_manager.dart';
import 'package:benin_poulet/services/cart_service.dart';

// Modèles adaptés pour l'interface client
class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double? originalPrice; // Prix original (pour les promotions)
  final String description;
  final String category;
  final String storeId; // Ajout du storeId pour les avis
  final String storeName; // Ajout du nom de la boutique
  final bool isInPromotion; // Ajout de la propriété promotion
  final Map<String, String> productProperties; // Propriétés du produit
  final List<String> varieties; // Variétés du produit

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.description,
    required this.category,
    required this.storeId,
    required this.storeName,
    this.isInPromotion = false,
    this.productProperties = const {},
    this.varieties = const [],
  });

  factory Product.fromProduit(Produit produit, {String? storeName}) {
    return Product(
      id: produit.productId ?? '',
      name: produit.productName,
      imageUrl: produit.productImagesPath.isNotEmpty ? produit.productImagesPath.first : '',
      price: produit.isInPromotion && produit.promoPrice != null ? produit.promoPrice! : produit.productUnitPrice,
      originalPrice: produit.isInPromotion ? produit.productUnitPrice : null,
      description: produit.productDescription,
      category: produit.category,
      storeId: produit.storeId,
      storeName: storeName ?? 'Boutique',
      isInPromotion: produit.isInPromotion,
      productProperties: produit.productProperties,
      varieties: produit.varieties,
    );
  }
}

class StoreClient {
  final String id;
  final String name;
  final String imageUrl;
  final String location;
  final double rating;
  final String description;

  StoreClient({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.rating,
    required this.description,
  });

  factory StoreClient.fromStoreModel(Store storeModel) {
    return StoreClient(
      id: storeModel.storeId,
      name: storeModel.storeInfos?['name'] ?? 'Boutique',
      imageUrl: storeModel.storeLogoPath ?? '',
      location: storeModel.ville ?? storeModel.storeAddress ?? 'Localisation non définie',
      rating: storeModel.storeRatings?.isNotEmpty == true 
          ? storeModel.storeRatings!.reduce((a, b) => a + b) / storeModel.storeRatings!.length
          : 0.0,
      description: storeModel.description ?? storeModel.storeDescription ?? 'Aucune description',
    );
  }
}

// Événements
abstract class HomeClientEvent extends Equatable {
  const HomeClientEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeClientEvent {}

class LoadCartStatus extends HomeClientEvent {}

class SearchProducts extends HomeClientEvent {
  final String query;

  const SearchProducts({required this.query});

  @override
  List<Object?> get props => [query];
}

class FilterByCategory extends HomeClientEvent {
  final String category;

  const FilterByCategory({required this.category});

  @override
  List<Object?> get props => [category];
}

class AddToCart extends HomeClientEvent {
  final Product product;

  const AddToCart({required this.product});

  @override
  List<Object?> get props => [product];
}

class AddToFavorites extends HomeClientEvent {
  final dynamic item; // Product ou Store
  final String type; // 'product' ou 'store'

  const AddToFavorites({required this.item, required this.type});

  @override
  List<Object?> get props => [item, type];
}

class RefreshHomeData extends HomeClientEvent {}

class StartRealtimeSync extends HomeClientEvent {}

class StopRealtimeSync extends HomeClientEvent {}

class UpdateProductsEvent extends HomeClientEvent {
  final List<Product> products;
  final List<Product> filteredProducts;

  UpdateProductsEvent({required this.products, required this.filteredProducts});

  @override
  List<Object?> get props => [products, filteredProducts];
}

class UpdateStoresEvent extends HomeClientEvent {
  final List<StoreClient> stores;
  final List<StoreClient> filteredStores;

  UpdateStoresEvent({required this.stores, required this.filteredStores});

  @override
  List<Object?> get props => [stores, filteredStores];
}

// États
abstract class HomeClientState extends Equatable {
  const HomeClientState();

  @override
  List<Object?> get props => [];
}

class HomeClientInitial extends HomeClientState {}

class HomeClientLoading extends HomeClientState {}

class HomeClientLoaded extends HomeClientState {
  final List<Product> products;
  final List<StoreClient> stores;
  final List<Product> filteredProducts;
  final List<StoreClient> filteredStores;
  final String? searchQuery;
  final String? selectedCategory;
  final bool isFromCache;
  final Set<String> cartProductIds; // IDs des produits dans le panier

  const HomeClientLoaded({
    required this.products,
    required this.stores,
    required this.filteredProducts,
    required this.filteredStores,
    this.searchQuery,
    this.selectedCategory,
    this.isFromCache = false,
    this.cartProductIds = const {},
  });

  @override
  List<Object?> get props => [
        products,
        stores,
        filteredProducts,
        filteredStores,
        searchQuery,
        selectedCategory,
        isFromCache,
        cartProductIds,
      ];

  HomeClientLoaded copyWith({
    List<Product>? products,
    List<StoreClient>? stores,
    List<Product>? filteredProducts,
    List<StoreClient>? filteredStores,
    String? searchQuery,
    String? selectedCategory,
    bool? isFromCache,
    Set<String>? cartProductIds,
  }) {
    return HomeClientLoaded(
      products: products ?? this.products,
      stores: stores ?? this.stores,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      filteredStores: filteredStores ?? this.filteredStores,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isFromCache: isFromCache ?? this.isFromCache,
      cartProductIds: cartProductIds ?? this.cartProductIds,
    );
  }
}

class HomeClientError extends HomeClientState {
  final String message;
  final bool hasCachedData;

  const HomeClientError({required this.message, this.hasCachedData = false});

  @override
  List<Object?> get props => [message, hasCachedData];
}

class HomeClientOffline extends HomeClientState {
  final List<Product> products;
  final List<StoreClient> stores;
  final List<Product> filteredProducts;
  final List<StoreClient> filteredStores;
  final String message;

  const HomeClientOffline({
    required this.products,
    required this.stores,
    required this.filteredProducts,
    required this.filteredStores,
    required this.message,
  });

  @override
  List<Object?> get props => [products, stores, filteredProducts, filteredStores, message];
}

// BLoC
class HomeClientBloc extends Bloc<HomeClientEvent, HomeClientState> {
  final FirestoreService _firestoreService = FirestoreService();
  final ProductRepository _productRepository = ProductRepository();
  final CartService _cartService = CartService();
  
  // Streams pour la synchronisation en temps réel
  StreamSubscription<List<Produit>>? _productsSubscription;
  StreamSubscription<List<Store>>? _storesSubscription;
  bool _isInitialized = false;

  HomeClientBloc() : super(HomeClientInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<LoadCartStatus>(_onLoadCartStatus);
    on<SearchProducts>(_onSearchProducts);
    on<FilterByCategory>(_onFilterByCategory);
    on<AddToCart>(_onAddToCart);
    on<AddToFavorites>(_onAddToFavorites);
    on<RefreshHomeData>(_onRefreshHomeData);
    on<StartRealtimeSync>(_onStartRealtimeSync);
    on<StopRealtimeSync>(_onStopRealtimeSync);
    on<UpdateProductsEvent>(_onUpdateProductsEvent);
    on<UpdateStoresEvent>(_onUpdateStoresEvent);
  }

  @override
  Future<void> close() {
    _productsSubscription?.cancel();
    _storesSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeClientState> emit,
  ) async {
    emit(HomeClientLoading());

    try {
      // Valider et nettoyer le cache si nécessaire
      await CacheManager.validateAndCleanCache();
      
      // Vérifier d'abord le cache
      final cachedProducts = CacheManager.getCachedProducts();
      final cachedStores = CacheManager.getCachedStores();
      
      if (cachedProducts.isNotEmpty || cachedStores.isNotEmpty) {
        // Créer un map des noms de boutiques pour les produits en cache
        final storeMap = {for (var store in cachedStores) store.storeId: store.storeInfos?['name'] ?? 'Boutique'};
        
        final productList = cachedProducts.map((p) => Product.fromProduit(p, storeName: storeMap[p.storeId])).toList();
        final storeList = cachedStores.map((s) => StoreClient.fromStoreModel(s)).toList();
        
        emit(HomeClientLoaded(
          products: productList,
          stores: storeList,
          filteredProducts: productList,
          filteredStores: storeList,
          isFromCache: true,
        ));
        
        // Charger l'état du panier après l'émission des données
        add(LoadCartStatus());
      }

      // Vérifier la connectivité
      final isOnline = await CacheManager.isOnline();
      if (!isOnline) {
        if (cachedProducts.isNotEmpty || cachedStores.isNotEmpty) {
          // Créer un map des noms de boutiques pour les produits en cache
          final storeMap = {for (var store in cachedStores) store.storeId: store.storeInfos?['name'] ?? 'Boutique'};
          
          final productList = cachedProducts.map((p) => Product.fromProduit(p, storeName: storeMap[p.storeId])).toList();
          final storeList = cachedStores.map((s) => StoreClient.fromStoreModel(s)).toList();
          
          emit(HomeClientOffline(
            products: productList,
            stores: storeList,
            filteredProducts: productList,
            filteredStores: storeList,
            message: 'Mode hors ligne - Données en cache affichées',
          ));
        } else {
          emit(HomeClientError(
            message: 'Aucune donnée disponible hors ligne. Veuillez vérifier votre connexion.',
            hasCachedData: false,
          ));
        }
        return;
      }

      // Récupérer les données depuis Firestore
      final productsStream = _productRepository.getAllActiveProducts();
      final products = await productsStream.first;
      
      final storesStream = _firestoreService.getAllStores();
      final stores = await storesStream.first;
      final storeList = stores.map((s) => StoreClient.fromStoreModel(s)).toList();
      
      // Créer un map des noms de boutiques pour les produits
      final storeMap = {for (var store in stores) store.storeId: store.storeInfos?['name'] ?? 'Boutique'};
      
      final productList = products.map((p) => Product.fromProduit(p, storeName: storeMap[p.storeId])).toList();

      // Mettre en cache les données
      await CacheManager.cacheProducts(products);
      await CacheManager.cacheStores(stores);

      emit(HomeClientLoaded(
        products: productList,
        stores: storeList,
        filteredProducts: productList,
        filteredStores: storeList,
        isFromCache: false,
      ));
      
      // Charger l'état du panier après l'émission des données
      add(LoadCartStatus());
      
      // Démarrer la synchronisation en temps réel
      if (!_isInitialized) {
        add(StartRealtimeSync());
        _isInitialized = true;
      }
    } catch (e) {
      // En cas d'erreur, essayer d'utiliser le cache
      final cachedProducts = CacheManager.getCachedProducts();
      final cachedStores = CacheManager.getCachedStores();
      
      if (cachedProducts.isNotEmpty || cachedStores.isNotEmpty) {
        // Créer un map des noms de boutiques pour les produits en cache
        final storeMap = {for (var store in cachedStores) store.storeId: store.storeInfos?['name'] ?? 'Boutique'};
        
        final productList = cachedProducts.map((p) => Product.fromProduit(p, storeName: storeMap[p.storeId])).toList();
        final storeList = cachedStores.map((s) => StoreClient.fromStoreModel(s)).toList();
        
        emit(HomeClientOffline(
          products: productList,
          stores: storeList,
          filteredProducts: productList,
          filteredStores: storeList,
          message: 'Erreur de connexion. Données en cache affichées.',
        ));
      } else {
        emit(HomeClientError(
          message: 'Erreur lors du chargement des données: $e',
          hasCachedData: false,
        ));
      }
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<HomeClientState> emit,
  ) async {
    if (state is HomeClientLoaded || state is HomeClientOffline) {
      try {
        List<Product> filteredProducts;
        List<StoreClient> filteredStores;
        List<Product> allProducts;
        List<StoreClient> allStores;
        String message = '';

        if (state is HomeClientLoaded) {
          final currentState = state as HomeClientLoaded;
          allProducts = currentState.products;
          allStores = currentState.stores;
        } else {
          final currentState = state as HomeClientOffline;
          allProducts = currentState.products;
          allStores = currentState.stores;
          message = currentState.message;
        }

        filteredProducts = allProducts;
        filteredStores = allStores;

        if (event.query.isNotEmpty) {
          final isOnline = await CacheManager.isOnline();
          
          if (isOnline) {
            // Recherche en ligne
            final searchResults = await _productRepository.searchProducts(event.query);
            filteredProducts = searchResults.map((p) => Product.fromProduit(p)).toList();
          } else {
            // Recherche dans le cache
            filteredProducts = allProducts.where((product) {
              return product.name.toLowerCase().contains(event.query.toLowerCase()) ||
                  product.description.toLowerCase().contains(event.query.toLowerCase());
            }).toList();
          }

          // Recherche dans les boutiques (toujours depuis le cache)
          filteredStores = allStores.where((store) {
            return store.name.toLowerCase().contains(event.query.toLowerCase()) ||
                store.description.toLowerCase().contains(event.query.toLowerCase());
          }).toList();
        }

        if (state is HomeClientLoaded) {
          final currentState = state as HomeClientLoaded;
          emit(currentState.copyWith(
            filteredProducts: filteredProducts,
            filteredStores: filteredStores,
            searchQuery: event.query,
          ));
        } else {
          emit(HomeClientOffline(
            products: allProducts,
            stores: allStores,
            filteredProducts: filteredProducts,
            filteredStores: filteredStores,
            message: message,
          ));
        }
      } catch (e) {
        emit(HomeClientError(message: 'Erreur lors de la recherche: $e'));
      }
    }
  }

  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<HomeClientState> emit,
  ) async {
    if (state is HomeClientLoaded || state is HomeClientOffline) {
      try {
        List<Product> filteredProducts;
        List<Product> allProducts;
        List<StoreClient> allStores;
        List<StoreClient> filteredStores;
        String message = '';

        if (state is HomeClientLoaded) {
          final currentState = state as HomeClientLoaded;
          allProducts = currentState.products;
          allStores = currentState.stores;
          filteredStores = currentState.filteredStores;
        } else {
          final currentState = state as HomeClientOffline;
          allProducts = currentState.products;
          allStores = currentState.stores;
          filteredStores = currentState.filteredStores;
          message = currentState.message;
        }

        filteredProducts = allProducts;

        if (event.category != 'Tous') {
          final isOnline = await CacheManager.isOnline();
          
          if (isOnline) {
            // Filtrage en ligne
            final categoryResults = await _productRepository.getProductsByCategory(event.category);
            filteredProducts = categoryResults.map((p) => Product.fromProduit(p)).toList();
          } else {
            // Filtrage dans le cache
            filteredProducts = allProducts.where((product) {
              return product.category == event.category;
            }).toList();
          }
        }

        if (state is HomeClientLoaded) {
          final currentState = state as HomeClientLoaded;
          emit(currentState.copyWith(
            filteredProducts: filteredProducts,
            selectedCategory: event.category,
          ));
        } else {
          emit(HomeClientOffline(
            products: allProducts,
            stores: allStores,
            filteredProducts: filteredProducts,
            filteredStores: filteredStores,
            message: message,
          ));
        }
      } catch (e) {
        emit(HomeClientError(message: 'Erreur lors du filtrage: $e'));
      }
    }
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<HomeClientState> emit,
  ) async {
    // TODO: Implémenter l'ajout au panier
    // Pour l'instant, on ne fait rien
    print('Produit ajouté au panier: ${event.product.name}');
  }

  Future<void> _onAddToFavorites(
    AddToFavorites event,
    Emitter<HomeClientState> emit,
  ) async {
    // TODO: Implémenter l'ajout aux favoris
    // Pour l'instant, on ne fait rien
    print('Ajouté aux favoris: ${event.type}');
  }

  Future<void> _onLoadCartStatus(
    LoadCartStatus event,
    Emitter<HomeClientState> emit,
  ) async {
    if (state is HomeClientLoaded) {
      final currentState = state as HomeClientLoaded;
      try {
        final cartProductIds = await _cartService.getCartProductIds();
        emit(currentState.copyWith(cartProductIds: cartProductIds.toSet()));
      } catch (e) {
        print('Erreur lors du chargement de l\'état du panier: $e');
        // En cas d'erreur, on garde l'état actuel
      }
    }
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeClientState> emit,
  ) async {
    // Nettoyer le cache et forcer le rechargement depuis Firestore
    await CacheManager.clearAllProductCache();
    add(LoadHomeData());
  }

  /// Démarre la synchronisation en temps réel avec Firestore
  Future<void> _onStartRealtimeSync(
    StartRealtimeSync event,
    Emitter<HomeClientState> emit,
  ) async {
    try {
      // Vérifier la connectivité
      final isOnline = await CacheManager.isOnline();
      if (!isOnline) {
        print('Pas de connexion internet, synchronisation en temps réel impossible');
        return;
      }

      print('Démarrage de la synchronisation en temps réel...');

      // Stream des produits en temps réel
      _productsSubscription = _productRepository.getAllActiveProducts().listen(
        (products) {
          print('Mise à jour des produits reçue: ${products.length} produits');
          _updateProductsInState(products);
        },
        onError: (error) {
          print('Erreur dans le stream des produits: $error');
        },
      );

      // Stream des boutiques en temps réel
      _storesSubscription = _firestoreService.getAllStores().listen(
        (stores) {
          print('Mise à jour des boutiques reçue: ${stores.length} boutiques');
          _updateStoresInState(stores);
        },
        onError: (error) {
          print('Erreur dans le stream des boutiques: $error');
        },
      );

      print('Synchronisation en temps réel démarrée avec succès');
    } catch (e) {
      print('Erreur lors du démarrage de la synchronisation en temps réel: $e');
    }
  }

  /// Arrête la synchronisation en temps réel
  Future<void> _onStopRealtimeSync(
    StopRealtimeSync event,
    Emitter<HomeClientState> emit,
  ) async {
    print('Arrêt de la synchronisation en temps réel...');
    await _productsSubscription?.cancel();
    await _storesSubscription?.cancel();
    _productsSubscription = null;
    _storesSubscription = null;
    _isInitialized = false;
    print('Synchronisation en temps réel arrêtée');
  }

  /// Met à jour les produits dans l'état actuel
  void _updateProductsInState(List<Produit> products) {
    if (state is HomeClientLoaded) {
      final currentState = state as HomeClientLoaded;
      
      // Créer un map des noms de boutiques pour les produits
      _firestoreService.getAllStores().first.then((stores) async {
        final storeMap = {for (var store in stores) store.storeId: store.storeInfos?['name'] ?? 'Boutique'};
        
        final productList = products.map((p) => Product.fromProduit(p, storeName: storeMap[p.storeId])).toList();
        
        // Mettre en cache les nouvelles données
        await CacheManager.cacheProducts(products);
        
        // Appliquer les filtres actuels
        final filteredProducts = _applyCurrentFilters(productList, currentState);
        
        // Utiliser add() pour déclencher un nouvel événement
        add(UpdateProductsEvent(
          products: productList,
          filteredProducts: filteredProducts,
        ));
      }).catchError((error) {
        print('Erreur lors de la mise à jour des produits: $error');
      });
    }
  }

  /// Met à jour les boutiques dans l'état actuel
  void _updateStoresInState(List<Store> stores) {
    if (state is HomeClientLoaded) {
      final currentState = state as HomeClientLoaded;
      
      final storeList = stores.map((s) => StoreClient.fromStoreModel(s)).toList();
      
      // Mettre en cache les nouvelles données
      CacheManager.cacheStores(stores).then((_) {
        // Appliquer les filtres actuels
        final filteredStores = _applyCurrentFiltersToStores(storeList, currentState);
        
        // Utiliser add() pour déclencher un nouvel événement
        add(UpdateStoresEvent(
          stores: storeList,
          filteredStores: filteredStores,
        ));
      }).catchError((error) {
        print('Erreur lors de la mise à jour des boutiques: $error');
      });
    }
  }

  /// Applique les filtres actuels aux produits
  List<Product> _applyCurrentFilters(List<Product> products, HomeClientLoaded currentState) {
    // Ici on pourrait appliquer les filtres de recherche et de catégorie actuels
    // Pour l'instant, on retourne tous les produits
    return products;
  }

  /// Applique les filtres actuels aux boutiques
  List<StoreClient> _applyCurrentFiltersToStores(List<StoreClient> stores, HomeClientLoaded currentState) {
    // Ici on pourrait appliquer les filtres de recherche actuels
    // Pour l'instant, on retourne toutes les boutiques
    return stores;
  }

  /// Gère la mise à jour des produits depuis les streams
  Future<void> _onUpdateProductsEvent(
    UpdateProductsEvent event,
    Emitter<HomeClientState> emit,
  ) async {
    if (state is HomeClientLoaded) {
      final currentState = state as HomeClientLoaded;
      emit(currentState.copyWith(
        products: event.products,
        filteredProducts: event.filteredProducts,
        isFromCache: false,
      ));
    }
  }

  /// Gère la mise à jour des boutiques depuis les streams
  Future<void> _onUpdateStoresEvent(
    UpdateStoresEvent event,
    Emitter<HomeClientState> emit,
  ) async {
    if (state is HomeClientLoaded) {
      final currentState = state as HomeClientLoaded;
      emit(currentState.copyWith(
        stores: event.stores,
        filteredStores: event.filteredStores,
        isFromCache: false,
      ));
    }
  }

}
