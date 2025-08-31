import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:benin_poulet/core/firebase/firestore/firestore_service.dart';
import 'package:benin_poulet/core/firebase/firestore/product_repository.dart';
import 'package:benin_poulet/models/produit.dart';
import 'package:benin_poulet/models/store.dart';
import 'package:benin_poulet/services/cache_manager.dart';
import 'package:benin_poulet/services/sync_service.dart';

// Modèles adaptés pour l'interface client
class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  final String category;
  final String storeId; // Ajout du storeId pour les avis
  final String storeName; // Ajout du nom de la boutique

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.category,
    required this.storeId,
    required this.storeName,
  });

  factory Product.fromProduit(Produit produit, {String? storeName}) {
    return Product(
      id: produit.productId ?? '',
      name: produit.productName,
      imageUrl: produit.productImagesPath.isNotEmpty ? produit.productImagesPath.first : '',
      price: produit.isInPromotion && produit.promoPrice != null ? produit.promoPrice! : produit.productUnitPrice,
      description: produit.productDescription,
      category: produit.category,
      storeId: produit.storeId,
      storeName: storeName ?? 'Boutique',
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

  const HomeClientLoaded({
    required this.products,
    required this.stores,
    required this.filteredProducts,
    required this.filteredStores,
    this.searchQuery,
    this.selectedCategory,
    this.isFromCache = false,
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
      ];

  HomeClientLoaded copyWith({
    List<Product>? products,
    List<StoreClient>? stores,
    List<Product>? filteredProducts,
    List<StoreClient>? filteredStores,
    String? searchQuery,
    String? selectedCategory,
    bool? isFromCache,
  }) {
    return HomeClientLoaded(
      products: products ?? this.products,
      stores: stores ?? this.stores,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      filteredStores: filteredStores ?? this.filteredStores,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isFromCache: isFromCache ?? this.isFromCache,
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

  HomeClientBloc() : super(HomeClientInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<SearchProducts>(_onSearchProducts);
    on<FilterByCategory>(_onFilterByCategory);
    on<AddToCart>(_onAddToCart);
    on<AddToFavorites>(_onAddToFavorites);
    on<RefreshHomeData>(_onRefreshHomeData);
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

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeClientState> emit,
  ) async {
    // Nettoyer le cache et forcer le rechargement depuis Firestore
    await CacheManager.clearAllProductCache();
    add(LoadHomeData());
  }
}
