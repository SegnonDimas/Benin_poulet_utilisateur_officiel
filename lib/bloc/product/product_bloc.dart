import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:benin_poulet/core/firebase/firestore/product_repository.dart';
import 'package:benin_poulet/core/firebase/auth/auth_services.dart';
import 'package:benin_poulet/models/produit.dart';
import 'package:benin_poulet/services/cache_manager.dart';

// Événements
abstract class ProductEvent {}

class LoadVendorProducts extends ProductEvent {}

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

  ProductBloc() : super(ProductInitial()) {
    on<LoadVendorProducts>(_onLoadVendorProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<RefreshProducts>(_onRefreshProducts);
    on<RechercherProduit>(_onRechercherProduit);
    on<ReinitialiserRecherche>(_onReinitialiserRecherche);
    
    // Charger automatiquement les produits du vendeur au démarrage
    add(LoadVendorProducts());
  }

  Future<void> _onLoadVendorProducts(
    LoadVendorProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    try {
      final currentUserId = AuthServices.userId;
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

      // Récupérer les données depuis Firestore
      _productRepository.getProductsBySeller(currentUserId).listen(
        (products) async {
          await CacheManager.cacheVendorProducts(currentUserId, products);
          emit(ProductsLoaded(products, isFromCache: false));
        },
        onError: (error) => emit(ProductError('Erreur lors du chargement des produits: $error')),
      );
    } catch (e) {
      // En cas d'erreur, essayer d'utiliser le cache
      final currentUserId = AuthServices.userId;
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

  Future<void> _onAddProduct(
    AddProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final currentUserId = AuthServices.userId;
      if (currentUserId == null) {
        emit(ProductError('Aucun utilisateur connecté'));
        return;
      }

      // S'assurer que le produit a le bon sellerId
      final productWithSellerId = event.product.copyWith(sellerId: currentUserId);

      final isOnline = await CacheManager.isOnline();
      if (isOnline) {
        final productId = await _productRepository.createProduct(productWithSellerId);
        final createdProduct = productWithSellerId.copyWith(productId: productId);
        
        // Mettre en cache le nouveau produit
        final cachedProducts = CacheManager.getCachedVendorProducts(currentUserId);
        cachedProducts.add(createdProduct);
        await CacheManager.cacheVendorProducts(currentUserId, cachedProducts);
        
        emit(ProductAdded(createdProduct));
      } else {
        // Mode hors ligne - ajouter à la file d'attente
        await CacheManager.addOfflineAction({
          'type': 'create_product',
          'data': productWithSellerId.toMap(),
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
        final currentUserId = AuthServices.userId;
        if (currentUserId != null) {
          final cachedProducts = CacheManager.getCachedVendorProducts(currentUserId);
          cachedProducts.removeWhere((product) => product.productId == event.productId);
          await CacheManager.cacheVendorProducts(currentUserId, cachedProducts);
        }
        
        emit(ProductDeleted(event.productId));
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
    // Forcer le rechargement depuis Firestore
    add(LoadVendorProducts());
  }

  void _onRechercherProduit(
    RechercherProduit event,
    Emitter<ProductState> emit,
  ) {
    // Récupérer les produits actuels depuis le cache ou l'état
    final currentState = state;
    List<Produit> produits = [];
    
    if (currentState is ProductsLoaded) {
      produits = currentState.products;
    } else if (currentState is ProductsOffline) {
      produits = currentState.cachedProducts;
    } else if (currentState is ProduitFiltre) {
      produits = currentState.produits;
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
    // Recharger tous les produits
    add(LoadVendorProducts());
  }
}
